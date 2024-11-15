import 'package:sw1p2_mobil/features/auth/domain/datasources/auth.datasource.dart';
import 'package:sw1p2_mobil/features/auth/domain/entities/cnotificacion.entitie.dart';
import 'package:sw1p2_mobil/features/auth/domain/repositories/auth.repositorie.dart';
import 'package:sw1p2_mobil/features/auth/infrastructure/datasources/auth.datasource.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl({AuthDatasource? datasource})
      : datasource = datasource ?? AuthDataSourceImpl();

  @override
  Future<Map<String, dynamic>> authenticate(
      {required String ci,
      required String matricula,
      required String token}) async {
    return await datasource.authenticate(
        ci: ci, matricula: matricula, token: token);
  }

  @override
  Future<Map<String, dynamic>> postProfesorCRE(
      {required int idProfesor}) async {
    return await datasource.postProfesorCRE(idProfesor: idProfesor);
  }

  @override
  Future<String> createComunicado(
      {required int profesorId,
      required int horarioId,
      required String titulo,
      required String donde,
      required String cuando,
      required String motivo}) {
    return datasource.createComunicado(
        profesorId: profesorId,
        horarioId: horarioId,
        titulo: titulo,
        donde: donde,
        cuando: cuando,
        motivo: motivo);
  }

  @override
  Future<Map<String, dynamic>> authenticateEstudiante(
      {required String ci,
      required String matricula,
      required String token}) async {
    return await datasource.authenticateEstudiante(
        ci: ci, matricula: matricula, token: token);
  }

  @override
  Future<Map<String, dynamic>> postEstudianteCR(
      {required int idEstudiante}) async {
    return await datasource.postEstudianteCR(idEstudiante: idEstudiante);
  }

  @override
  Future<Map<String, dynamic>> authenticateApoderado(
      {required String ci,
      required String matricula,
      required String token}) async {
    return await datasource.authenticateApoderado(
        ci: ci, matricula: matricula, token: token);
  }

  @override
  Future<Map<String, dynamic>> postApoderadoCR(
      {required int idApoderado}) async {
    return await datasource.postApoderadoCR(idApoderado: idApoderado);
  }

  @override
  Future<CNotificacion> postVistoApoderado(
      {required int idApoderado, required int idComunicado}) async {
    return await datasource.postVistoApoderado(
        idApoderado: idApoderado, idComunicado: idComunicado);
  }

  @override
  Future<CNotificacion> postVistoEstudiante(
      {required int idEstudiante, required int idComunicado}) async {
    return await datasource.postVistoEstudiante(
        idEstudiante: idEstudiante, idComunicado: idComunicado);
  }

  @override
  Future<CNotificacion> postEstudianteVieron(
      {required int idProfesor, required int idComunicado}) async {
    return await datasource.postEstudianteVieron(
        idProfesor: idProfesor, idComunicado: idComunicado);
  }

  @override
  Future<CNotificacion> postVistoProfesor(
      {required int idProfesor, required int idComunicado}) async {
    return await datasource.postVistoProfesor(
        idProfesor: idProfesor, idComunicado: idComunicado);
  }
}
