import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sw1p2_mobil/config/bloc/auth/auth_bloc.dart';
import 'package:sw1p2_mobil/config/bloc/auth/local_notificacions.dart';
import 'package:sw1p2_mobil/config/router/app.router.dart';
import 'package:sw1p2_mobil/config/singleton/estilos.singleton.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(firebaseMessaingBackgroundHandler);
  await AuthBloc.initializeFCM();
  // TODO : Initialize Local Notifications
  await LocalNotifications.initializeLocalNotifications();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => AuthBloc(context: context)),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      EstilosSingleton.inicializar(context);

      return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
        builder: (context, child) =>
            HandleNotificationInteractions(child: child!),
      );
    });
  }
}

class HandleNotificationInteractions extends StatefulWidget {
  const HandleNotificationInteractions({super.key, required this.child});
  final Widget child;

  @override
  State<HandleNotificationInteractions> createState() =>
      _HandleNotificacionInteractionsState();
}

class _HandleNotificacionInteractionsState
    extends State<HandleNotificationInteractions> {
  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    // final permissionsBloc = BlocProvider.of<PermissionsBloc>(context);
    // permissionsBloc.handleRemoteMessage(message);
    context.read<AuthBloc>().handleRemoteMessage(message);

    final messageId =
        message.messageId?.replaceAll(':', '').replaceAll('%', '');
    appRouter.push('/push-details/$messageId');

    // if (message.data['type'] == 'chat') {
    // Navigator.pushNamed(context, '/chat',
    //   arguments: ChatArguments(message),
    // );
    // }
  }

  @override
  void initState() {
    super.initState();

    // Run code required to handle interacted messages in an async function
    // as initState() must not be async
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
