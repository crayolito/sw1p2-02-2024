import 'package:sw1p2_mobil/features/auth/domain/entities/estudiante.entitie.dart';
import 'package:sw1p2_mobil/features/auth/domain/entities/profesor.entitie.dart';
import 'package:sw1p2_mobil/features/auth/infrastructure/mappers/cnotificacion.mapper.dart';
import 'package:sw1p2_mobil/features/auth/infrastructure/mappers/profesor.mapper.dart';

class EstudianteMapper {
  static Estudiante fromJson(Map<String, dynamic> json) {
    return Estudiante(
      id: json['id'] ?? 0, // o el valor por defecto que corresponda
      nombreCompleto: json['nombre_completo']?.toString() ?? '',
      ci: json['ci']?.toString() ?? '',
      direccion: json['direccion']?.toString() ?? '',
      numeroMatricula: json['numero_matricula']?.toString() ?? '',
      telefono: json['telefono']?.toString() ?? '',
      numeroKardex: json['numero_kardex']?.toString() ?? '',
      tokenNotifi: json['token_notifi']?.toString() ?? '',
      grado: json['grado'] != null
          ? GradoMapper.fromJson(json['grado'])
          : Grado.empty(),
      recividos: (json['comunicados'] as List?)
              ?.map((e) => CNotificacionMapper.fromJson(e))
              .toList() ??
          [],
    );
  }
}
