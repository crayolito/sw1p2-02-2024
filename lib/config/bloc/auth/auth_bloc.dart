import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sw1p2_mobil/config/bloc/auth/local_notificacions.dart';
import 'package:sw1p2_mobil/features/auth/domain/entities/apoderado.entitie.dart';
import 'package:sw1p2_mobil/features/auth/domain/entities/cnotificacion.entitie.dart';
import 'package:sw1p2_mobil/features/auth/domain/entities/estudiante.entitie.dart';
import 'package:sw1p2_mobil/features/auth/domain/entities/profesor.entitie.dart';
import 'package:sw1p2_mobil/features/auth/infrastructure/mappers/apoderado.mapper.dart';
import 'package:sw1p2_mobil/features/auth/infrastructure/mappers/estudiante.mapper.dart';
import 'package:sw1p2_mobil/features/auth/infrastructure/mappers/profesor.mapper.dart';
import 'package:sw1p2_mobil/features/auth/infrastructure/repositories/auth.repositorie.dart';
import 'package:sw1p2_mobil/firebase_options.dart';

part 'auth_event.dart';
part 'auth_state.dart';

// READ : FOREGROUND(EN PRIMER PLANO)
// READ : BACKGROUND(EN SEGUNDO PLANO)
// READ : TERMINADO(EN SEGUNDO PLANO)

Future<void> firebaseMessaingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Manejando un mensaje en segundo plano: ${message.messageId}");
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final authRepositoryImpl = AuthRepositoryImpl();
  final BuildContext context;
  // READ : NOTIFICACIONES FIREBASE
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  AuthBloc({
    required this.context,
  }) : super(AuthState()) {
    on<OnAuthUser>((event, emit) async {
      try {
        if (event.rol == 'Profesor') {
          Map<String, dynamic> data = await authRepositoryImpl.authenticate(
              ci: event.ci, matricula: event.matricula, token: event.token);

          Profesor usuario = ProfesorMapper.fromJson(data);
          emit(state.copyWith(
              authStatus: AuthStatus.profesor,
              profesor: usuario,
              cnotificacionesOfficial: [
                ...usuario.creadas,
                ...usuario.recibidas,
              ],
              cnotificacionesJob: [
                ...usuario.creadas,
                ...usuario.recibidas,
              ]));
        }

        if (event.rol == 'Alumno') {
          Map<String, dynamic> data =
              await authRepositoryImpl.authenticateEstudiante(
                  ci: event.ci, matricula: event.matricula, token: event.token);

          Estudiante usuario = EstudianteMapper.fromJson(data);
          emit(state.copyWith(
              authStatus: AuthStatus.estudiante,
              estudiante: usuario,
              cnotificacionesOfficial: usuario.recividos,
              cnotificacionesJob: usuario.recividos));
        }

        if (event.rol == 'Apoderado') {
          Map<String, dynamic> data =
              await authRepositoryImpl.authenticateApoderado(
                  ci: event.ci, matricula: event.matricula, token: event.token);

          Apoderado usuario = ApoderadoMapper.fromJson(data);
          emit(state.copyWith(
              authStatus: AuthStatus.apoderado,
              apoderado: usuario,
              cnotificacionesOfficial: usuario.comunicados,
              cnotificacionesJob: usuario.comunicados));
        }
      } catch (e) {
        // Manejar cualquier otro error inesperado
        ScaffoldMessenger.of(event.context).showSnackBar(
          const SnackBar(
            content:
                Text('Credenciales incorrectas. Por favor verifique sus datos'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    });

    on<OnCerrarSesion>((event, emit) {
      emit(state.copyWith(
          authStatus: AuthStatus.none,
          apoderado: null,
          profesor: null,
          estudiante: null,
          cnotificacionesOfficial: [],
          cnotificacionesJob: [],
          comunicadoDe: ComunicadoDe.todos));
    });

    on<OnChangedComunicadoDe>((event, emit) async {
      if (state.authStatus == AuthStatus.profesor) {
        Map<String, dynamic> data = await authRepositoryImpl.postProfesorCRE(
            idProfesor: state.profesor!.id);

        List<CNotificacion> enviados = ProfesorMapper.parseoNotificaciones(
            data['comunicados_creados'] ?? []);
        List<CNotificacion> recividos = ProfesorMapper.parseoNotificaciones(
            data['comunicados_recibidos'] ?? []);

        if (event.comunicadoDe == ComunicadoDe.enviadoProfesor) {
          emit(state.copyWith(
              comunicadoDe: event.comunicadoDe,
              cnotificacionesOfficial: enviados,
              cnotificacionesJob: enviados));
        }

        if (event.comunicadoDe == ComunicadoDe.recibidoProfesor) {
          emit(state.copyWith(
              comunicadoDe: event.comunicadoDe,
              cnotificacionesOfficial: recividos,
              cnotificacionesJob: recividos));
        }

        if (event.comunicadoDe == ComunicadoDe.todos) {
          emit(state.copyWith(
              comunicadoDe: event.comunicadoDe,
              cnotificacionesOfficial: [
                ...enviados,
                ...recividos,
              ],
              cnotificacionesJob: [
                ...enviados,
                ...recividos,
              ]));
        }
      }

      if (state.authStatus == AuthStatus.estudiante) {
        Map<String, dynamic> data = await authRepositoryImpl.postEstudianteCR(
            idEstudiante: state.estudiante!.id);
        List<CNotificacion> todos =
            ProfesorMapper.parseoNotificaciones(data['comunicados'] ?? []);

        // Función auxiliar para normalizar el texto
        String normalizeText(String text) {
          return text
              .replaceAll('\n', '') // elimina saltos de línea
              .replaceAll(
                  RegExp(r'\s+'), ' ') // reemplaza múltiples espacios por uno
              .trim()
              .toLowerCase();
        }

        // Filtrar para directiva
        List<CNotificacion> directiva = todos.where((notif) {
          String normalizedMotivo = normalizeText(notif.motivo);
          return normalizedMotivo.contains("dir. escolar,".toLowerCase());
        }).toList();

        // Filtrar para escolares
        List<CNotificacion> escolares = todos.where((notif) {
          String normalizedMotivo = normalizeText(notif.motivo);
          return !normalizedMotivo.contains("dir. escolar,".toLowerCase());
        }).toList();

        if (event.comunicadoDe == ComunicadoDe.direccionEstudiante) {
          emit(state.copyWith(
              comunicadoDe: event.comunicadoDe,
              cnotificacionesOfficial: directiva,
              cnotificacionesJob: directiva));
        }

        if (event.comunicadoDe == ComunicadoDe.materiasEstudiante) {
          emit(state.copyWith(
              comunicadoDe: event.comunicadoDe,
              cnotificacionesOfficial: escolares,
              cnotificacionesJob: escolares));
        }

        if (event.comunicadoDe == ComunicadoDe.todos) {
          emit(state.copyWith(
              comunicadoDe: event.comunicadoDe,
              cnotificacionesOfficial: todos,
              cnotificacionesJob: todos));
        }
      }

      if (state.authStatus == AuthStatus.apoderado) {
        Map<String, dynamic> data = await authRepositoryImpl.postApoderadoCR(
            idApoderado: state.apoderado!.id);

        List<CNotificacion> todos =
            ProfesorMapper.parseoNotificaciones(data['comunicados'] ?? []);

        // Función auxiliar para normalizar el texto
        String normalizeText(String text) {
          return text
              .replaceAll('\n', '') // elimina saltos de línea
              .replaceAll(
                  RegExp(r'\s+'), ' ') // reemplaza múltiples espacios por uno
              .trim()
              .toLowerCase();
        }

        // Filtrar para directiva
        List<CNotificacion> directiva = todos.where((notif) {
          String normalizedMotivo = normalizeText(notif.motivo);
          return normalizedMotivo.contains("dir. escolar,".toLowerCase());
        }).toList();

        // Filtrar para escolares
        List<CNotificacion> escolares = todos.where((notif) {
          String normalizedMotivo = normalizeText(notif.motivo);
          return !normalizedMotivo.contains("dir. escolar,".toLowerCase());
        }).toList();

        if (event.comunicadoDe == ComunicadoDe.direccionApoderado) {
          emit(state.copyWith(
              comunicadoDe: event.comunicadoDe,
              cnotificacionesOfficial: directiva,
              cnotificacionesJob: directiva));
        }

        if (event.comunicadoDe == ComunicadoDe.parientesApoderado) {
          emit(state.copyWith(
              comunicadoDe: event.comunicadoDe,
              cnotificacionesOfficial: escolares,
              cnotificacionesJob: escolares));
        }

        if (event.comunicadoDe == ComunicadoDe.todos) {
          emit(state.copyWith(
              comunicadoDe: event.comunicadoDe,
              cnotificacionesOfficial: todos,
              cnotificacionesJob: todos));
        }
      }
    });

    // on<OnUpdateComunicados>((event, emit) async {
    //   Map<String, dynamic> data = await authRepositoryImpl.postProfesorCRE(
    //       idProfesor: state.profesor!.id);

    //   List<CNotificacion> enviados = ProfesorMapper.parseoNotificaciones(
    //       data['comunicados_creados'] ?? []);
    //   List<CNotificacion> recividos = ProfesorMapper.parseoNotificaciones(
    //       data['comunicados_recibidos'] ?? []);

    //   emit(state
    //       .copyWith(comunicadoDe: ComunicadoDe.todos, cnotificacionesOfficial: [
    //     ...enviados,
    //     ...recividos,
    //   ], cnotificacionesJob: [
    //     ...enviados,
    //     ...recividos,
    //   ]));
    // });

    on<OnFiltroComunicados>((event, emit) {
      if (event.query.isEmpty) {
        emit(state.copyWith(
          cnotificacionesJob: state.cnotificacionesOfficial,
        ));
        return;
      }

      final query = event.query.toLowerCase().trim();

      try {
        final notificacionesFiltradas =
            state.cnotificacionesOfficial.where((notif) {
          // Normalizar campos directamente
          final tituloNormalizado = notif.titulo.toLowerCase().trim();
          final motivoNormalizado = notif.motivo.toLowerCase().trim();

          // Buscar coincidencias por palabras
          final queryWords = query.split(' ');

          return queryWords.every((word) =>
              tituloNormalizado.contains(word) ||
              motivoNormalizado.contains(word));
        }).toList();

        emit(state.copyWith(
          cnotificacionesJob: notificacionesFiltradas,
        ));
      } catch (e) {
        emit(state.copyWith(
          cnotificacionesJob: state.cnotificacionesOfficial,
        ));
      }
    });

    on<OnChangePermissionNotifi>((event, emit) {
      emit(state.copyWith(
          isNotifiPermission: event.status == AuthorizationStatus.authorized,
          statusNotification: event.status));
    });

    on<OnChangedComunicado>((event, emit) async {
      CNotificacion currentNotificacion = event.notificacion;

      if (state.authStatus == AuthStatus.profesor) {
        // Obtener actualización según el tipo de usuario
        CNotificacion updatedNotificacion = !currentNotificacion.profesorCreador
            ? await authRepositoryImpl.postVistoProfesor(
                idProfesor: state.profesor!.id,
                idComunicado: currentNotificacion.id)
            : await authRepositoryImpl.postEstudianteVieron(
                idComunicado: currentNotificacion.id,
                idProfesor: state.profesor!.id);

        // Siempre preservar el motivo original y actualizar el resto
        final mergedNotificacion = CNotificacion(
            id: updatedNotificacion.id,
            titulo: updatedNotificacion.titulo,
            donde: updatedNotificacion.donde,
            cuando: updatedNotificacion.cuando,
            motivo: currentNotificacion.motivo, // Mantener motivo original
            imagen: updatedNotificacion.imagen,
            extra: updatedNotificacion.extra,
            profesorCreador: updatedNotificacion.profesorCreador,
            receptores: updatedNotificacion.receptores);

        emit(state.copyWith(notificacion: mergedNotificacion));
      }

      if (state.authStatus == AuthStatus.estudiante) {
        // Obtener actualización según el tipo de usuario
        CNotificacion updatedNotificacion =
            await authRepositoryImpl.postVistoEstudiante(
                idEstudiante: state.estudiante!.id,
                idComunicado: currentNotificacion.id);

        // Siempre preservar el motivo original y actualizar el resto
        final mergedNotificacion = CNotificacion(
            id: updatedNotificacion.id,
            titulo: updatedNotificacion.titulo,
            donde: updatedNotificacion.donde,
            cuando: updatedNotificacion.cuando,
            motivo: currentNotificacion.motivo, // Mantener motivo original
            imagen: updatedNotificacion.imagen,
            extra: updatedNotificacion.extra,
            profesorCreador: updatedNotificacion.profesorCreador,
            receptores: updatedNotificacion.receptores);

        emit(state.copyWith(notificacion: mergedNotificacion));
      }

      if (state.authStatus == AuthStatus.apoderado) {
        // Obtener actualización según el tipo de usuario

        if (!currentNotificacion.profesorCreador) {
          emit(state.copyWith(notificacion: currentNotificacion));
          event.context.push("/view-comunicado");
          return;
        }

        CNotificacion updatedNotificacion = !currentNotificacion.profesorCreador
            ? await authRepositoryImpl.postVistoApoderado(
                idApoderado: state.profesor!.id,
                idComunicado: currentNotificacion.id)
            : await authRepositoryImpl.postVistoApoderado(
                idComunicado: currentNotificacion.id,
                idApoderado: state.profesor!.id);

        // CNotificacion updatedNotificacion =
        //     await authRepositoryImpl.postVistoApoderado(
        //         idApoderado: state.apoderado!.id,
        //         idComunicado: currentNotificacion.id);

        // Siempre preservar el motivo original y actualizar el resto
        final mergedNotificacion = CNotificacion(
            id: updatedNotificacion.id,
            titulo: updatedNotificacion.titulo,
            donde: updatedNotificacion.donde,
            cuando: updatedNotificacion.cuando,
            motivo: currentNotificacion.motivo, // Mantener motivo original
            imagen: updatedNotificacion.imagen,
            extra: updatedNotificacion.extra,
            profesorCreador: updatedNotificacion.profesorCreador,
            receptores: updatedNotificacion.receptores);

        emit(state.copyWith(notificacion: mergedNotificacion));
      }

      event.context.push("/view-comunicado");
    });

    on<OnResetComunicado>((event, emit) {
      emit(state.copyWith(notificacion: null));
    });

    // LOGIC : VERIFICAR ESTADO DE PERMISO DE NOTIFICACIONES
    _initialStatusCheck();
    // LOGIC : OBTENER NOTIFICACIONES EN PRIMER PLANO
    _onForegroundMessage();
  }

  // READ : METODOS DE USO A TODO LO REFENTE A LAS NOTIFICACIONES
  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  void _initialStatusCheck() async {
    final settings = await messaging.getNotificationSettings();
    add(OnChangePermissionNotifi(settings.authorizationStatus));
  }

  void _getFCMToken() async {
    final settings = await messaging.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final token = await messaging.getToken();
      print('Token: $token');
    }
  }

  Future<String> getFCMTokenProvisional() async {
    final settings = await messaging.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final token = await messaging.getToken();
      print('Token: $token');
      return token!;
    } else {
      print('Notificaciones no autorizadas');
      return "Presiona el boton"; // O lanza una excepción si prefieres manejarlo de otra manera
    }
  }

  void handleRemoteMessage(RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('onMessage1: $message');
    print('onMessage2: ${message.data}');
    print('onMessage3: ${message.notification}');
    if (message.notification == null) return;
    final notification = PushMessage(
      messageId:
          message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '',
      title: message.notification!.title ?? '',
      body: message.notification!.body ?? '',
      sentDate: message.sentTime ?? DateTime.now(),
      data: message.data,
      imageURL: Platform.isAndroid
          ? message.notification!.android?.imageUrl
          : message.notification!.apple?.imageUrl,
    );
    // print(pushMessage.toString());
    LocalNotifications.showLocalNotification(
      id: 1,
      body: notification.body,
      data: notification.data.toString(),
      title: notification.title,
    );
    // add(OnNotificationReceived(notification));
  }

  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }

  Future<void> requestPermissions() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    // TODO: SOLICITAR PERMISOS DE NOTIFICACIONES LOCALES
    await LocalNotifications.requestPermissionLocalNotifications();
    add(OnChangePermissionNotifi(settings.authorizationStatus));
  }

  PushMessage? getMessageById(String messageId) {
    final exist =
        state.notificaciones.any((element) => element.messageId == messageId);
    if (exist) {
      return state.notificaciones
          .firstWhere((element) => element.messageId == messageId);
    }
    return null;
  }
}
