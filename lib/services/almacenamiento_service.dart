import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tarea.dart';

class AlmacenamientoService {
  static const _clave = 'tareas';

  Future<void> guardar(List<Tarea> tareas) async {
    final prefs = await SharedPreferences.getInstance();
    final texto = jsonEncode(tareas.map((t) => t.toJson()).toList());
    await prefs.setString(_clave, texto);
  }

  Future<List<Tarea>?> leer() async {
    final prefs = await SharedPreferences.getInstance();
    final texto = prefs.getString(_clave);
    if (texto == null) return null;
    final List datos = jsonDecode(texto);
    return datos.map((e) => Tarea.fromStorage(e)).toList();
  }
}