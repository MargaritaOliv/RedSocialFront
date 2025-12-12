import 'package:http/http.dart' as http;

const String BASE_API_URL = 'http://107.22.243.140/api';

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  late final http.Client client;

  final String baseUrl = BASE_API_URL;

  factory HttpClient() {
    return _instance;
  }

  HttpClient._internal() {
    client = http.Client();
  }

  Future<http.Response> getRequest(String endpoint, {Map<String, String>? headers}) {
    final url = Uri.parse('$baseUrl$endpoint');
    return client.get(
      url,
      headers: headers,
    );
  }

  void dispose() {
    client.close();
  }
}