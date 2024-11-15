// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:math' show pi;

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

class IAEstudianteScreen extends StatefulWidget {
  const IAEstudianteScreen({super.key});

  @override
  State<IAEstudianteScreen> createState() => _IAEstudianteScreenState();
}

class _IAEstudianteScreenState extends State<IAEstudianteScreen> {
  bool _isLoading = false;
  String pdfText = "";
  List<FlashCard> preguntasIA = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                        Expanded(
                          child: FlipCardsList(
                            preguntasIA: preguntasIA,
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
                                    _isLoading = false;
                                    pdfText = "";
                                  });

                                  try {
                                    // Primero seleccionar el PDF
                                    bool pdfSelected =
                                        await pickAndExtractPDF();

                                    // Si no se seleccionó PDF, terminar aquí sin mostrar diálogo
                                    if (!pdfSelected || pdfText.isEmpty) {
                                      return;
                                    }

                                    // Solo si tenemos texto del PDF procedemos con el proceso de IA
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    _mostrarDialogoCarga(context, size);

                                    // Procesar con IA
                                    String resultado = await OpenIAService()
                                        .generateFlashcards(pdfText);
                                    Map<String, dynamic> jsonResponse =
                                        jsonDecode(resultado);
                                    print(jsonResponse);
                                    FlashCardsResponse response =
                                        FlashCardsResponse.fromJson(
                                            jsonResponse);

                                    // Cerrar el diálogo incondicionalmente después del procesamiento exitoso
                                    Navigator.of(context).pop();

                                    // Actualizar el estado después de cerrar el diálogo
                                    setState(() {
                                      preguntasIA = response.flashcards;
                                      _isLoading = false;
                                      pdfText = '';
                                    });
                                  } catch (e) {
                                    // En caso de error, asegurarnos de cerrar el diálogo
                                    Navigator.of(context).pop();

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
    // _controladorPagina.dispose();
    super.dispose();
  }
}

class FlipCard extends StatefulWidget {
  final FlashCard pregunta;
  final int index;
  const FlipCard({super.key, required this.pregunta, required this.index});

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;
  bool _isFrontVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _flipAnimation = Tween<double>(
      begin: 0,
      end: pi,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutBack,
      ),
    );
  }

  void _toggleCard() {
    if (_isFrontVisible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _isFrontVisible = !_isFrontVisible;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(_flipAnimation.value),
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: _toggleCard,
            child: _flipAnimation.value < pi / 2
                ? _buildFrontCard(size)
                : Transform(
                    transform: Matrix4.identity()..rotateY(pi),
                    alignment: Alignment.center,
                    child: _buildBackCard(size),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildFrontCard(Size size) {
    return Container(
      width: size.width * 0.9,
      height: size.height * 0.35,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size.width * 0.03),
        boxShadow: [
          BoxShadow(
            color: kCuartoColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Barra lateral izquierda decorativa
          Container(
            width: 8,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  kCuartoColor,
                  Color.lerp(kCuartoColor, kTerciaryColor, 0.5) ?? kCuartoColor,
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size.width * 0.03),
                bottomLeft: Radius.circular(size.width * 0.03),
              ),
            ),
          ),
          // Contenido principal
          Expanded(
            child: Stack(
              children: [
                // Fondo decorativo
                Positioned(
                  right: -50,
                  top: -50,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kSecondaryColor.withOpacity(0.1),
                    ),
                  ),
                ),
                // Contenido
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: kCuartoColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              '#${widget.index + 1}',
                              style: GoogleFonts.rajdhani(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: kSecondaryColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  'PREGUNTA',
                                  style: GoogleFonts.rajdhani(
                                    color: kCuartoColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Línea decorativa
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              kSecondaryColor.withOpacity(0.3),
                              kSecondaryColor.withOpacity(0.1),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Contenido de la pregunta
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                        child: Stack(
                          children: [
                            SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Text(
                                widget.pregunta.question,
                                style: GoogleFonts.rajdhani(
                                  color: kCuartoColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                ),
                              ),
                            ),
                            // Indicador de scroll
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: kSecondaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.touch_app,
                                  color: kTerciaryColor,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackCard(Size size) {
    return Container(
      width: size.width * 0.9,
      height: size.height * 0.35,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            kCuartoColor,
            Color.lerp(kCuartoColor, kTerciaryColor, 0.3) ?? kCuartoColor,
          ],
        ),
        borderRadius: BorderRadius.circular(size.width * 0.03),
        boxShadow: [
          BoxShadow(
            color: kCuartoColor.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Elementos decorativos
          Positioned(
            left: -30,
            bottom: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          // Contenido
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: kSecondaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        '#${widget.index + 1}',
                        style: GoogleFonts.rajdhani(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: kSecondaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        'RESPUESTA',
                        style: GoogleFonts.rajdhani(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Línea decorativa
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.3),
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
              ),
              // Contenido de la respuesta
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Text(
                          widget.pregunta.answer,
                          style: GoogleFonts.rajdhani(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.touch_app,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FlipCardsList extends StatelessWidget {
  const FlipCardsList({super.key, required this.preguntasIA});

  final List<FlashCard> preguntasIA;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemCount: preguntasIA.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: FadeInLeft(
            duration: const Duration(milliseconds: 600),
            delay: Duration(milliseconds: 100 * index),
            child: FlipCard(
              pregunta: preguntasIA[index],
              index: index,
            ),
          ),
        );
      },
    );
  }
}
