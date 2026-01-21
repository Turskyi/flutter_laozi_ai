import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laozi_ai/application_services/blocs/chat_bloc.dart';
import 'package:laozi_ai/domain_services/chat_repository.dart';
import 'package:mocktail/mocktail.dart';

// Create mock classes for the repositories.
class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  // Define the mock instances.
  late MockChatRepository mockChatRepository;

  // Initialize the mock instances before each test.
  setUp(() {
    mockChatRepository = MockChatRepository();
  });

  // Define the test for LoadHomeEvent.
  blocTest<ChatBloc, ChatState>(
    'emits [ChatInitial] when LoadHomeEvent is added',
    build: () {
      // Return the ChatBloc with the mocked dependencies
      return ChatBloc(mockChatRepository);
    },
    act: (ChatBloc bloc) => bloc.add(const LoadHomeEvent()),
    expect: () => <TypeMatcher<ChatInitial>>[
      isA<ChatInitial>().having(
        (ChatInitial state) => state.messages,
        'messages',
        isEmpty,
      ),
    ],
  );
}
