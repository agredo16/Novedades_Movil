class UserModel {
  final String token;
  final int idUsuario;
  final String nombreCompleto;
  final String rol;
  final bool primerLogin;
  final String codigoEstudiantil;
  final String expiraEn;

  const UserModel({
    required this.token,
    required this.idUsuario,
    required this.nombreCompleto,
    required this.rol,
    required this.primerLogin,
    required this.codigoEstudiantil,
    required this.expiraEn,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token:              json['token'],
      idUsuario:          json['id_usuario'],
      nombreCompleto:     json['nombre_completo'],
      rol:                json['rol'],
      primerLogin:        json['primer_login'],
      codigoEstudiantil:  json['codigo_estudiantil'],
      expiraEn:           json['expira_en'],
    );
  }
}