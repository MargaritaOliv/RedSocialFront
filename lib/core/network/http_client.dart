import 'package:http/http.dart' as http;

// 🚨 La URL base fija, sin usar dotenv, apuntando a la IP de AWS
// Incluimos '/api' aquí para mantener las rutas de los controladores limpias.
const String BASE_API_URL = 'http://107.22.243.140/api';

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  late final http.Client client;

  // Hacemos que la URL base sea accesible a través de la instancia del cliente
  final String baseUrl = BASE_API_URL;

  factory HttpClient() {
    return _instance;
  }

  HttpClient._internal() {
    client = http.Client();
  }

  // Puedes eliminar el método getRequest si solo se usa en el Data Source,
  // pero lo dejo para que AuthRemoteDataSourceImpl pueda usar la variable `baseUrl`.
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