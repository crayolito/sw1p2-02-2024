import 'package:flutter/material.dart';
import 'package:sw1p2_mobil/config/singleton/estilos.singleton.dart';
import 'package:sw1p2_mobil/features/auth/presentation/widgets/formulario.widget.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final estilos = EstilosSingleton.instance.estilos;

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: size.height * 0.75,
                  width: size.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://i.pinimg.com/564x/63/90/e9/6390e91e2387fd44623deed545890cb2.jpg"),
                        fit: BoxFit.cover),
                  ),
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                  )),
                ),
                const ContainerCustom(),
                Positioned(
                    top: size.height * 0.07,
                    child: Container(
                      alignment: Alignment.center,
                      width: size.width,
                      height: size.height * 0.1,
                      child: Text("EDUFORWARD", style: estilos.tituloHome),
                    )),
                Positioned(
                  top: size.height * 0.175,
                  child: Container(
                    alignment: Alignment.center,
                    width: size.width,
                    height: size.height * 0.1,
                    child: Text(
                      "Donde la Educación Fluye\nEl Conocimiento Crece",
                      style: estilos.titulo2Home,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Positioned(
                    top: size.height * 0.31,
                    left: size.width * 0.1,
                    right: size.width * 0.1,
                    child: const FormularioAuth())
              ],
            ),
          ),
        ));
  }
}

class ContainerCustom extends StatelessWidget {
  const ContainerCustom({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
        width: size.width,
        height: size.height,
        child: CustomPaint(
          painter: _CurvoContainer(),
        ));
  }
}

class _CurvoContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final lapiz = Paint();

    // Configuración base
    lapiz.color = Colors.white;
    lapiz.style = PaintingStyle.fill;
    lapiz.strokeWidth = 20;

    // // Shader modificado con más control sobre el degradado
    // lapiz.shader = LinearGradient(
    //   begin: Alignment.topCenter,
    //   end: Alignment.bottomCenter,
    //   stops: const [0.0, 0.5, 1.0], // Puntos de control del degradado
    //   colors: [
    //     Colors.black.withOpacity(0.7), // Negro más suave arriba
    //     Colors.grey.withOpacity(0.3), // Gris en el medio
    //     Colors.white, // Blanco abajo
    //   ],
    // ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();

    // Curva ajustada más profunda y simétrica
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.65);
    path.quadraticBezierTo(
        size.width * 0.5, // Punto de control X en el centro
        size.height *
            0.82, // Punto de control Y más abajo para mayor profundidad
        size.width, // Punto final X
        size.height * 0.65 // Punto final Y
        );
    path.lineTo(size.width, size.height);

    canvas.drawPath(path, lapiz);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
