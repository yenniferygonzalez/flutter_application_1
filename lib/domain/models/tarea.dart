class Tarea {
  int? id;
  String titulo;
  String descripcion;
  bool completada;

  Tarea(this.titulo, this.descripcion, {this.id, this.completada = false});

  factory Tarea.fromJson(Map<String, dynamic> json) => Tarea(
        json['title'],
        'Usuario ${json['userId']}',
        id: json['id'],
        completada: json['completed'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'titulo': titulo,
        'descripcion': descripcion,
        'completada': completada,
      };
  factory Tarea.fromStorage(Map<String, dynamic> json) => Tarea(
    json['titulo'],
    json['descripcion'],
    id: json['id'],
    completada: json ['completada'],
  );
}