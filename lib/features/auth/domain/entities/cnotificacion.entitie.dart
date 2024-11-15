class CNotificacion {
  final int id;
  final String titulo;
  final String donde;
  final String cuando;
  final String motivo;
  final String imagen;
  final String extra;
  final bool profesorCreador;
  final List<Receptores> receptores;

  CNotificacion({
    required this.id,
    required this.titulo,
    required this.donde,
    required this.cuando,
    required this.motivo,
    required this.imagen,
    required this.extra,
    required this.profesorCreador,
    required this.receptores,
  });

  // Constructor factory para crear una instancia vacía
  factory CNotificacion.empty() {
    return CNotificacion(
      id: 0,
      titulo: '',
      donde: 'Sin ubicación',
      cuando: 'Sin fecha',
      motivo: 'Sin motivo',
      imagen:
          'https://i.pinimg.com/736x/d7/22/ee/d722ee6ba2b397b53eb5bdb53f3471d9.jpg',
      extra: '',
      profesorCreador: false,
      receptores: [],
    );
  }
}

class Receptores {
  final int id;
  final String nombreCompleto;
  final String ci;
  final String numeroMatricula;
  final bool visto;
  final String fechaVisto;

  Receptores(
      {required this.id,
      required this.nombreCompleto,
      required this.ci,
      required this.numeroMatricula,
      required this.visto,
      required this.fechaVisto});
}
