import 'package:dio/dio.dart';
import 'package:sw1p2_mobil/features/auth/domain/datasources/auth.datasource.dart';
import 'package:sw1p2_mobil/features/auth/domain/entities/cnotificacion.entitie.dart';
import 'package:sw1p2_mobil/features/auth/infrastructure/mappers/cnotificacion.mapper.dart';

class AuthDataSourceImpl extends AuthDatasource {
  final dio = Dio(BaseOptions(
    baseUrl: 'http://137.184.205.53:8069/',
  ));

  @override
  Future<Map<String, dynamic>> authenticate(
      {required String ci,
      required String matricula,
      required String token}) async {
    try {
      final response = await dio.post('api/profesor',
          data: {
            'ci': ci,
            'numero_matricula': matricula,
            'token_notifi': token,
          },
          options: Options(
            responseType: ResponseType.json,
          ));

      if (response.statusCode == 200) {
        return response.data;
      }

      // Manejar otros códigos de estado
      throw Exception('Error de autenticación: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error en la autenticación: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> postProfesorCRE(
      {required int idProfesor}) async {
    try {
      final response = await dio.post('api/profesor/comunicados',
          data: {
            'profesor_id': idProfesor,
          },
          options: Options(
            responseType: ResponseType.json,
          ));

      if (response.statusCode == 200) {
        return response.data;
      }

      // Manejar otros códigos de estado
      throw Exception(
          'Error al obtener los comunicados del profesor: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error al obtener los comunicados del profesor: $e');
    }
  }

  @override
  Future<String> createComunicado({
    required int profesorId,
    required int horarioId,
    required String titulo,
    required String donde,
    required String cuando,
    required String motivo,
  }) async {
    try {
      // Convertir el formato de fecha
      final fechaFormateada = cuando.replaceAll(' ', 'T');

      final response = await dio.post(
        'api/profesor/comunicado',
        data: {
          'profesor_id': profesorId,
          'horario_id': horarioId,
          'titulo': titulo,
          'donde': donde,
          'cuando': fechaFormateada, // Formato ISO: "2024-11-15T16:15:00.000"
          'motivo': motivo,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
          responseType: ResponseType.json,
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        return response.data['message'];
      }

      throw Exception(
          'Error: ${response.statusCode} - ${response.data['error'] ?? 'Error desconocido'}');
    } catch (e) {
      throw Exception('Error al crear comunicado: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> authenticateEstudiante(
      {required String ci,
      required String matricula,
      required String token}) async {
    try {
      final response = await dio.post('api/alumno',
          data: {
            'ci': ci,
            'numero_matricula': matricula,
            'token_notifi': token,
          },
          options: Options(
            responseType: ResponseType.json,
          ));

      if (response.statusCode == 200) {
        return response.data;
      }

      // Manejar otros códigos de estado
      throw Exception('Error de autenticación: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error en la autenticación: $e');
    }
  }

  @override
  Future<CNotificacion> postEstudianteVieron(
      {required int idProfesor, required int idComunicado}) async {
    try {
      final response = await dio.post('/api/comunicado/detalle',
          data: {
            'profesor_id': idProfesor,
            'comunicado_id': idComunicado,
          },
          options: Options(
            responseType: ResponseType.json,
          ));

      if (response.statusCode == 200) {
        print(response.data['alumnos']['todos']);
        return CNotificacionMapper.fromJson(response.data);
      }

      // Manejar otros códigos de estado
      throw Exception(
          'Error al obtener detalles comunicado: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error al obtener detalles comunicado: $e');
    }
  }

  @override
  Future<CNotificacion> postVistoProfesor(
      {required int idProfesor, required int idComunicado}) async {
    try {
      final response =
          await dio.post('/api/profesor/comunicado/confirmar_visto',
              data: {
                'profesor_id': idProfesor,
                'comunicado_id': idComunicado,
              },
              options: Options(
                responseType: ResponseType.json,
              ));

      if (response.statusCode == 200) {
        return CNotificacionMapper.fromJson(response.data['comunicado']);
      }

      // Manejar otros códigos de estado
      throw Exception(
          'Error al confirmar visto del profesor: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error al confirmar visto del profesor: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> postEstudianteCR(
      {required int idEstudiante}) async {
    try {
      final response = await dio.post('api/alumno/comunicados',
          data: {
            'alumno_id': idEstudiante,
          },
          options: Options(
            responseType: ResponseType.json,
          ));

      if (response.statusCode == 200) {
        return response.data;
      }

      // Manejar otros códigos de estado
      throw Exception(
          'Error al obtener los comunicados del profesor: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error al obtener los comunicados del profesor: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> authenticateApoderado(
      {required String ci,
      required String matricula,
      required String token}) async {
    try {
      final response = await dio.post('api/alumno',
          data: {
            'ci': ci,
            'numero_matricula': matricula,
            'token_notifi': token,
          },
          options: Options(
            responseType: ResponseType.json,
          ));

      if (response.statusCode == 200) {
        return response.data;
      }

      // Manejar otros códigos de estado
      throw Exception('Error de autenticación: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error en la autenticación: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> postApoderadoCR(
      {required int idApoderado}) async {
    try {
      final response = await dio.post('api/apoderado/comunicados',
          data: {
            'apoderado_id': idApoderado,
          },
          options: Options(
            responseType: ResponseType.json,
          ));

      if (response.statusCode == 200) {
        return response.data;
      }

      // Manejar otros códigos de estado
      throw Exception(
          'Error al obtener los comunicados del profesor: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error al obtener los comunicados del profesor: $e');
    }
  }

  @override
  Future<CNotificacion> postVistoApoderado(
      {required int idApoderado, required int idComunicado}) async {
    try {
      final response =
          await dio.post('api/apoderado/comunicado/confirmar_visto',
              data: {
                'apoderado_id': idApoderado,
                'comunicado_id': idComunicado,
              },
              options: Options(
                responseType: ResponseType.json,
              ));

      if (response.statusCode == 200) {
        return CNotificacionMapper.fromJson(response.data['comunicado']);
      }

      // Manejar otros códigos de estado
      throw Exception(
          'Error al confirmar visto del profesor: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error al confirmar visto del profesor: $e');
    }
  }

  @override
  Future<CNotificacion> postVistoEstudiante(
      {required int idEstudiante, required int idComunicado}) async {
    // TODO: implement postVistoEstudiante
    try {
      final response = await dio.post('api/comunicado/confirmar_visto',
          data: {
            'alumno_id': idEstudiante,
            'comunicado_id': idComunicado,
          },
          options: Options(
            responseType: ResponseType.json,
          ));

      if (response.statusCode == 200) {
        return CNotificacionMapper.fromJson(response.data['comunicado']);
      }

      // Manejar otros códigos de estado
      throw Exception(
          'Error al confirmar visto del profesor: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error al confirmar visto del profesor: $e');
    }
  }
}
