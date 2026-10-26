import 'package:flutter/material.dart';
import '../models/tarea.dart';

class DetalleScreen extends StatelessWidget {
  final Tarea tarea;

  const DetalleScreen({super.key, required this.tarea});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tarea.titulo,
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            Text(tarea.descripcion.isEmpty
                ? 'Sin descripción'
                : tarea.descripcion),
            const SizedBox(height: 12),
            Text(tarea.completada ? 'Estado: completada' : 'Estado: pendiente'),
          ],
        ),
      ),
    );
  }
}