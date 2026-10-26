import 'package:flutter/material.dart';
import '../models/tarea.dart';

class TareaCard extends StatelessWidget {
  final Tarea tarea;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onTap;

  const TareaCard({
    super.key,
    required this.tarea,
    required this.onChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Checkbox(value: tarea.completada, onChanged: onChanged),
        title: Text(
          tarea.titulo,
          style: TextStyle(
            decoration: tarea.completada ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(tarea.descripcion),
      ),
    );
  }
}