import 'package:sw1p2_mobil/features/auth/domain/entities/cnotificacion.entitie.dart';
import 'package:sw1p2_mobil/features/auth/domain/entities/profesor.entitie.dart';
import 'package:sw1p2_mobil/features/auth/infrastructure/mappers/cnotificacion.mapper.dart';

class ProfesorMapper {
  static Profesor fromJson(Map<String, dynamic> json) {
    return Profesor(
      id: json['id'],
      nombreCompleto: json['nombre_completo'],
      ci: json['ci'],
      direccion: json['direccion'],
      numeroMatricula: json['numero_matricula'],
      telefono: json['telefono'],
      email: json['email'],
      tokenNotifi: json['token_notifi'],
      horarios: parseoHorarios(json['horarios'] ?? []),
      creadas: parseoNotificaciones(json['comunicados']['creados'] ?? []),
      recibidas: parseoNotificaciones(json['comunicados']['recibidos'] ?? []),
    );
  }

  static List<Horario> parseoHorarios(List<dynamic> horarios) {
    return horarios.map((horario) => HorarioMapper.fromJson(horario)).toList();
  }

  static List<CNotificacion> parseoNotificaciones(
      List<dynamic> notificaciones) {
    return notificaciones
        .map((notificacion) => CNotificacionMapper.fromJson(notificacion))
        .toList();
  }
}

class HorarioMapper {
  static Horario fromJson(Map<String, dynamic> json) {
    return Horario(
      id: json['id'],
      dia: json['dia'],
      horaInicio: json['hora_inicio'],
      horaFin: json['hora_fin'],
      grado: GradoMapper.fromJson(json['grado']),
      materia: MateriaMapper.fromJson(json['materia']),
    );
  }
}

class MateriaMapper {
  static Materia fromJson(Map<String, dynamic> json) {
    return Materia(
      id: json['id'],
      nombre: json['nombre'],
      sigla: json['sigla'],
    );
  }
}

class GradoMapper {
  static Grado fromJson(Map<String, dynamic> json) {
    return Grado(
      id: json['id'],
      nombre: json['nombre'],
      sigla: json['sigla'],
    );
  }
}
