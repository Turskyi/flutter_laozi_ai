part of 'support_bloc.dart';

@immutable
abstract class SupportState {
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
}
