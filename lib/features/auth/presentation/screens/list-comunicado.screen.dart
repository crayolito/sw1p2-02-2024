import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sw1p2_mobil/config/bloc/auth/auth_bloc.dart';
import 'package:sw1p2_mobil/config/constant/paletaColores.const.dart';
import 'package:sw1p2_mobil/config/singleton/estilos.singleton.dart';
import 'package:sw1p2_mobil/features/auth/domain/entities/cnotificacion.entitie.dart';

class ComunicadosScreen extends StatefulWidget {
  const ComunicadosScreen({super.key});

  @override
  State<ComunicadosScreen> createState() => _ComunicadosScreenState();
}

class _ComunicadosScreenState extends State<ComunicadosScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final estilos = EstilosSingleton.instance.estilos;
    final authBloc = BlocProvider.of<AuthBloc>(context, listen: true);
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.white,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: size.height * 0.05,
                left: size.width * 0.01,
                right: size.width * 0.01,
              ),
              alignment: Alignment.topCenter,
              height: size.height * 0.17,
              width: size.width,
              color: kCuartoColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  authBloc.state.authStatus == AuthStatus.apoderado
                      ? SizedBox(width: size.width * 0.08)
                      : IconButton(
                          onPressed: () {
                            // Navigator.pop(context);
                            if (authBloc.state.authStatus ==
                                AuthStatus.profesor) {
                              context.push("/ia-profesor");
                            } else {
                              context.push("/ia-estudiante");
                            }
                          },
                          icon: Icon(
                            Icons.psychology,
                            color: Colors.white,
                            size: size.width * 0.08,
                          ),
                        ),
                  Text(
                    "Comunicados",
                    style: estilos.tituloComunicados,
                  ),
                  IconButton(
                    onPressed: () {
                      showOptionsDialog(context);
                    },
                    icon: Icon(
                      Icons.tune,
                      color: Colors.white,
                      size: size.width * 0.08,
                    ),
                  ),
                ],
              ),
            ),
            const ListItemsCustom(),
            const SearchBarCustom(),
          ],
        ),
      ),
    );
  }

  void showOptionsDialog(BuildContext context) {
    final size = MediaQuery.of(context).size;

    showDialog(
      context: context,
      barrierColor: kCuartoColor.withOpacity(0.5),
      builder: (BuildContext context) {
        return DialogContainer(
          size: size,
          child: const OpcionesCustomLC(),
        );
      },
    );
  }
}

class ListItemsCustom extends StatefulWidget {
  const ListItemsCustom({
    super.key,
  });

  @override
  State<ListItemsCustom> createState() => _ListItemsCustomState();
}

class _ListItemsCustomState extends State<ListItemsCustom> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final estilos = EstilosSingleton.instance.estilos;
    final authBloc = BlocProvider.of<AuthBloc>(context, listen: true);

    return Positioned(
      top: size.height * 0.17,
      child: Container(
          width: size.width,
          height: size.height * 0.83,
          color: Colors.white,
          child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                top: size.height * 0.025,
              ),
              itemCount: authBloc.state.cnotificacionesJob.length,
              itemBuilder: (context, index) {
                CNotificacion elemento =
                    authBloc.state.cnotificacionesJob[index];

                return GestureDetector(
                  onTap: () {
                    authBloc.add(OnChangedComunicado(
                        context: context, notificacion: elemento));
                    // context.push("/view-comunicado");
                  },
                  child: FadeIn(
                    animate: true,
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      margin: EdgeInsets.only(
                        left: size.width * 0.02,
                      ),
                      width: size.width,
                      height: size.height * 0.15,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.01,
                              vertical: size.height * 0.01,
                            ),
                            width: size.width * 0.18,
                            height: size.height * 0.12,
                            child: DecoratedBox(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            getAssetUrl(elemento.titulo)),
                                        fit: BoxFit.contain))),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              top: size.height * 0.015,
                              bottom: size.height * 0.015,
                              right: size.height * 0.015,
                            ),
                            margin: EdgeInsets.only(
                              left: size.width * 0.03,
                            ),
                            width: size.width * 0.77,
                            height: size.height * 0.2,
                            decoration: BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                color: kTerciaryColor.withOpacity(0.2),
                                width: size.width * 0.005,
                              ),
                            )),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  elemento.titulo,
                                  style: estilos.letra1Comunicados,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(elemento.cuando,
                                    style: estilos.letra2Comunicados,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                Text(elemento.motivo,
                                    style: estilos.letra3Comunicados,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              })),
    );
  }

  String getAssetUrl(String tipo) {
    switch (tipo) {
      // Administrativo
      case 'Informativos oficiales':
        return 'assets/informativos.png';
      case 'Emergencias':
        return 'assets/emergencias.png';
      case 'Eventos escolares':
        return 'assets/eventos.png';
      case 'Reuniones generales':
        return 'assets/reuniones.png';
      case 'Circulares generales':
        return 'assets/circulares.png';
      // Profesor
      case 'Rendimiento académico':
        return 'assets/rendimiento.png';
      case 'Comportamiento del alumno':
        return 'assets/comportamiento.png';
      case 'Citación a apoderados':
        return 'assets/citaciones.png';
      case 'Tareas y evaluaciones':
        return 'assets/tareas.png';
      case 'Felicitaciones':
        return 'assets/felicitaciones.png';
      default:
        return 'assets/default.png';
    }
  }
}

class SearchBarCustom extends StatefulWidget {
  const SearchBarCustom({
    super.key,
  });

  @override
  State<SearchBarCustom> createState() => _SearchBarCustomState();
}

class _SearchBarCustomState extends State<SearchBarCustom> {
  final myController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    // TODO: implement initState
    myController.dispose();
    _debounce?.cancel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final estilos = EstilosSingleton.instance.estilos;
    final authBloc = BlocProvider.of<AuthBloc>(context, listen: true);

    return Positioned(
      top: size.height * 0.12,
      left: size.width * 0.05,
      right: size.width * 0.05,
      child: Container(
        height: size.height * 0.08,
        width: size.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              size.width * 0.03,
            ),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: kCuartoColor, // Color de la sombra
                offset: Offset(0, 2), // Desplazamiento (x,y)
                blurRadius: 8, // Radio de desenfoque
                spreadRadius: 0, // Radio de extensión
              ),
            ]),
        child: TextFormField(
          style: estilos.letraInput,
          decoration: InputDecoration(
            hintText: 'Buscar comunicado',
            hintStyle: estilos.placeholderInput,
            prefixIcon: const Icon(Icons.search),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            if (_debounce?.isActive ?? false) _debounce!.cancel();
            _debounce = Timer(const Duration(milliseconds: 500), () {
              authBloc.add(OnFiltroComunicados(value));
            });
          },
        ),
      ),
    );
  }
}

// class OpcionesCustomLC extends StatelessWidget {
//   const OpcionesCustomLC({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final estilos = EstilosSingleton.instance.estilos;
//     final authBloc = BlocProvider.of<AuthBloc>(context, listen: true);

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const OpcionesFiltroLC(),
//         Text("Acciones de Comunicado", style: estilos.letra1OptionsComunicados),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 context.push("/create-comunicado");
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: size.width * 0.02,
//                   vertical: size.height * 0.005,
//                 ),
//                 decoration: BoxDecoration(
//                     border: Border(
//                   bottom: BorderSide(
//                     color: kCuartoColor,
//                     width: size.width * 0.005,
//                   ),
//                 )),
//                 child: Text("Crear", style: estilos.letra2OptionsComunicados),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 authBloc.add(const OnUpdateComunicados());
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: size.width * 0.02,
//                   vertical: size.height * 0.005,
//                 ),
//                 decoration: BoxDecoration(
//                     border: Border(
//                   bottom: BorderSide(
//                     color: kCuartoColor,
//                     width: size.width * 0.005,
//                   ),
//                 )),
//                 child:
//                     Text("Actualizar", style: estilos.letra2OptionsComunicados),
//               ),
//             ),
//           ],
//         ),
//         const OpcionesUsuario()
//       ],
//     );
//   }
// }

// class OpcionesUsuario extends StatelessWidget {
//   const OpcionesUsuario({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final estilos = EstilosSingleton.instance.estilos;
//     final authBloc = BlocProvider.of<AuthBloc>(context, listen: true);

//     return Column(
//       children: [
//         Text("Opciones de Usuario", style: estilos.letra1OptionsComunicados),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             GestureDetector(
//               onTap: () {},
//               child: Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: size.width * 0.02,
//                   vertical: size.height * 0.005,
//                 ),
//                 decoration: BoxDecoration(
//                     border: Border(
//                   bottom: BorderSide(
//                     color: kCuartoColor,
//                     width: size.width * 0.005,
//                   ),
//                 )),
//                 child: Text("Perfil", style: estilos.letra2OptionsComunicados),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 authBloc.add(const OnCerrarSesion());
//                 context.go("/");
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: size.width * 0.02,
//                   vertical: size.height * 0.005,
//                 ),
//                 decoration: BoxDecoration(
//                     border: Border(
//                   bottom: BorderSide(
//                     color: kCuartoColor,
//                     width: size.width * 0.005,
//                   ),
//                 )),
//                 child: Text("Salir", style: estilos.letra2OptionsComunicados),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// class OpcionesFiltroLC extends StatelessWidget {
//   const OpcionesFiltroLC({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final estilos = EstilosSingleton.instance.estilos;
//     final authBloc = BlocProvider.of<AuthBloc>(context, listen: true);
//     bool todos = authBloc.state.comunicadoDe == ComunicadoDe.todos;

//     if (authBloc.state.authStatus == AuthStatus.profesor) {
//       bool enviadoProfesor =
//           authBloc.state.comunicadoDe == ComunicadoDe.enviadoProfesor;
//       bool recibidoProfesor =
//           authBloc.state.comunicadoDe == ComunicadoDe.recibidoProfesor;

//       return Column(
//         children: [
//           Text("Opciones de Filtro", style: estilos.letra1OptionsComunicados),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   authBloc.add(const OnChangedComunicadoDe(
//                       ComunicadoDe.enviadoProfesor));
//                   print(authBloc.state.comunicadoDe);
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: size.width * 0.02,
//                     vertical: size.height * 0.005,
//                   ),
//                   decoration: BoxDecoration(
//                     border: enviadoProfesor
//                         ? Border(
//                             bottom: BorderSide(
//                               color: kCuartoColor,
//                               width: size.width * 0.005,
//                             ),
//                           )
//                         : null,
//                   ),
//                   child: Text("Enviados",
//                       style: enviadoProfesor
//                           ? estilos.letra2OptionsComunicados
//                           : estilos.letra3OptionsComunicados),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   authBloc.add(const OnChangedComunicadoDe(
//                       ComunicadoDe.recibidoProfesor));
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: size.width * 0.02,
//                     vertical: size.height * 0.005,
//                   ),
//                   decoration: BoxDecoration(
//                     border: recibidoProfesor
//                         ? Border(
//                             bottom: BorderSide(
//                               color: kCuartoColor,
//                               width: size.width * 0.005,
//                             ),
//                           )
//                         : null,
//                   ),
//                   child: Text("Recibidos",
//                       style: recibidoProfesor
//                           ? estilos.letra2OptionsComunicados
//                           : estilos.letra3OptionsComunicados),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   authBloc.add(const OnChangedComunicadoDe(ComunicadoDe.todos));
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: size.width * 0.02,
//                     vertical: size.height * 0.005,
//                   ),
//                   decoration: BoxDecoration(
//                     border: todos
//                         ? Border(
//                             bottom: BorderSide(
//                               color: kCuartoColor,
//                               width: size.width * 0.005,
//                             ),
//                           )
//                         : null,
//                   ),
//                   child: Text("Todos",
//                       style: todos
//                           ? estilos.letra2OptionsComunicados
//                           : estilos.letra3OptionsComunicados),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       );
//     }

//     if (authBloc.state.authStatus == AuthStatus.apoderado) {
//       bool direccionApoderado =
//           authBloc.state.comunicadoDe == ComunicadoDe.direccionApoderado;
//       bool parientesApoderado =
//           authBloc.state.comunicadoDe == ComunicadoDe.parientesApoderado;

//       return Column(
//         children: [
//           Text("Opciones de Filtro", style: estilos.letra1OptionsComunicados),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   authBloc.add(const OnChangedComunicadoDe(
//                       ComunicadoDe.direccionApoderado));
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: size.width * 0.02,
//                     vertical: size.height * 0.005,
//                   ),
//                   decoration: BoxDecoration(
//                     border: direccionApoderado
//                         ? Border(
//                             bottom: BorderSide(
//                               color: kCuartoColor,
//                               width: size.width * 0.005,
//                             ),
//                           )
//                         : null,
//                   ),
//                   child: Text("Dir. Escolar",
//                       style: direccionApoderado
//                           ? estilos.letra2OptionsComunicados
//                           : estilos.letra3OptionsComunicados),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   authBloc.add(const OnChangedComunicadoDe(
//                       ComunicadoDe.parientesApoderado));
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: size.width * 0.02,
//                     vertical: size.height * 0.005,
//                   ),
//                   decoration: BoxDecoration(
//                     border: parientesApoderado
//                         ? Border(
//                             bottom: BorderSide(
//                               color: kCuartoColor,
//                               width: size.width * 0.005,
//                             ),
//                           )
//                         : null,
//                   ),
//                   child: Text("Estudiantes",
//                       style: parientesApoderado
//                           ? estilos.letra2OptionsComunicados
//                           : estilos.letra3OptionsComunicados),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   authBloc.add(const OnChangedComunicadoDe(ComunicadoDe.todos));
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: size.width * 0.02,
//                     vertical: size.height * 0.005,
//                   ),
//                   decoration: BoxDecoration(
//                     border: todos
//                         ? Border(
//                             bottom: BorderSide(
//                               color: kCuartoColor,
//                               width: size.width * 0.005,
//                             ),
//                           )
//                         : null,
//                   ),
//                   child: Text("Todos",
//                       style: todos
//                           ? estilos.letra2OptionsComunicados
//                           : estilos.letra3OptionsComunicados),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       );
//     }

//     if (authBloc.state.authStatus == AuthStatus.estudiante) {
//       bool direccionEstudiante =
//           authBloc.state.comunicadoDe == ComunicadoDe.direccionEstudiante;
//       bool materiasEstudiante =
//           authBloc.state.comunicadoDe == ComunicadoDe.materiasEstudiante;
//       return Column(
//         children: [
//           Text("Opciones de Filtro", style: estilos.letra1OptionsComunicados),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   authBloc.add(const OnChangedComunicadoDe(
//                       ComunicadoDe.direccionEstudiante));
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: size.width * 0.02,
//                     vertical: size.height * 0.005,
//                   ),
//                   decoration: BoxDecoration(
//                     border: direccionEstudiante
//                         ? Border(
//                             bottom: BorderSide(
//                               color: kCuartoColor,
//                               width: size.width * 0.005,
//                             ),
//                           )
//                         : null,
//                   ),
//                   child: Text("Dir. Escolar",
//                       style: direccionEstudiante
//                           ? estilos.letra2OptionsComunicados
//                           : estilos.letra3OptionsComunicados),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {},
//                 child: Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: size.width * 0.02,
//                     vertical: size.height * 0.005,
//                   ),
//                   decoration: BoxDecoration(
//                     border: materiasEstudiante
//                         ? Border(
//                             bottom: BorderSide(
//                               color: kCuartoColor,
//                               width: size.width * 0.005,
//                             ),
//                           )
//                         : null,
//                   ),
//                   child: Text("Materias",
//                       style: materiasEstudiante
//                           ? estilos.letra2OptionsComunicados
//                           : estilos.letra3OptionsComunicados),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   authBloc.add(const OnChangedComunicadoDe(ComunicadoDe.todos));
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: size.width * 0.02,
//                     vertical: size.height * 0.005,
//                   ),
//                   decoration: BoxDecoration(
//                     border: todos
//                         ? Border(
//                             bottom: BorderSide(
//                               color: kCuartoColor,
//                               width: size.width * 0.005,
//                             ),
//                           )
//                         : null,
//                   ),
//                   child: Text("Todos",
//                       style: todos
//                           ? estilos.letra2OptionsComunicados
//                           : estilos.letra3OptionsComunicados),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       );
//     }

//     return Container();
//   }
// }

class DialogContainer extends StatelessWidget {
  final Widget child;
  final Size size;

  const DialogContainer({
    super.key,
    required this.child,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: size.width * 0.92,
        height: size.height * 0.6,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(size.width * 0.03),
          boxShadow: [
            BoxShadow(
              color: kCuartoColor.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 20,
              offset: Offset(0, size.height * 0.01),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size.width * 0.03),
          child: child,
        ),
      ),
    );
  }
}

// styled_option_button.dart
class StyledOptionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isSelected;
  final IconData? icon;
  final Size size;

  const StyledOptionButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.size,
    this.isSelected = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04,
          vertical: size.height * 0.012,
        ),
        decoration: BoxDecoration(
          color: isSelected ? kSecondaryColor : kPrimaryColor,
          borderRadius: BorderRadius.circular(size.width * 0.03),
          border: Border.all(
            color: isSelected ? kCuartoColor : kTerciaryColor.withOpacity(0.5),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: kCuartoColor.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: Offset(0, size.height * 0.002),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: size.width * 0.045,
                color: isSelected ? kCuartoColor : kTerciaryColor,
              ),
              SizedBox(width: size.width * 0.02),
            ],
            Text(
              text,
              style: TextStyle(
                color: isSelected ? kCuartoColor : kTerciaryColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: size.width * 0.035,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// options_header.dart
class OptionsHeader extends StatelessWidget {
  final String title;
  final Size size;

  const OptionsHeader({
    super.key,
    required this.title,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.02,
        horizontal: size.width * 0.04,
      ),
      decoration: BoxDecoration(
        color: kSecondaryColor.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(
            color: kTerciaryColor.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: kCuartoColor,
              fontSize: size.width * 0.045,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.close,
              color: kCuartoColor,
              size: size.width * 0.055,
            ),
          ),
        ],
      ),
    );
  }
}

// options_section.dart
class OptionsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Size size;

  const OptionsSection({
    super.key,
    required this.title,
    required this.children,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
            vertical: size.height * 0.01,
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: size.width * 0.038,
              fontWeight: FontWeight.w500,
              color: kTerciaryColor,
              letterSpacing: 0.3,
            ),
          ),
        ),
        Container(
          height: size.height * 0.07,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.04,
              vertical: size.height * 0.005,
            ),
            children: children.map((child) {
              return Padding(
                padding: EdgeInsets.only(right: size.width * 0.02),
                child: child,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class OpcionesCustomLC extends StatelessWidget {
  const OpcionesCustomLC({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authBloc = BlocProvider.of<AuthBloc>(context, listen: true);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        OptionsHeader(
          title: 'Opciones y Filtros',
          size: size,
        ),
        Expanded(
          child: Container(
            color: kPrimaryColor,
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
              children: [
                OpcionesFiltroLC(size: size),
                SizedBox(height: size.height * 0.03),
                OptionsSection(
                  title: 'Acciones de Comunicado',
                  size: size,
                  children: [
                    authBloc.state.authStatus == AuthStatus.profesor
                        ? StyledOptionButton(
                            text: 'Crear',
                            icon: Icons.add_rounded,
                            size: size,
                            onTap: () => context.push("/create-comunicado"),
                          )
                        : const SizedBox(),
                    StyledOptionButton(
                      text: 'Actualizar',
                      icon: Icons.refresh_rounded,
                      size: size,
                      onTap: () => authBloc
                          .add(const OnChangedComunicadoDe(ComunicadoDe.todos)),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.03),
                OptionsSection(
                  title: 'Opciones de Usuario',
                  size: size,
                  children: [
                    StyledOptionButton(
                      text: 'Perfil',
                      icon: Icons.person_outline_rounded,
                      size: size,
                      onTap: () {},
                    ),
                    StyledOptionButton(
                      text: 'Salir',
                      icon: Icons.logout_rounded,
                      size: size,
                      onTap: () {
                        authBloc.add(const OnCerrarSesion());
                        context.go("/");
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// opciones_filtro_lc.dart
class OpcionesFiltroLC extends StatelessWidget {
  final Size size;

  const OpcionesFiltroLC({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context, listen: true);
    final bool todos = authBloc.state.comunicadoDe == ComunicadoDe.todos;

    if (authBloc.state.authStatus == AuthStatus.profesor) {
      final bool enviadoProfesor =
          authBloc.state.comunicadoDe == ComunicadoDe.enviadoProfesor;
      final bool recibidoProfesor =
          authBloc.state.comunicadoDe == ComunicadoDe.recibidoProfesor;

      return OptionsSection(
        title: 'Filtrar Por',
        size: size,
        children: [
          StyledOptionButton(
            text: 'Enviados',
            icon: Icons.send_rounded,
            isSelected: enviadoProfesor,
            size: size,
            onTap: () => authBloc
                .add(const OnChangedComunicadoDe(ComunicadoDe.enviadoProfesor)),
          ),
          StyledOptionButton(
            text: 'Recibidos',
            icon: Icons.move_to_inbox_rounded,
            isSelected: recibidoProfesor,
            size: size,
            onTap: () => authBloc.add(
                const OnChangedComunicadoDe(ComunicadoDe.recibidoProfesor)),
          ),
          StyledOptionButton(
            text: 'Todos',
            icon: Icons.all_inbox_rounded,
            isSelected: todos,
            size: size,
            onTap: () =>
                authBloc.add(const OnChangedComunicadoDe(ComunicadoDe.todos)),
          ),
        ],
      );
    }

    if (authBloc.state.authStatus == AuthStatus.apoderado) {
      final bool direccionApoderado =
          authBloc.state.comunicadoDe == ComunicadoDe.direccionApoderado;
      final bool parientesApoderado =
          authBloc.state.comunicadoDe == ComunicadoDe.parientesApoderado;

      return OptionsSection(
        title: 'Filtrar Por',
        size: size,
        children: [
          StyledOptionButton(
            text: 'Dir. Escolar',
            icon: Icons.school_rounded,
            isSelected: direccionApoderado,
            size: size,
            onTap: () => authBloc.add(
                const OnChangedComunicadoDe(ComunicadoDe.direccionApoderado)),
          ),
          StyledOptionButton(
            text: 'Estudiantes',
            icon: Icons.people_rounded,
            isSelected: parientesApoderado,
            size: size,
            onTap: () => authBloc.add(
                const OnChangedComunicadoDe(ComunicadoDe.parientesApoderado)),
          ),
          StyledOptionButton(
            text: 'Todos',
            icon: Icons.all_inbox_rounded,
            isSelected: todos,
            size: size,
            onTap: () =>
                authBloc.add(const OnChangedComunicadoDe(ComunicadoDe.todos)),
          ),
        ],
      );
    }

    if (authBloc.state.authStatus == AuthStatus.estudiante) {
      final bool direccionEstudiante =
          authBloc.state.comunicadoDe == ComunicadoDe.direccionEstudiante;
      final bool materiasEstudiante =
          authBloc.state.comunicadoDe == ComunicadoDe.materiasEstudiante;

      return OptionsSection(
        title: 'Filtrar Por',
        size: size,
        children: [
          StyledOptionButton(
            text: 'Dir. Escolar',
            icon: Icons.school_rounded,
            isSelected: direccionEstudiante,
            size: size,
            onTap: () => authBloc.add(
                const OnChangedComunicadoDe(ComunicadoDe.direccionEstudiante)),
          ),
          StyledOptionButton(
            text: 'Materias',
            icon: Icons.book_rounded,
            isSelected: materiasEstudiante,
            size: size,
            onTap: () {
              authBloc.add(
                  const OnChangedComunicadoDe(ComunicadoDe.materiasEstudiante));
            },
          ),
          StyledOptionButton(
            text: 'Todos',
            icon: Icons.all_inbox_rounded,
            isSelected: todos,
            size: size,
            onTap: () =>
                authBloc.add(const OnChangedComunicadoDe(ComunicadoDe.todos)),
          ),
        ],
      );
    }

    return const SizedBox();
  }
}
