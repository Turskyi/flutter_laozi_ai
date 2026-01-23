import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/application_services/repositories/email_repository_impl.dart';
import 'package:laozi_ai/domain_services/settings_repository.dart';
import 'package:laozi_ai/entities/enums/language.dart';

part 'support_event.dart';
part 'support_state.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  SupportBloc(this._emailRepository, SettingsRepository _settingsRepository)
    : super(SupportInitial(language: _settingsRepository.getLanguage())) {
    on<SendSupportEmail>(_onSendSupportEmail);
  }

  final EmailRepositoryImpl _emailRepository;

  Future<void> _onSendSupportEmail(
    SendSupportEmail event,
    Emitter<SupportState> emit,
  ) async {
    emit(SupportLoading(language: state.language));
    try {
      final bool isSent = await _emailRepository.sendSupportEmail(
        name: event.name,
        userEmail: event.email,
        message: event.message,
      );
      if (isSent) {
        emit(SupportSuccess(language: state.language));
      } else {
        emit(SupportInitial(language: state.language));
      }
    } catch (e) {
      emit(
        SupportFailure(
          language: state.language,
          error: translate('support_page.failed_to_send_email'),
        ),
      );
    }
  }
}
