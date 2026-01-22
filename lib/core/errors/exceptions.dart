class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  
  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  NetworkException() : super('Cannot connect to the internet. Please check your connection.');
}

class ServerException extends ApiException {
  ServerException() : super('Server error occurred. Please try again later.');
}
