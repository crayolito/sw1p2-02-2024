import 'package:sw1p2_mobil/features/auth/domain/entities/cnotificacion.entitie.dart';
import 'package:sw1p2_mobil/features/auth/domain/entities/estudiante.entitie.dart';

class Apoderado {
  final int id;
  final String nombreCompleto;
  final String ci;
  final String direccion;
  final String numeroMatricula;
  final String telefono;
  final String email;
  final String ocupacion;
  final String tokenNotifi;
  final Estudiante alumno;
  final List<CNotificacion> comunicados;

  Apoderado(
      {required this.id,
      required this.nombreCompleto,
      required this.ci,
      required this.direccion,
      required this.numeroMatricula,
      required this.telefono,
      required this.email,
      required this.ocupacion,
      required this.tokenNotifi,
      required this.alumno,
      required this.comunicados});
}
