import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:laozi_ai/domain_services/chat_repository.dart';
import 'package:laozi_ai/domain_services/settings_repository.dart';
import 'package:laozi_ai/entities/chat.dart';
import 'package:laozi_ai/entities/enums/feedback_rating.dart';
import 'package:laozi_ai/entities/enums/feedback_type.dart';
import 'package:laozi_ai/entities/enums/language.dart';
import 'package:laozi_ai/entities/enums/role.dart';
import 'package:laozi_ai/entities/message.dart';
import 'package:laozi_ai/res/constants.dart' as constants;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

part 'chat_event.dart';
part 'chat_state.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(
    this._chatRepository,
    this._settingsRepository,
  ) : super(const LoadingHomeState()) {
    on<LoadHomeEvent>(_onLoadHomeEvent);

    on<SendMessageEvent>(_onSendMessageEvent);

    on<UpdateAiMessageEvent>(_onUpdateAiMessageEvent);

    on<ChangeLanguageEvent>(_onChangeLanguageEvent);

    on<BugReportPressedEvent>(_onBugReportPressedEvent);

    on<ClosingFeedbackEvent>(_onClosingFeedbackEvent);

    on<SubmitFeedbackEvent>(_onSubmitFeedbackEvent);

    on<RetrySendMessageEvent>(_onRetrySendMessageEvent);

    on<ErrorEvent>(_onErrorEvent);

    on<LaunchUrlEvent>(_onLaunchUrlEvent);
  }

  final ChatRepository _chatRepository;
  final SettingsRepository _settingsRepository;

  FutureOr<void> _onLaunchUrlEvent(
    LaunchUrlEvent event,
    Emitter<ChatState> emit,
  ) async {
    final String href = event.url;
    if (href.startsWith('/')) {
      final String primaryUrl = '${constants.primaryWebsiteUrl}$href';
      final String fallbackUrl = '${constants.fallbackWebsiteUrl}$href';

      try {
        final http.Response response = await http.head(Uri.parse(primaryUrl));

        if (response.statusCode == HttpStatus.ok) {
          // Website is likely active and serving content.
          await _launchUrl(primaryUrl);
        } else {
          // Website might not be active, or returned an error.
          await _launchUrl(fallbackUrl);
        }
      } catch (e) {
        // An error occurred during the HTTP request (e.g., network issue,
        // domain not resolving).
        debugPrint('HTTP error checking $primaryUrl: $e');
        await _launchUrl(fallbackUrl);
      }
    } else {
      // TODO: tell user that we have an issue with an attempt to launch this
      //  url.
    }
  }

  /// Launches a given URL.
  /// Displays an error message if the URL cannot be launched.
  Future<void> _launchUrl(String url) async {
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      // Handle potential errors during URL launching (less common than HTTP
      // errors, but good to be safe).
      debugPrint('Error launching URL $url: $e');
    }
  }

  FutureOr<void> _onErrorEvent(ErrorEvent event, Emitter<ChatState> emit) {
    emit(
      ChatError(
        errorMessage: event.error,
        messages: state.messages,
        language: state.language,
      ),
    );
  }

  FutureOr<void> _onRetrySendMessageEvent(
    RetrySendMessageEvent _,
    Emitter<ChatState> emit,
  ) async {
    final List<Message> currentMessages = List<Message>.from(state.messages);
    emit(
      SentMessageState(
        messages: currentMessages,
        language: state.language,
      ),
    );
    _chatRepository
        .sendChat(Chat(messages: currentMessages, language: state.language))
        .listen(
      (String line) => add(UpdateAiMessageEvent(line)),
      onError: (Object error, StackTrace stackTrace) {
        if (error is DioException) {
          _handleDioError(
            error: error,
            stackTrace: stackTrace,
            isSendMessage: false,
          );
        } else {
          // General error handling for non-DioExceptions.
          debugPrint(
            'Error in $runtimeType in `onError` (RetrySendMessageEvent): '
            '$error.\n'
            'Stacktrace: $stackTrace',
          );
          add(ErrorEvent(translate('error.unexpected_error')));
        }
      },
    );
  }

  FutureOr<void> _onSubmitFeedbackEvent(
    SubmitFeedbackEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(
      LoadingHomeState(messages: state.messages, language: state.language),
    );
    final UserFeedback feedback = event.feedback;
    try {
      final String screenshotFilePath =
          await _writeImageToStorage(feedback.screenshot);

      final PackageInfo packageInfo = await PackageInfo.fromPlatform();

      final Map<String, Object?>? extra = feedback.extra;
      final Object? rating = extra?['rating'];
      final Object? type = extra?['feedback_type'];

      // Construct the feedback text with details from `extra'.
      final StringBuffer feedbackBody = StringBuffer()
        ..writeln('${type is FeedbackType ? translate('feedback.type') : ''}:'
            ' ${type is FeedbackType ? type.value : ''}')
        ..writeln()
        ..writeln(feedback.text)
        ..writeln()
        ..writeln('${translate('app_id')}: ${packageInfo.packageName}')
        ..writeln('${translate('app_version')}: ${packageInfo.version}')
        ..writeln('${translate('build_number')}: ${packageInfo.buildNumber}')
        ..writeln()
        ..writeln(
            '${rating is FeedbackRating ? translate('feedback.rating') : ''}'
            '${rating is FeedbackRating ? ':' : ''}'
            ' ${rating is FeedbackRating ? rating.value : ''}');

      final Email email = Email(
        body: feedbackBody.toString(),
        subject: '${translate('feedback.app_feedback')}: '
            '${packageInfo.appName}',
        recipients: <String>[constants.supportEmail],
        attachmentPaths: <String>[screenshotFilePath],
      );
      try {
        await FlutterEmailSender.send(email);
      } catch (error, stackTrace) {
        debugPrint(
          'Error in $runtimeType sending email: $error.\n'
          'Stacktrace: $stackTrace',
        );
        add(ErrorEvent(translate('error.unexpected_error_sending_feedback')));
      }
    } catch (error, stackTrace) {
      debugPrint(
        'Error in $runtimeType preparing feedback: $error.\n'
        'Stacktrace: $stackTrace',
      );
      add(ErrorEvent(translate('error.unexpected_error_preparing_feedback')));
    }
    emit(
      AiMessageUpdated(messages: state.messages, language: state.language),
    );
  }

  FutureOr<void> _onClosingFeedbackEvent(
    ClosingFeedbackEvent _,
    Emitter<ChatState> emit,
  ) {
    emit(
      AiMessageUpdated(messages: state.messages, language: state.language),
    );
  }

  FutureOr<void> _onLoadHomeEvent(LoadHomeEvent _, Emitter<ChatState> emit) {
    final Language savedLanguage = _settingsRepository.getLanguage();
    emit(ChatInitial(language: savedLanguage, messages: state.messages));
  }

  FutureOr<void> _onSendMessageEvent(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) {
    // Create a new list of messages by adding the new message to the
    // existing list.
    final List<Message> updatedMessages = List<Message>.from(state.messages)
      ..add(Message(role: Role.user, content: StringBuffer(event.message)));
    // Emit a new state with the updated list of messages.
    emit(
      SentMessageState(messages: updatedMessages, language: state.language),
    );
    try {
      _chatRepository
          .sendChat(Chat(messages: updatedMessages, language: state.language))
          .listen(
        (String line) => add(UpdateAiMessageEvent(line)),
        onError: (Object error, StackTrace stackTrace) {
          if (error is DioException) {
            _handleDioError(
              error: error,
              stackTrace: stackTrace,
              isSendMessage: true,
            );
          } else {
            debugPrint(
              'Error in $runtimeType in `onError` (SendMessageEvent): $error.\n'
              'Stacktrace: $stackTrace',
            );
            add(ErrorEvent(translate('error.unexpected_error')));
          }
        },
      );
    } catch (error, stackTrace) {
      debugPrint(
        'Error in $runtimeType in `catch` (SendMessageEvent): $error.\n'
        'Stacktrace: $stackTrace',
      );
      add(
        ErrorEvent(translate('error.oops_something_went_wrong')),
      );
    }
  }

  void _handleDioError({
    required DioException error,
    required StackTrace stackTrace,
    required bool isSendMessage,
  }) {
    final StringBuffer buffer = StringBuffer();
    buffer.writeln(
      'DioException caught in '
      '${isSendMessage ? '_onSendMessageEvent' : '_onRetrySendMessageEvent'}:',
    );
    buffer.writeln('  Type: ${error.type}');
    buffer.writeln('  Message: ${error.message}');
    buffer.writeln('  Request Options:');
    buffer.writeln('    Path: ${error.requestOptions.path}');
    buffer.writeln('    Method: ${error.requestOptions.method}');
    buffer.writeln('    Base URL: ${error.requestOptions.baseUrl}');
    if (error.response != null) {
      buffer.writeln('  Response:');
      buffer.writeln('    Data: ${error.response?.data}');
      buffer.writeln('    Headers: ${error.response?.headers}');
      buffer.writeln('    Status Code: ${error.response?.statusCode}');
      buffer.writeln(
        '    Status Message: ${error.response?.statusMessage}',
      );
    }
    if (error.error != null) {
      buffer.writeln('  Underlying error: ${error.error}');
    }
    buffer.writeln('  Stacktrace: $stackTrace');
    debugPrint(buffer.toString());

    String errorMessageKey = 'error.unexpected_network_error';

    switch (error.type) {
      case DioExceptionType.badResponse:
        final int? statusCode = error.response?.statusCode;
        if (statusCode != null) {
          if (isSendMessage && kIsWeb && kDebugMode) {
            errorMessageKey = 'error.cors';
          } else if (statusCode == HttpStatus.gatewayTimeout) {
            errorMessageKey = 'error.gateway_timeout';
          } else if (statusCode >= HttpStatus.internalServerError) {
            errorMessageKey = 'error.server_error_please_try_later';
          } else if (statusCode == HttpStatus.badRequest) {
            errorMessageKey = 'error.bad_request';
          } else if (statusCode == HttpStatus.unauthorized) {
            errorMessageKey = 'error.unauthorized';
          } else if (statusCode == HttpStatus.forbidden) {
            errorMessageKey = 'error.forbidden';
          } else if (statusCode == HttpStatus.notFound) {
            errorMessageKey = 'error.not_found';
          } else if (statusCode == HttpStatus.tooManyRequests) {
            errorMessageKey = 'error.too_many_requests';
          } else if (statusCode >= HttpStatus.badRequest) {
            errorMessageKey = 'error.client_error';
          } else {
            errorMessageKey = 'error.bad_response';
          }
        } else {
          errorMessageKey = isSendMessage && kIsWeb && kDebugMode
              ? 'error.cors'
              : 'error.bad_response_no_status';
        }
        break;
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessageKey = isSendMessage && kIsWeb && kDebugMode
            ? 'error.cors'
            : 'error.request_timeout_check_internet';
        break;
      case DioExceptionType.connectionError:
        errorMessageKey = isSendMessage && kIsWeb && kDebugMode
            ? 'error.cors'
            : 'error.connection_error_check_internet';
        break;
      case DioExceptionType.cancel:
        errorMessageKey = 'error.request_cancelled';
        break;
      case DioExceptionType.unknown:
      default:
        if (error.error is SocketException) {
          errorMessageKey = isSendMessage && kIsWeb && kDebugMode
              ? 'error.cors'
              : 'error.connection_error_check_internet';
        } else {
          errorMessageKey = isSendMessage && kIsWeb && kDebugMode
              ? 'error.cors'
              : 'error.unexpected_network_error';
        }
        break;
    }
    add(ErrorEvent(translate(errorMessageKey)));
  }

  FutureOr<void> _onUpdateAiMessageEvent(
    UpdateAiMessageEvent event,
    Emitter<ChatState> emit,
  ) {
    if (state.messages.isNotEmpty && state.messages.last.isAi) {
      // Copy the last message and update its content.
      final List<Message> updatedMessages = List<Message>.from(state.messages);
      final Message lastMessage = updatedMessages.removeLast();
      final Message updatedLastMessage = lastMessage.copyWith(
        content: StringBuffer(
          lastMessage.content.toString() + event.pieceOfMessage,
        ),
      );
      updatedMessages.add(updatedLastMessage);

      emit(
        AiMessageUpdated(
          messages: updatedMessages,
          language: state.language,
        ),
      );
    } else {
      // Add a new AI message.
      final List<Message> updatedMessages = List<Message>.from(state.messages)
        ..add(
          Message(
            role: Role.assistant,
            content: StringBuffer(event.pieceOfMessage),
          ),
        );

      emit(
        AiMessageUpdated(
          messages: updatedMessages,
          language: state.language,
        ),
      );
    }
  }

  FutureOr<void> _onChangeLanguageEvent(
    ChangeLanguageEvent event,
    Emitter<ChatState> emit,
  ) async {
    final Language language = event.language;
    if (language != state.language) {
      final bool isSaved = await _settingsRepository
          .saveLanguageIsoCode(language.isoLanguageCode);
      if (isSaved) {
        emit(
          switch (state) {
            ChatInitial() =>
              (state as ChatInitial).copyWith(language: language),
            ChatError() => (state as ChatError).copyWith(language: language),
            SentMessageState() =>
              (state as SentMessageState).copyWith(language: language),
            AiMessageUpdated() =>
              (state as AiMessageUpdated).copyWith(language: language),
            LoadingHomeState() =>
              (state as LoadingHomeState).copyWith(language: language),
            FeedbackState() =>
              (state as FeedbackState).copyWith(language: language),
            FeedbackSent() =>
              (state as FeedbackSent).copyWith(language: language),
          },
        );
      } else {
        // If saving fails, revert to previous state or reload home,
        // here it reloads home which re-fetches saved language.
        add(const LoadHomeEvent());
      }
    }
  }

  FutureOr<void> _onBugReportPressedEvent(
    BugReportPressedEvent _,
    Emitter<ChatState> emit,
  ) {
    emit(
      FeedbackState(
        messages: state.messages,
        language: state.language,
      ),
    );
  }

  Future<String> _writeImageToStorage(Uint8List feedbackScreenshot) async {
    final Directory output = await getTemporaryDirectory();
    final String screenshotFilePath = '${output.path}/feedback.png';
    final File screenshotFile = File(screenshotFilePath);
    await screenshotFile.writeAsBytes(feedbackScreenshot);
    return screenshotFilePath;
  }
}
