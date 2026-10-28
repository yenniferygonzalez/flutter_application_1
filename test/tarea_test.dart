import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/models/tarea.dart';

void main() {
  test('Una tarea nueva empieza como pendiente', () {
    final tarea = Tarea('Estudiar', 'Repasar Dart');
    expect(tarea.titulo, 'Estudiar');
    expect(tarea.completada, false);
  });

  test('Tarea.fromJson convierte el JSON de la API', () {
    final tarea = Tarea.fromJson({
      'title': 'Leer',
      'userId': 1,
      'completed': true,
    });
    expect(tarea.titulo, 'Leer');
    expect(tarea.completada, true);
  });
}