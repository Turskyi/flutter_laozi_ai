part of 'support_bloc.dart';

@immutable
sealed class SupportState {
  const SupportState({required this.language});

  final Language language;
}

class SupportInitial extends SupportState {
  const SupportInitial({required super.language});

  SupportInitial copyWith({Language? language}) {
    return SupportInitial(language: language ?? this.language);
  }
}

class SupportLoading extends SupportState {
  const SupportLoading({required super.language});

  SupportLoading copyWith({Language? language}) {
    return SupportLoading(language: language ?? this.language);
  }
}

class SupportSuccess extends SupportState {
  const SupportSuccess({required super.language});

  SupportSuccess copyWith({Language? language}) {
    return SupportSuccess(language: language ?? this.language);
  }
}

class SupportFailure extends SupportState {
  const SupportFailure({required super.language, required this.error});

  final String error;

  SupportFailure copyWith({Language? language, String? error}) {
    return SupportFailure(
      language: language ?? this.language,
      error: error ?? this.error,
    );
  }
}
