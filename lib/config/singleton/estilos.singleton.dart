import 'package:flutter/widgets.dart';
import 'package:sw1p2_mobil/config/constant/styleText.const.dart';

class EstilosSingleton {
  static EstilosSingleton? _instance;
  late EstilosLetras estilos;

  // Constructor privado
  EstilosSingleton._();

  static void inicializar(BuildContext context) {
    _instance ??= EstilosSingleton._()..estilos = EstilosLetras(context);
  }

  // Getter estático para acceder a la instancia
  static EstilosSingleton get instance {
    if (_instance == null) {
      throw Exception(
          'EstilosSingleton no inicializado. Llamar a inicializar() primero.');
    }
    return _instance!;
  }
}
