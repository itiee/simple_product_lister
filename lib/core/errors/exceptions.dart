class ApiException implements Exception {
  final String message;
  ApiException(this.message);
}

class NetworkException extends ApiException {
  NetworkException() : super('cannot connect to the internet. Please check your connection.');
}

class ServerException extends ApiException {
  ServerException() : super('Server error occurred. Please try again later.');
}
