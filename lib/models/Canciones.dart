class Canciones {
  String? id;
  String? nombre;
  int? votos;

  Canciones({this.id, this.nombre, this.votos});

  factory Canciones.fromMap(Map<String, dynamic> obj) =>
      Canciones(id: obj['id'], nombre: obj['nombre'], votos: obj['votos']);
}
