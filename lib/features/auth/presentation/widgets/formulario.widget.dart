import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sw1p2_mobil/config/router/app.router.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sw1p2_mobil/config/bloc/auth/auth_bloc.dart';
import 'package:sw1p2_mobil/config/constant/paletaColores.const.dart';
import 'package:sw1p2_mobil/config/singleton/estilos.singleton.dart';

class FormularioAuth extends StatefulWidget {
  const FormularioAuth({
    super.key,
  });

  @override
  State<FormularioAuth> createState() => _FormularioAuthState();
}

class _FormularioAuthState extends State<FormularioAuth> {
  String _rol = "";
  String _carnet = "";
  String _matricula = "";
  String _token = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializePermissions();
  }

  Future<void> _initializePermissions() async {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    await authBloc.requestPermissions();
    final newToken = await authBloc.getFCMTokenProvisional();
    setState(() {
      _token = newToken ?? "No se pudo obtener el token";
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> roles = ['Profesor', 'Alumno', 'Apoderado'];
    final estilos = EstilosSingleton.instance.estilos;

    final authBloc = BlocProvider.of<AuthBloc>(context);
    final size = MediaQuery.of(context).size;
    final decoration1 = BoxDecoration(
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
      ],
    );
    const decoration2 = BoxDecoration(
      image: DecorationImage(
          image: AssetImage("assets/logo.png"), fit: BoxFit.cover),
    );

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.authStatus == AuthStatus.profesor ||
            state.authStatus == AuthStatus.estudiante ||
            state.authStatus == AuthStatus.apoderado) {
          context.go("/list-comunicados");
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05, vertical: size.height * 0.025),
        width: size.width * 0.8,
        height: size.height * 0.55,
        decoration: decoration1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: size.width * 0.2,
              height: size.height * 0.1,
              decoration: decoration2,
            ),
            TextFormFieldCustom(
              onChanged: (value) {
                setState(() {
                  _carnet = value;
                });
              },
              textPlaceholder: 'Carnet de identidad',
              icon: Icons.credit_card,
            ),
            TextFormFieldCustom(
              onChanged: (value) {
                setState(() {
                  _matricula = value;
                });
              },
              textPlaceholder: 'Nro. matrícula',
              icon: Icons.app_registration,
            ),
            SelectorOptions(
              icon: Icons.list_alt,
              onChanged: (value) {
                setState(() {
                  _rol = value!;
                });
              },
              options: roles,
              textPlaceholder: "Seleccione un Rol",
            ),
            SizedBox(
              width: size.width * 0.06,
            ),
            GestureDetector(
              onTap: () {
                authBloc.add(OnAuthUser(
                  context: context,
                  ci: _carnet,
                  matricula: _matricula,
                  rol: _rol,
                  token: _token,
                ));
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
                  horizontal:
                      size.width * 0.028, // Padding horizontal 8% del ancho
                  vertical:
                      size.height * 0.013, // Padding vertical 1.5% del alto
                ),
                child: Text(
                  "Inicio de sesión",
                  style: estilos.letraButton,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SelectorOptions extends StatelessWidget {
  const SelectorOptions({
    super.key,
    required this.options,
    required this.icon,
    required this.onChanged,
    required this.textPlaceholder,
  });

  final List<String> options;
  final ValueChanged<String?> onChanged;
  final String textPlaceholder;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final estilos = EstilosSingleton.instance.estilos;

    return DropdownButtonFormField<String>(
      style: estilos.letraInput,
      isDense: true,
      alignment: AlignmentDirectional.centerStart,
      menuMaxHeight: size.height * 0.2,
      isExpanded: true, // Asegura que use todo el ancho disponible
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          vertical: size.height * 0.015,
          horizontal: size.width * 0.02,
        ),
        hintText: textPlaceholder,
        hintStyle: estilos.placeholderInput,
        prefixIcon: Icon(icon),
        prefixIconColor: WidgetStateColor.resolveWith((states) =>
            states.contains(WidgetState.focused)
                ? kCuartoColor
                : kTerciaryColor),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: kCuartoColor, width: 2),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: kTerciaryColor, width: 1),
        ),
      ),
      items: options.map((String rol) {
        return DropdownMenuItem<String>(
          value: rol,
          child: Text(rol),
        );
      }).toList(),
      onChanged: onChanged,
      icon: Icon(
        Icons.arrow_drop_down,
        color: kTerciaryColor,
        size: size.width * 0.06,
      ),
      dropdownColor: Colors.white,
      elevation: 8,
      borderRadius: BorderRadius.circular(8),
    );
  }
}

class TextFormFieldCustom extends StatelessWidget {
  const TextFormFieldCustom({
    super.key,
    required this.onChanged,
    required this.textPlaceholder,
    required this.icon,
  });

  final ValueChanged<String> onChanged;
  final String textPlaceholder;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final estilos = EstilosSingleton.instance.estilos;

    final decoration = InputDecoration(
      // Placeholder y su estilo
      hintText: textPlaceholder,
      hintStyle: estilos.placeholderInput,
      // Icono y su color según estado
      prefixIcon: Icon(icon),
      prefixIconColor: WidgetStateColor.resolveWith((states) =>
          states.contains(WidgetState.focused) ? kCuartoColor : kTerciaryColor),

      // Borde inferior cuando está enfocado
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: kCuartoColor,
          width: 2,
        ),
      ),

      // Borde inferior cuando no está enfocado
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: kTerciaryColor,
          width: 1,
        ),
      ),

      // Color del label flotante
      floatingLabelStyle:
          WidgetStateTextStyle.resolveWith((states) => GoogleFonts.rajdhani(
                color: states.contains(WidgetState.focused)
                    ? kCuartoColor
                    : kTerciaryColor,
                fontSize: size.width * 0.04,
              )),
    );

    return TextFormField(
      onChanged: onChanged,
      style: estilos.letraInput,
      cursorColor: kCuartoColor,
      decoration: decoration,
    );
  }
}

class DateTimeFormFieldCustom extends StatelessWidget {
  const DateTimeFormFieldCustom({
    super.key,
    required this.onDateTimeSelected,
    required this.textPlaceholder,
    required this.selectedDateTime,
  });

  final Function(DateTime) onDateTimeSelected;
  final String textPlaceholder;
  final DateTime? selectedDateTime;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final estilos = EstilosSingleton.instance.estilos;

    final decoration = InputDecoration(
      hintText: textPlaceholder,
      hintStyle: estilos.placeholderInput,
      // prefixIcon: const Icon(Icons.calendar_today),
      prefixIconColor: WidgetStateColor.resolveWith((states) =>
          states.contains(WidgetState.focused) ? kCuartoColor : kTerciaryColor),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: kCuartoColor,
          width: 2,
        ),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: kTerciaryColor,
          width: 1,
        ),
      ),
      suffixIcon: IconButton(
        icon: const Icon(Icons.event),
        onPressed: () async {
          final fecha = await showDatePicker(
            context: context,
            initialDate: selectedDateTime ?? DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2025),
          );

          if (fecha != null) {
            final hora = await showTimePicker(
              context: context,
              initialTime:
                  TimeOfDay.fromDateTime(selectedDateTime ?? DateTime.now()),
            );

            if (hora != null) {
              onDateTimeSelected(DateTime(
                fecha.year,
                fecha.month,
                fecha.day,
                hora.hour,
                hora.minute,
              ));
            }
          }
        },
      ),
      floatingLabelStyle:
          WidgetStateTextStyle.resolveWith((states) => GoogleFonts.rajdhani(
                color: states.contains(WidgetState.focused)
                    ? kCuartoColor
                    : kTerciaryColor,
                fontSize: size.width * 0.04,
              )),
    );

    return TextFormField(
      readOnly: true,
      style: estilos.letraInput,
      cursorColor: kCuartoColor,
      decoration: decoration,
      controller: TextEditingController(
        text: selectedDateTime != null
            ? '${selectedDateTime!.day}/${selectedDateTime!.month}/${selectedDateTime!.year} ${selectedDateTime!.hour}:${selectedDateTime!.minute}'
            : '',
      ),
    );
  }
}
