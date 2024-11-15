import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sw1p2_mobil/config/bloc/auth/auth_bloc.dart';
import 'package:sw1p2_mobil/config/constant/paletaColores.const.dart';
import 'package:sw1p2_mobil/config/singleton/estilos.singleton.dart';
import 'package:sw1p2_mobil/features/auth/domain/entities/cnotificacion.entitie.dart';

class ViewComunicadoScreen extends StatelessWidget {
  const ViewComunicadoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final estilos = EstilosSingleton.instance.estilos;
    final authBloc = BlocProvider.of<AuthBloc>(context, listen: true);
    CNotificacion notificacion = authBloc.state.notificacion!;
    return Scaffold(
      backgroundColor: kCuartoColor,
      body: Stack(
        children: [
          Positioned(
            top: size.height * 0.04,
            left: size.width * 0.03,
            right: size.width * 0.03,
            child: Container(
              alignment: Alignment.center,
              width: size.width,
              height: size.height * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size.width * 0.03),
                boxShadow: const [
                  BoxShadow(
                    color: kSecondaryColor,
                    offset: Offset(0, 2),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ],
                image: DecorationImage(
                    image: NetworkImage(notificacion.imagen),
                    fit: BoxFit.cover),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: size.width * 0.005,
                    left: size.width * 0.005,
                    top: 0,
                    child: SizedBox(
                      width: size.width,
                      height: size.height * 0.07,
                      // color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () {
                                authBloc.add(const OnResetComunicado());
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: kCuartoColor.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: Container(
                                  height: size.width * 0.09,
                                  margin: EdgeInsets.symmetric(
                                      vertical: size.width * 0.025),
                                  decoration: const BoxDecoration(
                                    color: kCuartoColor,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.03,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                          GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      backgroundColor: Colors.transparent,
                                      child: Container(
                                        width: size.width * 0.85,
                                        height: size.height * 0.6,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  kCuartoColor.withOpacity(0.1),
                                              blurRadius: 10,
                                              offset: const Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            // Encabezado
                                            Container(
                                              height: size.height * 0.08,
                                              decoration: BoxDecoration(
                                                color: kCuartoColor,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight: Radius.circular(20),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Estado de Lectura',
                                                  style: TextStyle(
                                                    color: kPrimaryColor,
                                                    fontSize:
                                                        size.width * 0.045,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // Lista de receptores
                                            Expanded(
                                              child: ListView.separated(
                                                padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        size.height * 0.02),
                                                itemCount: notificacion
                                                    .receptores.length,
                                                separatorBuilder:
                                                    (context, index) => Divider(
                                                  color: kTerciaryColor
                                                      .withOpacity(0.1),
                                                  height: 1,
                                                ),
                                                itemBuilder: (context, index) {
                                                  final receptor = notificacion
                                                      .receptores[index];
                                                  return Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal:
                                                          size.width * 0.04,
                                                      vertical:
                                                          size.height * 0.015,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        // Estado de lectura
                                                        Container(
                                                          width:
                                                              size.width * 0.02,
                                                          height: size.height *
                                                              0.04,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: receptor
                                                                    .visto
                                                                ? kSecondaryColor
                                                                : kTerciaryColor
                                                                    .withOpacity(
                                                                        0.2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            width: size.width *
                                                                0.03),

                                                        // Información del receptor
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              // Nombre
                                                              Text(
                                                                receptor
                                                                    .nombreCompleto,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      size.width *
                                                                          0.042,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color:
                                                                      kCuartoColor,
                                                                  letterSpacing:
                                                                      0.2,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: size
                                                                          .height *
                                                                      0.004),

                                                              // Fecha de lectura
                                                              Text(
                                                                receptor.visto
                                                                    ? 'Leído el ${receptor.fechaVisto}'
                                                                    : 'No leído aún',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      size.width *
                                                                          0.035,
                                                                  color: receptor
                                                                          .visto
                                                                      ? kTerciaryColor
                                                                      : kTerciaryColor
                                                                          .withOpacity(
                                                                              0.6),
                                                                  letterSpacing:
                                                                      0.1,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        // Indicador de estado
                                                        Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  size.width *
                                                                      0.02),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: receptor
                                                                    .visto
                                                                ? kSecondaryColor
                                                                    .withOpacity(
                                                                        0.2)
                                                                : kTerciaryColor
                                                                    .withOpacity(
                                                                        0.1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Icon(
                                                            receptor.visto
                                                                ? Icons
                                                                    .check_circle
                                                                : Icons
                                                                    .access_time,
                                                            color: receptor
                                                                    .visto
                                                                ? kSecondaryColor
                                                                : kTerciaryColor,
                                                            size: size.width *
                                                                0.05,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),

                                            // Botón cerrar
                                            Padding(
                                              padding: EdgeInsets.all(
                                                  size.width * 0.04),
                                              child: GestureDetector(
                                                onTap: () =>
                                                    Navigator.pop(context),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        size.height * 0.015,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: kCuartoColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: kCuartoColor
                                                            .withOpacity(0.2),
                                                        blurRadius: 8,
                                                        offset:
                                                            const Offset(0, 4),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'Cerrar',
                                                      style: TextStyle(
                                                        color: kPrimaryColor,
                                                        fontSize:
                                                            size.width * 0.04,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        letterSpacing: 0.5,
                                                      ),
                                                    ),
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
                              },
                              child: notificacion.receptores.isEmpty
                                  ? Container()
                                  : Container(
                                      decoration: BoxDecoration(
                                        color: kCuartoColor.withOpacity(0.5),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Container(
                                        height: size.width * 0.09,
                                        margin: EdgeInsets.symmetric(
                                            vertical: size.width * 0.025),
                                        decoration: const BoxDecoration(
                                          color: kCuartoColor,
                                          shape: BoxShape.circle,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: size.width * 0.03,
                                        ),
                                        child: const Icon(
                                          Icons.people_alt,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              top: size.height * 0.555,
              left: size.width * 0.02,
              right: size.width * 0.02,
              child: Container(
                width: size.width,
                height: size.height * 0.45,
                // color: Colors.red,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Comunicado",
                      style: estilos.tituloViewComunicado,
                    ),
                    SizedBox(
                      height: size.height * 0.015,
                    ),
                    SizedBox(
                      width: size.width,
                      child: Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.1,
                            child: Icon(
                              Icons.category,
                              color: kPrimaryColor,
                              size: size.width * 0.07,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: size.width * 0.01,
                            ),
                            width: size.width * 0.86,
                            child: Text(
                              notificacion.titulo,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: estilos.letra1ViewComunicado,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.012,
                    ),
                    SizedBox(
                      width: size.width,
                      child: Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.1,
                            child: Icon(
                              Icons.room,
                              color: kPrimaryColor,
                              size: size.width * 0.07,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: size.width * 0.01,
                            ),
                            width: size.width * 0.86,
                            child: Text(
                              notificacion.donde,
                              maxLines: 2,
                              style: estilos.letra1ViewComunicado,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.012,
                    ),
                    SizedBox(
                      width: size.width,
                      child: Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.1,
                            child: Icon(
                              Icons.date_range,
                              color: kPrimaryColor,
                              size: size.width * 0.07,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: size.width * 0.01,
                            ),
                            width: size.width * 0.86,
                            child: Text(
                              notificacion.cuando,
                              maxLines: 2,
                              style: estilos.letra1ViewComunicado,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.012,
                    ),
                    SizedBox(
                      width: size.width,
                      child: Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.1,
                            child: Icon(
                              Icons.assignment,
                              color: kPrimaryColor,
                              size: size.width * 0.07,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: size.width * 0.01,
                            ),
                            width: size.width * 0.86,
                            child: Text(
                              notificacion.motivo,
                              maxLines: 3,
                              style: estilos.letra1ViewComunicado,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.012,
                    ),
                    SizedBox(
                      width: size.width,
                      child: Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.1,
                            child: Icon(
                              Icons.co_present,
                              color: kPrimaryColor,
                              size: size.width * 0.07,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: size.width * 0.01,
                            ),
                            width: size.width * 0.86,
                            child: Text(
                              "U.E. Nacional Florida\nEducando con excelencia y valores  desde 1985",
                              maxLines: 2,
                              style: estilos.letra1ViewComunicado,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
