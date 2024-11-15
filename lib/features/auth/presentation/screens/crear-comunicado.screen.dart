import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sw1p2_mobil/config/bloc/auth/auth_bloc.dart';
import 'package:sw1p2_mobil/config/constant/paletaColores.const.dart';
import 'package:sw1p2_mobil/config/singleton/estilos.singleton.dart';
import 'package:sw1p2_mobil/features/auth/domain/entities/profesor.entitie.dart';
import 'package:sw1p2_mobil/features/auth/infrastructure/repositories/auth.repositorie.dart';
import 'package:sw1p2_mobil/features/auth/presentation/widgets/formulario.widget.dart';

class CrearComunicadoScreen extends StatefulWidget {
  const CrearComunicadoScreen({super.key});

  @override
  State<CrearComunicadoScreen> createState() => _CrearComunicadoScreenState();
}

class _CrearComunicadoScreenState extends State<CrearComunicadoScreen> {
  String? _titulo;
  String? _donde;
  String? _motivo;
  DateTime? _cuando;
  Horario? _horario;
  List<String> options = [
    'Rendimiento académico',
    'Comportamiento del alumno',
    'Citación a apoderados',
    'Tareas y evaluaciones',
    'Felicitacioness'
  ];
  List<Horario> horarios = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final authBloc = BlocProvider.of<AuthBloc>(context);
    setState(() {
      horarios = authBloc.state.profesor!.horarios;
    });
  }

  // List<Horario> cursos = [
  //   // Primer Año
  //   '1ro A - Matemáticas',
  //   '1ro B - Matemáticas',
  //   '1ro B - Lenguaje',

  //   // Segundo Año
  //   '2do A - Álgebra',
  //   '2do B - Literatura',

  //   // Tercer Año
  //   '3ro A - Geometría',
  //   '3ro B - Geometría',
  //   '3ro B - Historia',

  //   // Cuarto Año
  //   '4to A - Física',
  //   '4to B - Química',
  //   '4to C - Química',

  //   // Quinto Año
  //   '5to A - Filosofía',
  //   '5to B - Filosofía',
  //   '5to C - Filosofía',
  //   '5to C - Economía',
  // ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final estilos = EstilosSingleton.instance.estilos;
    final authRepositoryImpl = AuthRepositoryImpl();
    final authBloc = BlocProvider.of<AuthBloc>(context);
    const decoration2 = BoxDecoration(
      image: DecorationImage(
          image: AssetImage("assets/logo.png"), fit: BoxFit.cover),
    );
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              // Fondo con opacidad
              Container(
                width: size.width,
                height: size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://i.pinimg.com/736x/b3/90/29/b390294d6b3a08fecc32888a5082d856.jpg"),
                      fit: BoxFit.cover),
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
              // Formulario
              Positioned(
                  top: size.height * 0.25,
                  right: size.width * 0.05,
                  left: size.width * 0.05,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                      vertical: size.height * 0.02,
                    ),
                    alignment: Alignment.center,
                    width: size.width,
                    height: size.height * 0.6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(size.width * 0.03),
                      boxShadow: const [
                        BoxShadow(
                          color: kPrimaryColor, // Color de la sombra
                          offset: Offset(0, 2), // Desplazamiento (x,y)
                          blurRadius: 8, // Radio de desenfoque
                          spreadRadius: 0, // Radio de extensión
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: size.width * 0.2,
                          height: size.height * 0.1,
                          decoration: decoration2,
                        ),
                        SelectorOptions(
                            options: options,
                            icon: Icons.category,
                            onChanged: (value) =>
                                setState(() => _titulo = value),
                            textPlaceholder: "Tipo de comunicado"),
                        TextFormFieldCustom(
                            onChanged: (value) =>
                                setState(() => _donde = value),
                            textPlaceholder: "Donde se realizará",
                            icon: Icons.room),
                        DateTimeFormFieldCustom(
                          textPlaceholder: 'Seleccione fecha y hora',
                          selectedDateTime: _cuando,
                          onDateTimeSelected: (dateTime) {
                            setState(() {
                              _cuando = dateTime;
                            });
                          },
                        ),
                        TextFormFieldCustom(
                            onChanged: (value) =>
                                setState(() => _motivo = value),
                            textPlaceholder: "Motivo del comunicado",
                            icon: Icons.notes),
                        SelectorOptions(
                            options: horarios
                                .map((e) =>
                                    '${e.grado.nombre} - ${e.materia.nombre}')
                                .toList(),
                            icon: Icons.groups,
                            onChanged: (value) => setState(() {
                                  _horario = horarios.firstWhere((element) =>
                                      '${element.grado.nombre} - ${element.materia.nombre}' ==
                                      value);
                                }),
                            textPlaceholder: "Curso - Materia"),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        GestureDetector(
                          onTap: () async {
                            try {
                              // Mostrar diálogo de carga
                              _mostrarDialogoProceso(context, size);

                              // Realizar la petición
                              await authRepositoryImpl.createComunicado(
                                  profesorId: authBloc.state.profesor!.id,
                                  horarioId: _horario!.id,
                                  titulo: getOptionKey(_titulo!),
                                  donde: _donde!,
                                  cuando: _cuando!.toString(),
                                  motivo: _motivo!);

                              // Cerrar diálogo de carga
                              Navigator.pop(context);

                              // Mostrar mensaje de éxito
                              _mostrarMensajeExito(context, size);
                            } catch (e) {
                              // Cerrar diálogo de carga
                              Navigator.pop(context);

                              // Mostrar error
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Error al enviar el comunicado'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: kCuartoColor,
                              borderRadius: BorderRadius.circular(
                                size.width * 0.025,
                              ),
                            ),
                            // Agregar padding dinámico
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width *
                                  0.028, // Padding horizontal 8% del ancho
                              vertical: size.height *
                                  0.013, // Padding vertical 1.5% del alto
                            ),
                            child: Text(
                              "Enviar Comunicado",
                              style: estilos.letraButton,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  String getOptionKey(String option) {
    final Map<String, String> keyMap = {
      'Rendimiento académico': 'rendimiento',
      'Comportamiento del alumno': 'comportamiento',
      'Citación a apoderados': 'citaciones',
      'Tareas y evaluaciones': 'tareas',
      'Felicitacioness': 'felicitaciones',
    };

    return keyMap[option] ?? '';
  }

  void _mostrarDialogoProceso(BuildContext context, Size size) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size.width * 0.03),
          ),
          content: Container(
            padding: EdgeInsets.symmetric(
              vertical: size.width * 0.05,
              horizontal: size.width * 0.03,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kCuartoColor),
                  strokeWidth: 3,
                ),
                SizedBox(height: size.width * 0.05),
                Text(
                  "Enviando comunicado...",
                  style: TextStyle(
                    fontSize: size.width * 0.045,
                    fontWeight: FontWeight.bold,
                    color: kCuartoColor,
                  ),
                ),
                SizedBox(height: size.width * 0.02),
                Text(
                  "Por favor espere mientras procesamos su solicitud",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size.width * 0.035,
                    color: kTerciaryColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _mostrarMensajeExito(BuildContext context, Size size) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size.width * 0.04),
          ),
          child: Container(
            padding: EdgeInsets.all(size.width * 0.04),
            width: size.width * 0.7, // Controla el ancho
            child: Column(
              mainAxisSize: MainAxisSize.min, // Para que se ajuste al contenido
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: kCuartoColor,
                  size: size.width * 0.12,
                ),
                SizedBox(height: size.width * 0.02),
                Text(
                  "¡Comunicado enviado!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: kCuartoColor,
                  ),
                ),
                SizedBox(height: size.width * 0.02),
                Text(
                  "Notificación enviada a todos los destinatarios",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size.width * 0.032,
                    color: kTerciaryColor,
                  ),
                ),
                SizedBox(height: size.width * 0.03),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    // Navigator.of(context).pop(); // Si quieres volver a la pantalla anterior
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: size.width * 0.02,
                      horizontal: size.width * 0.04,
                    ),
                    decoration: BoxDecoration(
                      color: kCuartoColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(size.width * 0.02),
                    ),
                    child: Text(
                      "Entendido",
                      style: TextStyle(
                        color: kCuartoColor,
                        fontSize: size.width * 0.035,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
