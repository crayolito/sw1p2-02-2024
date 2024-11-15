part of 'auth_bloc.dart';

class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class OnAuthUser extends AuthEvent {
  final BuildContext context;
  final String ci;
  final String matricula;
  final String token;
  final String rol;

  const OnAuthUser({
    required this.context,
    required this.ci,
    required this.matricula,
    required this.token,
    required this.rol,
  });
}

class OnChangedComunicado extends AuthEvent {
  final CNotificacion notificacion;
  final BuildContext context;

  const OnChangedComunicado({
    required this.notificacion,
    required this.context,
  });
}

class OnResetComunicado extends AuthEvent {
  const OnResetComunicado();
}

class OnCreateComunicado extends AuthEvent {
  final int profesorId;
  final int horarioId;
  final String titulo;
  final String donde;
  final String cuando;
  final String motivo;

  const OnCreateComunicado({
    required this.profesorId,
    required this.horarioId,
    required this.titulo,
    required this.donde,
    required this.cuando,
    required this.motivo,
  });
}

class OnChangedComunicadoDe extends AuthEvent {
  final ComunicadoDe comunicadoDe;

  const OnChangedComunicadoDe(this.comunicadoDe);
}

class OnChangePermissionNotifi extends AuthEvent {
  final AuthorizationStatus status;

  const OnChangePermissionNotifi(this.status);
}

class OnCerrarSesion extends AuthEvent {
  const OnCerrarSesion();
}

class OnUpdateComunicados extends AuthEvent {
  const OnUpdateComunicados();
}

class OnFiltroComunicados extends AuthEvent {
  final String query;
  const OnFiltroComunicados(this.query);
}

class OnAddNotifi extends AuthEvent {
  final PushMessage notifi;

  const OnAddNotifi(this.notifi);
}

class OnNotificationReceived extends AuthEvent {
  final PushMessage notifi;

  const OnNotificationReceived(this.notifi);
}
