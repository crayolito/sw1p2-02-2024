import 'package:sw1p2_mobil/features/auth/domain/entities/apoderado.entitie.dart';
import 'package:sw1p2_mobil/features/auth/domain/entities/estudiante.entitie.dart';
import 'package:sw1p2_mobil/features/auth/infrastructure/mappers/cnotificacion.mapper.dart';
import 'package:sw1p2_mobil/features/auth/infrastructure/mappers/estudiante.mapper.dart';

class ApoderadoMapper {
  static Apoderado fromJson(Map<String, dynamic> json) {
    return Apoderado(
      id: json['id'] ?? 0,
      nombreCompleto: json['nombre_completo']?.toString() ?? '',
      ci: json['ci']?.toString() ?? '',
      direccion: json['direccion']?.toString() ?? '',
      numeroMatricula: json['numero_matricula']?.toString() ?? '',
      telefono: json['telefono']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      ocupacion: json['ocupacion']?.toString() ?? '',
      tokenNotifi: json['token_notifi']?.toString() ?? '',
      alumno: json['alumnos'] != null && (json['alumnos'] as List).isNotEmpty
          ? EstudianteMapper.fromJson(
              json['alumnos'][0]) // Tomamos el primer alumno
          : Estudiante.empty(),
      comunicados: (json['comunicados'] as List?)
              ?.map((e) => CNotificacionMapper.fromJson(e))
              .toList() ??
          [],
    );
  }
}
