import 'package:flutter_application_1/domain/models/tarea.dart';
import 'package:flutter_application_1/services/almacenamiento_service.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'package:flutter_application_1/domain/repositories/tareas_repository.dart';


class TareasRepositoryImpl implements TareasRepository {
  static const _urlTodos =
      'https://jsonplaceholder.typicode.com/todos?_limit=20';

  final ApiService _api;
  final AlmacenamientoService _almacen;

  TareasRepositoryImpl({ApiService? api, AlmacenamientoService? almacen})
      : _api = api ?? ApiService(),
        _almacen = almacen ?? AlmacenamientoService();

  @override
  Future<List<Tarea>> obtenerTareas() async {
    final guardadas = await _almacen.leer();
    if (guardadas != null && guardadas.isNotEmpty) return guardadas;

    final datos = await _api.get(_urlTodos);
    if (datos is! List) {
      throw const ApiException('La respuesta del servidor no es válida.');
    }
    final tareas = datos.map((e) => Tarea.fromJson(e)).toList();
    await _almacen.guardar(tareas);
    return tareas;
  }

  @override
  Future<void> guardarTareas(List<Tarea> tareas) => _almacen.guardar(tareas);
}