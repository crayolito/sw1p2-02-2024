import 'package:sw1p2_mobil/features/auth/domain/entities/cnotificacion.entitie.dart';

abstract class AuthRepository {
  Future<Map<String, dynamic>> authenticate(
      {required String ci, required String matricula, required String token});
  Future<Map<String, dynamic>> authenticateEstudiante(
      {required String ci, required String matricula, required String token});
  Future<Map<String, dynamic>> authenticateApoderado(
      {required String ci, required String matricula, required String token});
  // READ : POST COMUNICADOS DEL PROFESOR ENVIADOS - RECIBIDOS
  Future<Map<String, dynamic>> postProfesorCRE({required int idProfesor});
  Future<Map<String, dynamic>> postEstudianteCR({required int idEstudiante});
  Future<Map<String, dynamic>> postApoderadoCR({required int idApoderado});

  // READ : CREAR COMUNICADO
  Future<String> createComunicado({
    required int profesorId,
    required int horarioId,
    required String titulo,
    required String donde,
    required String cuando,
    required String motivo,
  });

  // READ : POST TRAER INFORMACOON QUIENES VIERON EL COMUNICADO "ESTUDIANTE"
  Future<CNotificacion> postEstudianteVieron({
    required int idProfesor,
    required int idComunicado,
  });

  // READ : POST CONFIRMACION DE VISTO DEL COMUNICADO
  Future<CNotificacion> postVistoProfesor({
    required int idProfesor,
    required int idComunicado,
  });
  Future<CNotificacion> postVistoEstudiante({
    required int idEstudiante,
    required int idComunicado,
  });
  Future<CNotificacion> postVistoApoderado({
    required int idApoderado,
    required int idComunicado,
  });
}
