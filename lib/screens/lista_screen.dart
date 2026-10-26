import 'package:flutter/material.dart';
import '../models/tarea.dart';
import '../services/almacenamiento_service.dart';
import '../services/tarea_service.dart';
import '../widgets/tarea_card.dart';
import 'detalle_screen.dart';
import 'nueva_tarea_screen.dart';
//prueba pull
class ListaScreen extends StatefulWidget {
  const ListaScreen({super.key});

  @override
  State<ListaScreen> createState() => _ListaScreenState();
}

class _ListaScreenState extends State<ListaScreen> {
  final List<Tarea> tareas = [];
  late Future<void> _carga;
  final _almacen = AlmacenamientoService();

  void _guardar() => _almacen.guardar(tareas);

  @override
  void initState() {
    super.initState();
    _carga = _cargar();
  }

  Future<void> _cargar() async {
    final guardadas = await _almacen.leer();
    if (guardadas != null) {
      tareas
        ..clear()
        ..addAll(guardadas);
      return;
    }
    final datos = await TareaService().obtenerTareas();
    tareas
      ..clear()
      ..addAll(datos);
    await _almacen.guardar(tareas);
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
                  const Text('No se pudieron cargar las tareas'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _reintentar,
                    child: const Text('Reintentar'),
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