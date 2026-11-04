import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String mensaje;
  const ApiException(this.mensaje);

  @override
  String toString() => mensaje;
}

class ApiService {
  static const _timeout = Duration(seconds: 10);
  static const _headers = {'Content-Type': 'application/json; charset=UTF-8'};

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<dynamic> get(String url) =>
      _ejecutar(() => _client.get(Uri.parse(url)));

  Future<dynamic> post(String url, {Object? body}) => _ejecutar(() =>
      _client.post(Uri.parse(url), headers: _headers, body: _codificar(body)));

  Future<dynamic> put(String url, {Object? body}) => _ejecutar(() =>
      _client.put(Uri.parse(url), headers: _headers, body: _codificar(body)));

  String? _codificar(Object? body) => body == null ? null : jsonEncode(body);

  Future<dynamic> _ejecutar(Future<http.Response> Function() peticion) async {
    try {
      final respuesta = await peticion().timeout(_timeout);
      if (respuesta.statusCode < 200 || respuesta.statusCode >= 300) {
        throw ApiException(
            'El servidor respondió con error ${respuesta.statusCode}.');
      }
      if (respuesta.body.isEmpty) return null;
      return jsonDecode(respuesta.body);
    } on TimeoutException {
      throw const ApiException(
          'La conexión tardó demasiado. Inténtalo de nuevo.');
    } on SocketException {
      throw const ApiException('Sin conexión a internet.');
    } on http.ClientException {
      throw const ApiException('No se pudo conectar con el servidor.');
    } on FormatException {
      throw const ApiException('La respuesta del servidor no es válida.');
    }
  }
}