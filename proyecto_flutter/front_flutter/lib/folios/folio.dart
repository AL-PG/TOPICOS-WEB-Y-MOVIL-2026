enum PrioridadFolio { baja, media, alta, critica }

extension PrioridadFolioEtiqueta on PrioridadFolio {
  String get etiqueta => switch (this) {
    PrioridadFolio.baja => 'Baja',
    PrioridadFolio.media => 'Media',
    PrioridadFolio.alta => 'Alta',
    PrioridadFolio.critica => 'Crítica',
  };
}

enum DiagnosticoFolio { basico, intermedio, avanzado }

extension DiagnosticoFolioEtiqueta on DiagnosticoFolio {
  String get etiqueta => switch (this) {
    DiagnosticoFolio.basico => 'Básico',
    DiagnosticoFolio.intermedio => 'Intermedio',
    DiagnosticoFolio.avanzado => 'Avanzado',
  };
}

class Folio {
  const Folio({
    required this.folio,
    required this.equipo,
    required this.descripcion,
    required this.fecha,
    required this.prioridad,
    required this.diagnostico,
  });

  final String folio;
  final String equipo;
  final String descripcion;
  final DateTime fecha;
  final PrioridadFolio prioridad;
  final DiagnosticoFolio diagnostico;
}
