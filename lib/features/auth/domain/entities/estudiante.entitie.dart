import 'package:sw1p2_mobil/features/auth/domain/entities/cnotificacion.entitie.dart';
import 'package:sw1p2_mobil/features/auth/domain/entities/profesor.entitie.dart';

class Estudiante {
  final int id;
  final String nombreCompleto;
  final String ci;
  final String direccion;
  final String numeroMatricula;
  final String telefono;
  final String numeroKardex;
  final String tokenNotifi;
  final Grado grado;
  final List<CNotificacion> recividos;

  Estudiante({
    required this.id,
    required this.nombreCompleto,
    required this.ci,
    required this.direccion,
    required this.numeroMatricula,
    required this.telefono,
    required this.numeroKardex,
    required this.tokenNotifi,
    required this.grado,
    required this.recividos,
  });

  // Constructor factory para crear una instancia vacía
  factory Estudiante.empty() {
    return Estudiante(
      id: 0,
      nombreCompleto: '',
      ci: '',
      direccion: '',
      numeroMatricula: '',
      telefono: '',
      numeroKardex: '',
      tokenNotifi: '',
      grado: Grado.empty(),
      recividos: [],
    );
  }
}
