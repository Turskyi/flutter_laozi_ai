class WebServiceException implements Exception {
  const WebServiceException(this.message);

  final String message;

  @override
  String toString() => message;
}
