class Canciones {
  String? id;
  String? nombre;
  int? votos;

  Canciones({this.id, this.nombre, this.votos});

  factory Canciones.fromMap(Map<String, dynamic> obj) => Canciones(
      id: obj.containsKey('id') ? obj['id'] : 'no-id',
      nombre: obj.containsKey('name') ? obj['name'] : 'no-nombre',
      votos: obj.containsKey('votes') ? obj['votes'] : 0);
}
