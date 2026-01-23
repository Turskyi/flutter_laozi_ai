abstract class EmailRepository {
  Future<bool> sendSupportEmail({
    required String name,
    required String userEmail,
    required String message,
  });
}
