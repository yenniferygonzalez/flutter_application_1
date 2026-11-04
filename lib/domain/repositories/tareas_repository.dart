import 'package:flutter_application_1/domain/models/tarea.dart';

abstract class TareasRepository {
  Future<List<Tarea>> obtenerTareas();
  Future<void> guardarTareas(List<Tarea> tareas);
}