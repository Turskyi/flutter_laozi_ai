import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:laozi_ai/domain_services/chat_repository.dart';
import 'package:laozi_ai/domain_services/settings_repository.dart';
import 'package:laozi_ai/entities/chat.dart';
import 'package:laozi_ai/entities/enums/language.dart';
import 'package:laozi_ai/entities/enums/role.dart';
import 'package:laozi_ai/entities/message.dart';
import 'package:laozi_ai/entities/web_service_exception.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(
    this._chatRepository,
    this._settingsRepository,
  ) : super(const LoadingHomeState()) {
    on<LoadHomeEvent>(
      (_, Emitter<ChatState> emit) {
        final Language savedLanguage = _settingsRepository.getLanguage();
        emit(ChatInitial(language: savedLanguage));
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
      } on WebServiceException catch (error) {
        emit(
          ChatError(
            errorMessage: error.message,
            messages: state.messages,
            language: state.language,
          ),
        );
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
                _ => state,
              },
            );
          } else {
            add(const LoadHomeEvent());
          }
        }
      },
    );
  }

  final ChatRepository _chatRepository;
  final SettingsRepository _settingsRepository;
}
