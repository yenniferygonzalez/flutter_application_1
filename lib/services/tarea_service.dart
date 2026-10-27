import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tarea.dart';

class TareaService {
  static const _url = 'https://jsonplaceholder.typicode.com/todos?_limit=20'; // conectar api

  Future<List<Tarea>> obtenerTareas() async {
    final respuesta = await http.get(Uri.parse(_url));
    if (respuesta.statusCode != 200) {
      throw Exception('Error ${respuesta.statusCode}');
    }
    final List datos = jsonDecode(respuesta.body);
    return datos.map((e) => Tarea.fromJson(e)).toList();
  }
}