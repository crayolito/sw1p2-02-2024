part of 'auth_bloc.dart';

enum AuthStatus { profesor, estudiante, apoderado, none }

enum ComunicadoDe {
  enviadoProfesor,
  recibidoProfesor,

  direccionEstudiante,
  materiasEstudiante,

  direccionApoderado,
  parientesApoderado,

  todos
}

// ignore: must_be_immutable
class AuthState extends Equatable {
  final AuthStatus authStatus;
  final ComunicadoDe comunicadoDe;
  Profesor? profesor;
  Estudiante? estudiante;
  Apoderado? apoderado;
  final List<CNotificacion> cnotificacionesOfficial;
  final List<CNotificacion> cnotificacionesJob;
  CNotificacion? notificacion;
  // LOGIC : PERMISOS NOTIFICACIONES
  final bool isNotifiPermission;
  final AuthorizationStatus statusNotification;
  final List<PushMessage> notificaciones;

  AuthState(
      {this.authStatus = AuthStatus.none,
      this.comunicadoDe = ComunicadoDe.todos,
      this.profesor,
      this.estudiante,
      this.apoderado,
      this.isNotifiPermission = false,
      this.statusNotification = AuthorizationStatus.notDetermined,
      this.cnotificacionesOfficial = const [],
      this.cnotificacionesJob = const [],
      this.notificacion,
      this.notificaciones = const []});

  AuthState copyWith({
    AuthStatus? authStatus,
    ComunicadoDe? comunicadoDe,
    Profesor? profesor,
    Estudiante? estudiante,
    Apoderado? apoderado,
    bool? isNotifiPermission,
    AuthorizationStatus? statusNotification,
    List<CNotificacion>? cnotificacionesOfficial,
    List<CNotificacion>? cnotificacionesJob,
    CNotificacion? notificacion,
    List<PushMessage>? notificaciones,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      profesor: profesor ?? this.profesor,
      comunicadoDe: comunicadoDe ?? this.comunicadoDe,
      estudiante: estudiante ?? this.estudiante,
      apoderado: apoderado ?? this.apoderado,
      isNotifiPermission: isNotifiPermission ?? this.isNotifiPermission,
      statusNotification: statusNotification ?? this.statusNotification,
      cnotificacionesOfficial:
          cnotificacionesOfficial ?? this.cnotificacionesOfficial,
      cnotificacionesJob: cnotificacionesJob ?? this.cnotificacionesJob,
      notificacion: notificacion ?? this.notificacion,
      notificaciones: notificaciones ?? this.notificaciones,
    );
  }

  @override
  List<Object?> get props => [
        authStatus,
        profesor,
        estudiante,
        apoderado,
        isNotifiPermission,
        statusNotification,
        cnotificacionesOfficial,
        cnotificacionesJob,
        notificacion,
        notificaciones,
        comunicadoDe
      ];
}
