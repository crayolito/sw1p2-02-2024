// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sw1p2_mobil/config/constant/paletaColores.const.dart';
import 'package:sw1p2_mobil/config/services/ia.service.dart';
import 'package:sw1p2_mobil/config/singleton/estilos.singleton.dart';
import 'package:sw1p2_mobil/features/auth/domain/entities/ia-preguntas.entitie.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class IAProfesorScreen extends StatefulWidget {
  const IAProfesorScreen({super.key});

  @override
  State<IAProfesorScreen> createState() => _IAProfesorScreenState();
}

class _IAProfesorScreenState extends State<IAProfesorScreen> {
  bool _isLoading = false;
  String pdfText = '';
  final PageController _controladorPagina = PageController();
  int paginaActual = 0;
  // Modificamos para que siempre tenga la respuesta correcta seleccionada
  // late int respuestaSeleccionada;
  String? respuestaSeleccionada;
  List<IAPregunta> preguntasIA = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // respuestaSeleccionada = datosPreguntas[0]['respuestaCorrecta'];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final estilos = EstilosSingleton.instance.estilos;

    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Stack(
        children: [
          Positioned(
            top: size.height * 0.31,
            left: size.width * 0.025,
            right: size.width * 0.025,
            child: SizedBox(
              width: size.width,
              height: size.height * 0.69,
              child: preguntasIA.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/subirPDF.png',
                            width: size.width * 0.4,
                            fit: BoxFit.contain,
                          ),
                          Text(
                            'Sube un programa analítico para generar preguntas',
                            style: estilos.letra2IAProfesor,
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        // LOGIC : BARRA DE PROGRESO
                        FadeIn(
                          duration: const Duration(milliseconds: 500),
                          child: Container(
                            margin: EdgeInsets.only(bottom: size.height * 0.02),
                            width: double.infinity,
                            height: size.height * 0.008,
                            decoration: BoxDecoration(
                              color: kSecondaryColor.withOpacity(0.3),
                              borderRadius:
                                  BorderRadius.circular(size.width * 0.04),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor:
                                  (paginaActual + 1) / preguntasIA.length,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: kTerciaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // LOGIC : PREGUNTAS Y RESPUESTAS
                        Expanded(
                          child: PageView.builder(
                            controller: _controladorPagina,
                            physics: const PageScrollPhysics(),
                            onPageChanged: (index) {
                              setState(() {
                                paginaActual = index;
                                respuestaSeleccionada =
                                    preguntasIA[index].correctAnswer;
                              });
                            },
                            itemCount: preguntasIA.length,
                            itemBuilder: (context, index) {
                              final pregunta = preguntasIA[index];
                              final opciones = [
                                pregunta.options.a,
                                pregunta.options.b,
                                pregunta.options.c,
                                pregunta.options.d,
                              ];

                              return SingleChildScrollView(
                                child: FadeInUp(
                                  duration: const Duration(milliseconds: 600),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SlideInLeft(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: size.width * 0.04,
                                            vertical: size.height * 0.008,
                                          ),
                                          decoration: BoxDecoration(
                                            color: kSecondaryColor
                                                .withOpacity(0.5),
                                            borderRadius: BorderRadius.circular(
                                                size.width * 0.015),
                                          ),
                                          child: Text(
                                            'Pregunta ${index + 1}',
                                            style: estilos.letra1IAProfesor,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: size.height * 0.015),
                                      FadeIn(
                                        delay:
                                            const Duration(milliseconds: 200),
                                        duration:
                                            const Duration(milliseconds: 500),
                                        child: Text(
                                          pregunta.question,
                                          style: estilos.letra2IAProfesor,
                                        ),
                                      ),
                                      SizedBox(height: size.height * 0.017),
                                      ...List.generate(
                                        4,
                                        (respIndex) => FadeInLeft(
                                          delay: Duration(
                                              milliseconds: 100 * respIndex),
                                          duration:
                                              const Duration(milliseconds: 400),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom: size.height * 0.016),
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  respuestaSeleccionada =
                                                      String.fromCharCode(
                                                          97 + respIndex);
                                                });
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.all(
                                                    size.width * 0.04),
                                                decoration: BoxDecoration(
                                                  color: respuestaSeleccionada ==
                                                          String.fromCharCode(
                                                              97 + respIndex)
                                                      ? kSecondaryColor
                                                          .withOpacity(0.3)
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: respuestaSeleccionada ==
                                                            String.fromCharCode(
                                                                97 + respIndex)
                                                        ? kTerciaryColor
                                                        : kSecondaryColor,
                                                    width: size.width * 0.005,
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: size.width * 0.07,
                                                      height: size.width * 0.07,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: respuestaSeleccionada ==
                                                                String.fromCharCode(
                                                                    97 +
                                                                        respIndex)
                                                            ? kTerciaryColor
                                                            : Colors
                                                                .transparent,
                                                        border: Border.all(
                                                          color: respuestaSeleccionada ==
                                                                  String.fromCharCode(97 +
                                                                      respIndex)
                                                              ? kTerciaryColor
                                                              : kSecondaryColor,
                                                          width: size.width *
                                                              0.005,
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          String.fromCharCode(
                                                              65 + respIndex),
                                                          style: GoogleFonts
                                                              .rajdhani(
                                                            color: respuestaSeleccionada ==
                                                                    String.fromCharCode(97 +
                                                                        respIndex)
                                                                ? Colors.white
                                                                : kTerciaryColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                size.width *
                                                                    0.04,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            size.width * 0.03),
                                                    Expanded(
                                                      child: Text(
                                                        opciones[respIndex],
                                                        style: estilos
                                                            .letra3IAProfesor,
                                                      ),
                                                    ),
                                                  ],
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
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (paginaActual > 0)
                                BounceInLeft(
                                  duration: const Duration(milliseconds: 400),
                                  child: TextButton.icon(
                                    onPressed: paginaActual > 0
                                        ? () {
                                            _controladorPagina.previousPage(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeInOut,
                                            );
                                          }
                                        : null,
                                    icon: const Icon(Icons.arrow_back,
                                        color: kTerciaryColor),
                                    label: Text(
                                      'Atrás',
                                      style: estilos.letra3IAProfesor,
                                    ),
                                  ),
                                )
                              else
                                SizedBox(width: size.width * 0.2),
                              FadeIn(
                                child: Text(
                                  '${paginaActual + 1} de ${preguntasIA.length}',
                                  style: estilos.letra3IAProfesor,
                                ),
                              ),
                              if (paginaActual < preguntasIA.length - 1)
                                BounceInRight(
                                  duration: const Duration(milliseconds: 400),
                                  child: TextButton.icon(
                                    onPressed: respuestaSeleccionada != null
                                        ? () {
                                            _controladorPagina.nextPage(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeInOut,
                                            );
                                          }
                                        : null,
                                    label: Text(
                                      'Siguiente',
                                      style: estilos.letra3IAProfesor,
                                    ),
                                    icon: Icon(
                                      Icons.arrow_forward,
                                      color: respuestaSeleccionada != null
                                          ? kTerciaryColor
                                          : kTerciaryColor.withOpacity(0.5),
                                    ),
                                  ),
                                )
                              else
                                SizedBox(width: size.width * 0.2),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: FadeInDown(
              duration: const Duration(milliseconds: 800),
              child: Container(
                width: size.width,
                height: size.height * 0.3,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: const NetworkImage(
                          'https://i.pinimg.com/564x/37/b0/03/37b003811276655d429e53d17c2c6b05.jpg'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.45),
                        BlendMode.darken,
                      ),
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(size.width * 0.08),
                      bottomRight: Radius.circular(size.width * 0.08),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 5,
                        offset: Offset(0, 5),
                      ),
                    ]),
                child: Stack(
                  children: [
                    Positioned(
                      top: size.height * 0.07,
                      left: size.width * 0.05,
                      child: Text(
                        'EDUFORWARD',
                        style: estilos.tituloIAProfesor,
                      ),
                    ),
                    Positioned(
                      top: size.height * 0.15,
                      left: size.width * 0.05,
                      child: Text(
                        'Potencia tu Enseñanza\nReinventa el Aprendizaje',
                        style: estilos.titulo2IAProfesor,
                      ),
                    ),
                    Positioned(
                        top: size.height * 0.07,
                        left: size.width * 0.78,
                        child: Container(
                          alignment: Alignment.center,
                          width: size.width * 0.2,
                          height: size.height * 0.15,
                          // color: Colors.red,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.arrow_back_ios,
                                    size: size.width * 0.08),
                                color: Colors.white,
                              ),
                              IconButton(
                                onPressed: () async {
                                  setState(() {
                                    paginaActual = 0;
                                    respuestaSeleccionada =
                                        preguntasIA.isNotEmpty
                                            ? preguntasIA[0].correctAnswer
                                            : '';
                                    _isLoading = false;
                                  });

                                  try {
                                    // Primero seleccionar el PDF
                                    bool pdfSelected =
                                        await pickAndExtractPDF();

                                    // Si no se seleccionó PDF, terminar aquí sin mostrar diálogo
                                    if (!pdfSelected || pdfText.isEmpty) {
                                      return;
                                    }

                                    // Solo mostrar diálogo si se seleccionó un PDF válido
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    _mostrarDialogoCarga(context, size);

                                    // Procesar con IA
                                    String resultado = await OpenIAService()
                                        .generateQuestions(pdfText);
                                    Map<String, dynamic> jsonResponse =
                                        jsonDecode(resultado);
                                    IAPreguntasResponse response =
                                        IAPreguntasResponse.fromJson(
                                            jsonResponse);

                                    setState(() {
                                      preguntasIA = response.questions;
                                      respuestaSeleccionada =
                                          preguntasIA[0].correctAnswer;
                                      paginaActual = 0;
                                      _isLoading = false;
                                      pdfText = '';
                                    });

                                    // Solo cerrar el diálogo si se mostró
                                    Navigator.of(context).pop();
                                  } catch (e) {
                                    // Si hubo un error y el diálogo está mostrado, cerrarlo
                                    if (_isLoading) {
                                      Navigator.of(context).pop();
                                    }

                                    setState(() {
                                      _isLoading = false;
                                      pdfText = '';
                                    });

                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Error al procesar el archivo'),
                                          backgroundColor: kCuartoColor,
                                        ),
                                      );
                                    }
                                  }
                                },
                                icon: Icon(FontAwesomeIcons.filePdf,
                                    size: size.width * 0.08),
                                color: Colors.white,
                              )
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> pickAndExtractPDF() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      // Si el usuario canceló la selección, retornamos false sin hacer nada más
      if (result == null || result.files.single.path == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No se seleccionó ningún archivo PDF'),
              backgroundColor: kCuartoColor,
            ),
          );
        }
        return false; // Indicamos que no se seleccionó archivo
      }

      // Procesar el PDF seleccionado
      final File file = File(result.files.single.path!);
      final PdfDocument document =
          PdfDocument(inputBytes: await file.readAsBytes());

      // Extraer el texto del PDF
      String text = '';
      for (int i = 0; i < document.pages.count; i++) {
        text += PdfTextExtractor(document).extractText(startPageIndex: i);
      }

      // Actualizar el estado con el texto extraído
      setState(() {
        pdfText = text;
      });

      // Liberar recursos
      document.dispose();
      return true; // Indicamos que se procesó correctamente
    } catch (e) {
      print('Error al extraer texto del PDF: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al procesar el archivo PDF'),
            backgroundColor: kCuartoColor,
          ),
        );
      }
      return false; // Indicamos que hubo un error
    }
  }

  void _mostrarDialogoCarga(BuildContext context, Size size) {
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
                  "Procesando documento...",
                  style: TextStyle(
                    fontSize: size.width * 0.045,
                    fontWeight: FontWeight.bold,
                    color: kCuartoColor,
                  ),
                ),
                SizedBox(height: size.width * 0.02),
                Text(
                  "Por favor espere mientras analizamos su PDF",
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

  @override
  void dispose() {
    _controladorPagina.dispose();
    super.dispose();
  }
}
