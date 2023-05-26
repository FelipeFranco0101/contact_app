class Auth {
  static String colId = 'id';
  static String colUsuario = 'usuario';
  static String colClave = 'clave';

  static String tableName = 'auth';
  static String createQuery = 'CREATE TABLE $tableName ($colId integer primary key AUTOINCREMENT, $colUsuario TEXT, $colClave TEXT)';

  final int id;
  final String usuario;
  final String clave;

  Auth({required this.id, required this.usuario, required this.clave});

  Map<String, dynamic> toMap() {
    return {'usuario': usuario, 'clave': clave};
  }

  factory Auth.fromMap(Map<String, dynamic> map) {
    return Auth(id: map['id'], usuario: map['usuario'], clave: map['clave']);
  }
}
