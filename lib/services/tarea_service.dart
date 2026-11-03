import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/tarea.dart';

class TareaServiceException implements Exception {
  final String mensaje;
  const TareaServiceException(this.mensaje);

  @override
  String toString() => mensaje;
}

class TareaService {
  static const _url = 'https://jsonplaceholder.typicode.com/todos?_limit=20';

  Future<List<Tarea>> obtenerTareas() async {
    try {
      final respuesta =
          await http.get(Uri.parse(_url)).timeout(const Duration(seconds: 10));
      if (respuesta.statusCode != 200) {
        throw TareaServiceException(
            'El servidor respondió con error ${respuesta.statusCode}.');
      }
      final List datos = jsonDecode(respuesta.body);
      return datos.map((e) => Tarea.fromJson(e)).toList();
    } on TimeoutException {
      throw const TareaServiceException(
          'La conexión tardó demasiado. Inténtalo de nuevo.');
    } on SocketException {
      throw const TareaServiceException('Sin conexión a internet.');
    } on http.ClientException {
      throw const TareaServiceException('No se pudo conectar con el servidor.');
    } on FormatException {
      throw const TareaServiceException(
          'La respuesta del servidor no es válida.');
    }
  }
}