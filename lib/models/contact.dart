class Contact {

  static String colId = 'id';
  static String colNombres = 'nombres';
  static String colApellidos = 'apellidos';
  static String colTelefono = 'telefono';
  static String colEdad = 'edad';
  static String colEmail = 'email';

  static String tableName = "contactos";
  static String createQuery = 'CREATE TABLE $tableName ($colId integer primary key AUTOINCREMENT, $colNombres TEXT, $colApellidos TEXT, $colTelefono TEXT, $colEdad TEXT, $colEmail TEXT)';

  final int id;
  final String nombres;
  final String apellidos;
  final String telefono;
  final String? edad;
  final String? email;


  const Contact({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.telefono,
    this.edad,
    this.email
  });

  Map<String, dynamic> toMap() {
    return {
      'nombres': nombres,
      'apellidos': apellidos,
      'telefono': telefono,
      'edad': edad,
      'email': email,
    };
  }


  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(id: map['id'], nombres: map['nombres'], apellidos: map['apellidos'], telefono: map['telefono'], edad: map['edad'], email: map['email'].toString());
  }
}