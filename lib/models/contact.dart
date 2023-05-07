class Contact {

  static String tableName = "contactos";
  static String createQuery = "CREATE TABLE contactos (id integer primary key AUTOINCREMENT, nombres TEXT, apellidos TEXT, telefono integer)";

  final int id;
  final String nombres;
  final String apellidos;
  final String telefono;

  //Contact(this.id, this.nombres, this.apellidos, this.telefono);

  const Contact({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.telefono
  });

  Map<String, dynamic> toMap() {
    return {
      'nombres': nombres,
      'apellidos': apellidos,
      'telefono': telefono
    };
  }
}