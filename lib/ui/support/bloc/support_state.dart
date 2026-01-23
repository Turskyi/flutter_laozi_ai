part of 'support_bloc.dart';

@immutable
sealed class SupportState {
  const SupportState();
}

class SupportInitial extends SupportState {
  const SupportInitial();
}

class SupportLoading extends SupportState {
  const SupportLoading();
}

class SupportSuccess extends SupportState {
  const SupportSuccess();
}

class SupportFailure extends SupportState {
  const SupportFailure(this.error);

  final String error;

  SupportFailure copyWith({Language? language, String? error}) {
    return SupportFailure(error ?? this.error);
  }
}
