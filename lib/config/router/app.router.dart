import 'package:go_router/go_router.dart';
import 'package:sw1p2_mobil/features/auth/presentation/screens/auth.screen.dart';
import 'package:sw1p2_mobil/features/auth/presentation/screens/crear-comunicado.screen.dart';
import 'package:sw1p2_mobil/features/auth/presentation/screens/ia-estudiante.screen.dart';
import 'package:sw1p2_mobil/features/auth/presentation/screens/ia-profesor.screen.dart';
import 'package:sw1p2_mobil/features/auth/presentation/screens/list-comunicado.screen.dart';
import 'package:sw1p2_mobil/features/auth/presentation/screens/view-comunicado.screen.dart';

final appRouter = GoRouter(initialLocation: '/', routes: [
  GoRoute(path: '/', builder: (context, state) => const AuthScreen()),
  GoRoute(
      path: '/list-comunicados',
      builder: (context, state) => const ComunicadosScreen()),
  GoRoute(
      path: '/view-comunicado',
      builder: (context, state) => const ViewComunicadoScreen()),
  GoRoute(
      path: '/create-comunicado',
      builder: (context, state) => const CrearComunicadoScreen()),
  GoRoute(
      path: '/ia-profesor',
      builder: (context, state) => const IAProfesorScreen()),
  GoRoute(
      path: '/ia-estudiante',
      builder: (context, state) => const IAEstudianteScreen()),
]);
