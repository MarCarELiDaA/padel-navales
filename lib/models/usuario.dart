class Usuario {
  final String nombre;
  final String email;
  final String? telefono;
  final double? nivelPadel;
  final DateTime? fechaRegistro;
  final String role;
  final String status;

  Usuario({
    required this.nombre,
    required this.email,
    this.telefono,
    this.nivelPadel,
    this.fechaRegistro,
    this.role = 'user',
    this.status = 'pending',
  });

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      nombre: map['nombre'] ?? '',
      email: map['email'] ?? '',
      telefono: map['telefono'],
      nivelPadel: map['nivelPadel']?.toDouble(),
      fechaRegistro: map['fechaRegistro']?.toDate(),
      role: map['role'] ?? 'user',
      status: map['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'email': email,
      'telefono': telefono,
      'nivelPadel': nivelPadel,
      'fechaRegistro': fechaRegistro,
      'role': role,
      'status': status,
    };
  }
}