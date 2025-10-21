import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/application_services/repositories/email_repository_impl.dart';

part 'support_event.dart';
part 'support_state.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  SupportBloc(this._emailRepository) : super(const SupportInitial()) {
    on<SendSupportEmail>(_onSendSupportEmail);
  }

  final EmailRepositoryImpl _emailRepository;

  Future<void> _onSendSupportEmail(
    SendSupportEmail event,
    Emitter<SupportState> emit,
  ) async {
    emit(const SupportLoading());
    try {
      await _emailRepository.sendSupportEmail(
        name: event.name,
        userEmail: event.email,
        message: event.message,
      );
      emit(const SupportSuccess());
    } catch (e) {
      emit(SupportFailure(translate('support_page.failed_to_send_email')));
    }
  }
}
