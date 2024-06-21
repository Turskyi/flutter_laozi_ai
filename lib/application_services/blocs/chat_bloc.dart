import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:injectable/injectable.dart';
import 'package:laozi_ai/domain_services/chat_repository.dart';
import 'package:laozi_ai/domain_services/email_repository.dart';
import 'package:laozi_ai/domain_services/settings_repository.dart';
import 'package:laozi_ai/entities/chat.dart';
import 'package:laozi_ai/entities/enums/language.dart';
import 'package:laozi_ai/entities/enums/role.dart';
import 'package:laozi_ai/entities/message.dart';
import 'package:laozi_ai/res/constants.dart' as constants;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

part 'chat_event.dart';
part 'chat_state.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(
    this._chatRepository,
    this._settingsRepository,
    this._emailRepository,
  ) : super(const LoadingHomeState()) {
    on<LoadHomeEvent>(
      (_, Emitter<ChatState> emit) {
        final Language savedLanguage = _settingsRepository.getLanguage();
        emit(ChatInitial(language: savedLanguage, messages: state.messages));
      },
    );
    on<SendMessageEvent>((SendMessageEvent event, Emitter<ChatState> emit) {
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
            .sendChat(Chat(messages: state.messages, language: state.language))
            .listen((String line) => add(UpdateAiMessageEvent(line)));
      } catch (error) {
        _emitChatError(emit: emit, error: error);
      }
    });
    on<UpdateAiMessageEvent>((
      UpdateAiMessageEvent event,
      Emitter<ChatState> emit,
    ) {
      if (state.messages.isNotEmpty && state.messages.last.isAi) {
        state.messages.last.content.write(event.pieceOfMessage);
        emit(
          AiMessageUpdated(messages: state.messages, language: state.language),
        );
      } else {
        final List<Message> updatedMessages = List<Message>.from(state.messages)
          ..add(
            Message(
              role: Role.assistant,
              content: StringBuffer(event.pieceOfMessage),
            ),
          );
        emit(
          AiMessageUpdated(messages: updatedMessages, language: state.language),
        );
      }
    });

    on<ChangeLanguageEvent>(
      (
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
                ChatError() =>
                  (state as ChatError).copyWith(language: language),
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
            add(const LoadHomeEvent());
          }
        }
      },
    );

    on<BugReportPressedEvent>((_, Emitter<ChatState> emit) {
      emit(
        FeedbackState(
          messages: state.messages,
          language: state.language,
        ),
      );
    });

    on<ClosingFeedbackEvent>((_, Emitter<ChatState> emit) {
      emit(
        AiMessageUpdated(messages: state.messages, language: state.language),
      );
    });
    on<SubmitFeedbackEvent>(
        (SubmitFeedbackEvent event, Emitter<ChatState> emit) async {
      emit(
        LoadingHomeState(messages: state.messages, language: state.language),
      );
      final UserFeedback feedback = event.feedback;
      try {
        final String screenshotFilePath =
            await _writeImageToStorage(feedback.screenshot);
        final PackageInfo packageInfo = await PackageInfo.fromPlatform();
        final Email email = Email(
          body: '${feedback.text}\n\nApp id: ${packageInfo.packageName}\n'
              'App version: ${packageInfo.version}\n'
              'Build number: ${packageInfo.buildNumber}',
          subject: '${translate('feedback.appFeedback')}: '
              '${packageInfo.appName}',
          recipients: <String>[constants.supportEmail],
          attachmentPaths: <String>[screenshotFilePath],
        );
        try {
          await FlutterEmailSender.send(email);
        } catch (error) {
          try {
            await _emailRepository.sendFeedback(email);
            emit(
              FeedbackSent(messages: state.messages, language: state.language),
            );
          } catch (error) {
            _emitChatError(emit: emit, error: error);
          }
        }
      } catch (error) {
        _emitChatError(emit: emit, error: error);
      }
      emit(
        AiMessageUpdated(messages: state.messages, language: state.language),
      );
    });
  }

  final ChatRepository _chatRepository;
  final SettingsRepository _settingsRepository;
  final EmailRepository _emailRepository;

  Future<String> _writeImageToStorage(Uint8List feedbackScreenshot) async {
    final Directory output = await getTemporaryDirectory();
    final String screenshotFilePath = '${output.path}/feedback.png';
    final File screenshotFile = File(screenshotFilePath);
    await screenshotFile.writeAsBytes(feedbackScreenshot);
    return screenshotFilePath;
  }

  void _emitChatError({
    required Emitter<ChatState> emit,
    required Object error,
  }) =>
      emit(
        ChatError(
          errorMessage: '$error',
          messages: state.messages,
          language: state.language,
        ),
      );
}
