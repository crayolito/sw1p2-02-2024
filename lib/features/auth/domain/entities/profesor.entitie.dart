import 'package:sw1p2_mobil/features/auth/domain/entities/cnotificacion.entitie.dart';

class PushMessage {
  final String messageId;
  final String title;
  final String body;
  final DateTime sentDate;
  final Map<String, dynamic>? data;
  final String? imageURL;

  PushMessage(
      {required this.messageId,
      required this.title,
      required this.body,
      required this.sentDate,
      this.data,
      this.imageURL});

  @override
  String toString() {
    return '''
    PushMessage:
    messageId: $messageId, 
    title: $title,
    body: $body,
    sentDate: $sentDate,
    data: $data,
    imageURL: $imageURL
    ''';
  }
}

class Profesor {
  final int id;
  final String nombreCompleto;
  final String ci;
  final String direccion;
  final String numeroMatricula;
  final String telefono;
  final String email;
  final String tokenNotifi;
  final List<Horario> horarios;
  final List<CNotificacion> creadas;
  final List<CNotificacion> recibidas;

  Profesor(
      {required this.id,
      required this.nombreCompleto,
      required this.ci,
      required this.direccion,
      required this.numeroMatricula,
      required this.telefono,
      required this.email,
      required this.tokenNotifi,
      required this.horarios,
      required this.creadas,
      required this.recibidas});
}

class Horario {
  final int id;
  final String dia;
  final String horaInicio;
  final String horaFin;
  final Materia materia;
  final Grado grado;

  Horario(
      {required this.id,
      required this.dia,
      required this.horaInicio,
      required this.horaFin,
      required this.materia,
      required this.grado});
}

class Materia {
  final int id;
  final String nombre;
  final String sigla;

  Materia({required this.id, required this.nombre, required this.sigla});
}

class Grado {
  final int id;
  final String nombre;
  final String sigla;

  Grado({required this.id, required this.nombre, required this.sigla});

  // Constructor vacío
  factory Grado.empty() {
    return Grado(
      id: 0,
      nombre: '',
      sigla: '',
    );
  }

  // Factory constructor desde JSON
  factory Grado.fromJson(Map<String, dynamic> json) {
    return Grado(
      id: json['id'] ?? 0,
      nombre: json['nombre']?.toString() ?? '',
      sigla: json['sigla']?.toString() ?? '',
    );
  }

  // Método para convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'sigla': sigla,
    };
  }

  // Override toString para depuración
  @override
  String toString() {
    return 'Grado(id: $id, nombre: $nombre, sigla: $sigla)';
  }
}
