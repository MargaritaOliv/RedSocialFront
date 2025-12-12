class ServerException implements Exception {
  final String message;
  ServerException([this.message = "Error en el servidor"]);

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = "Error de red"]);

  @override
  String toString() => message;
}