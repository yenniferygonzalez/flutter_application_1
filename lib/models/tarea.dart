class Tarea {
  String titulo;
  String descripcion;
  bool completada;

  Tarea(this.titulo, this.descripcion, {this.completada = false});

  factory Tarea.fromJson(Map<String, dynamic> json) => Tarea(
        json['title'],
        'Usuario ${json['userId']}',
        completada: json['completed'],
      );

  Map<String, dynamic> toJson() => {
        'titulo': titulo,
        'descripcion': descripcion,
        'completada': completada,
      };
  factory Tarea.fromStorage(Map<String, dynamic> json) => Tarea(
    json['titulo'],
    json['descripcion'],
    completada: json['completada'],
  );
}