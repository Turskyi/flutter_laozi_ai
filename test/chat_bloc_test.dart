import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laozi_ai/application_services/blocs/chat_bloc.dart';
import 'package:laozi_ai/domain_services/chat_repository.dart';
import 'package:laozi_ai/domain_services/settings_repository.dart';
import 'package:laozi_ai/entities/enums/language.dart';
import 'package:mocktail/mocktail.dart';

// Create mock classes for the repositories.
class MockChatRepository extends Mock implements ChatRepository {}

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  // Define the mock instances.
  late MockChatRepository mockChatRepository;
  late MockSettingsRepository mockSettingsRepository;

  // Initialize the mock instances before each test.
  setUp(() {
    mockChatRepository = MockChatRepository();
    mockSettingsRepository = MockSettingsRepository();
  });

  // Define the test for LoadHomeEvent.
  blocTest<ChatBloc, ChatState>(
    'emits [ChatInitial] when LoadHomeEvent is added',
    build: () {
      // Set up the mock method calls
      when(() => mockSettingsRepository.getLanguage()).thenReturn(Language.en);
      // Return the ChatBloc with the mocked dependencies
      return ChatBloc(mockChatRepository, mockSettingsRepository);
    },
    act: (ChatBloc bloc) => bloc.add(const LoadHomeEvent()),
    expect: () => <TypeMatcher<ChatInitial>>[
      isA<ChatInitial>().having(
        (ChatInitial state) => state.language,
        'language',
        Language.en,
      ),
    ],
  );
}
