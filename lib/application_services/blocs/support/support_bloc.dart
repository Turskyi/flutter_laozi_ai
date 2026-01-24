import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:injectable/injectable.dart';
import 'package:laozi_ai/domain_services/email_repository.dart';
import 'package:laozi_ai/entities/enums/language.dart';

part 'support_event.dart';
part 'support_state.dart';

@injectable
class SupportBloc extends Bloc<SupportEvent, SupportState> {
  SupportBloc(this._emailRepository) : super(const SupportInitial()) {
    on<SendSupportEmail>(_onSendSupportEmail);
  }

  final EmailRepository _emailRepository;

  Future<void> _onSendSupportEmail(
    SendSupportEmail event,
    Emitter<SupportState> emit,
  ) async {
    emit(const SupportLoading());
    try {
      final bool isSent = await _emailRepository.sendSupportEmail(
        name: event.name,
        userEmail: event.email,
        message: event.message,
      );
      if (isSent) {
        emit(const SupportSuccess());
      } else {
        emit(const SupportInitial());
      }
    } catch (error, stackTrace) {
      debugPrint('Error sending email: $error.\n Stack trace: $stackTrace');
      emit(SupportFailure(translate('support_page.failed_to_send_email')));
    }
  }
}
