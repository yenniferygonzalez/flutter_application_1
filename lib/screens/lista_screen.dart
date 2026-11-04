import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/repositories_implementation/tareas_repository_impl.dart';
import '../domain/models/tarea.dart';
import '../domain/repositories/tareas_repository.dart';
import '../widgets/tarea_card.dart';
import 'detalle_screen.dart';
import 'nueva_tarea_screen.dart';

class ListaScreen extends StatefulWidget {
  const ListaScreen({super.key});

  @override
  State<ListaScreen> createState() => _ListaScreenState();
}

class _ListaScreenState extends State<ListaScreen> {
  final List<Tarea> tareas = [];
  late Future<void> _carga;
  final TareasRepository _repositorio = TareasRepositoryImpl();

  void _guardar() => _repositorio.guardarTareas(tareas);

  @override
  void initState() {
    super.initState();
    _carga = _cargar();
  }

  Future<void> _cargar() async {
    final datos = await _repositorio.obtenerTareas();
    tareas
      ..clear()
      ..addAll(datos);
    return;
  }

  void _reintentar() {
    setState(() {
      _carga = _cargar();
    });
  }

  Future<void> _nueva() async {
    final tarea = await Navigator.push<Tarea>(
      context,
      MaterialPageRoute(builder: (_) => const NuevaTareaScreen()),
    );
    if (!mounted) return;
    if (tarea != null) {
      setState(() => tareas.add(tarea));
      _guardar();
    }
  }

  void _verDetalle(Tarea t) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetalleScreen(tarea: t)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis tareas'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _nueva,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<void>(
        future: _carga,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [                  
                  Text(
                    'No se pudieron cargar las tareas.\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _reintentar,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          if (tareas.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.task_alt, size: 64, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text('No tienes tareas. Toca + para agregar una.'),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: _reintentar,
                    child: const Text('Cargar tareas desde la API'),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: tareas.length,
            itemBuilder: (context, i) {
              final t = tareas[i];
              return Dismissible(
                key: ObjectKey(t),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  setState(() => tareas.removeAt(i));
                  _guardar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tarea eliminada: ${t.titulo}')),
                  );
                },
                child: TareaCard(
                  tarea: t,
                  onChanged: (v) {
                    setState(() => t.completada = v!);
                    _guardar();
                  },
                  onTap: () => _verDetalle(t),
                ),
              );
            },
          );
        },
      ),
    );
  }
}