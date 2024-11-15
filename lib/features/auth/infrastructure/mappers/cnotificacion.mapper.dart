import 'package:sw1p2_mobil/features/auth/domain/entities/cnotificacion.entitie.dart';

class CNotificacionMapper {
  static CNotificacion fromJson(Map<String, dynamic> json) {
    try {
      return CNotificacion(
        id: json['id'],
        titulo: getTituloFormateado(json['titulo'] ?? 'default'),
        donde: json['donde']?.toString() ?? 'Sin ubicación',
        cuando: json['cuando']?.toString() ?? 'Sin fecha',
        motivo: json['motivo']?.toString() ?? 'Sin motivo',
        imagen: json['imagen_url'] ??
            'https://i.pinimg.com/736x/d7/22/ee/d722ee6ba2b397b53eb5bdb53f3471d9.jpg',
        extra: '',
        profesorCreador: verificarProfesorCreador(json),
        receptores: _parseReceptores(json),
      );
    } catch (e) {
      print('Error parsing CNotificacion: $e');
      // Retornar objeto con valores por defecto en caso de error
      return CNotificacion.empty();
    }
  }

  static bool verificarProfesorCreador(Map<String, dynamic> json) {
    // Primero verificamos si existe la clave en el mapa
    if (!json.containsKey('profesor_creador')) {
      // Si no existe la clave, retornamos true
      return true;
    }

    // Si existe la clave, verificamos si el valor es null
    if (json['profesor_creador'] == null) {
      // Si el valor es null, retornamos true
      return false;
    }

    // Si existe la clave y el valor no es null, retornamos false
    return false;
  }

  // Método auxiliar para parsear receptores
  static List<Receptores> _parseReceptores(Map<String, dynamic> json) {
    try {
      if (json['alumnos'] is Map && json['alumnos']['todos'] is List) {
        return ReceptoresMapper.fromJson(json['alumnos']['todos'] as List);
      }
      return ReceptoresMapper.fromJson([]); // Lista vacía por defecto
    } catch (e) {
      print('Error parsing receptores: $e');
      return [];
    }
  }

  static String getTituloFormateado(String tipo) {
    switch (tipo) {
      // Administrativo
      case 'informativos':
        return 'Informativos oficiales';
      case 'emergencias':
        return 'Emergencias';
      case 'eventos':
        return 'Eventos escolares';
      case 'reuniones':
        return 'Reuniones generales';
      case 'circulares':
        return 'Circulares generales';
      // Profesor
      case 'rendimiento':
        return 'Rendimiento académico';
      case 'comportamiento':
        return 'Comportamiento del alumno';
      case 'citaciones':
        return 'Citación a apoderados';
      case 'tareas':
        return 'Tareas y evaluaciones';
      case 'felicitaciones':
        return 'Felicitaciones';
      default:
        return 'Comunicado';
    }
  }
}

class ReceptoresMapper {
  static List<Receptores> fromJson(List<dynamic> json) {
    List<Receptores> receptores = [];

    try {
      for (var item in json) {
        if (item == null) continue;

        receptores.add(Receptores(
            id: item['id'] ?? 0,
            nombreCompleto: item['nombre_completo'] ?? 'Sin nombre',
            ci: item['ci'] ?? 'Sin CI',
            numeroMatricula: item['numero_matricula'] ?? 'Sin matrícula',
            visto: item['visto'] ?? false,
            fechaVisto: item['fecha_visto'] ?? 'Todavía no vio el comunicado'));
      }
    } catch (e) {
      print('Error al procesar receptor: $e');
    }

    return receptores;
  }
}
