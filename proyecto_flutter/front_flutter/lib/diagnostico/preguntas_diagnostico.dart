import 'package:flutter/material.dart';

class PreguntaDiagnostico {
  const PreguntaDiagnostico({
    required this.id,
    required this.titulo,
    required this.opciones,
    this.ayuda,
    this.selector = false,
  });

  final String id;
  final String titulo;
  final Map<String, String> opciones;
  final String? ayuda;
  final bool selector;
}

class SeccionDiagnostico {
  const SeccionDiagnostico({
    required this.titulo,
    required this.icono,
    required this.preguntas,
  });

  final String titulo;
  final IconData icono;
  final List<PreguntaDiagnostico> preguntas;
}

const seccionesDiagnostico = <SeccionDiagnostico>[
  SeccionDiagnostico(
    titulo: 'Funcionamiento general',
    icono: Icons.power_settings_new_rounded,
    preguntas: [
      PreguntaDiagnostico(
        id: 'encendido',
        titulo: '¿El celular enciende?',
        opciones: {'si': 'Sí', 'no': 'No', 'intermitente': 'A veces'},
      ),
      PreguntaDiagnostico(
        id: 'reinicios_frecuentes',
        titulo: '¿Se reinicia con frecuencia?',
        opciones: {'si': 'Sí', 'no': 'No', 'no_evaluable': 'No evaluable'},
      ),
    ],
  ),
  SeccionDiagnostico(
    titulo: 'Pantalla y carga',
    icono: Icons.smartphone_rounded,
    preguntas: [
      PreguntaDiagnostico(
        id: 'estado_pantalla',
        titulo: '¿Cómo se ve la pantalla?',
        opciones: {
          'normal': 'Se ve con normalidad',
          'defectuosa': 'Tiene manchas, líneas o fallas',
          'sin_imagen': 'No muestra imagen',
          'no_evaluable': 'No se puede evaluar',
        },
        selector: true,
      ),
      PreguntaDiagnostico(
        id: 'respuesta_tactil',
        titulo: '¿Cómo responde la pantalla al tacto?',
        opciones: {
          'normal': 'Responde con normalidad',
          'parcial': 'Solo responde en algunas zonas',
          'no_responde': 'No responde al tacto',
          'no_evaluable': 'No se puede evaluar',
        },
        selector: true,
      ),
      PreguntaDiagnostico(
        id: 'estado_carga',
        titulo: '¿Cómo carga la batería?',
        opciones: {
          'normal': 'Carga con normalidad',
          'intermitente': 'Carga de forma intermitente',
          'no_carga': 'No carga',
          'no_evaluable': 'No se puede evaluar',
        },
        selector: true,
      ),
    ],
  ),
  SeccionDiagnostico(
    titulo: 'Historial y señales',
    icono: Icons.fact_check_outlined,
    preguntas: [
      PreguntaDiagnostico(
        id: 'golpe_reciente',
        titulo: '¿El celular recibió un golpe o una caída reciente?',
        opciones: {'si': 'Sí', 'no': 'No', 'no_sabe': 'No lo sé'},
      ),
      PreguntaDiagnostico(
        id: 'contacto_liquido',
        titulo: '¿Tuvo contacto con agua u otros líquidos?',
        opciones: {'si': 'Sí', 'no': 'No', 'no_sabe': 'No lo sé'},
      ),
      PreguntaDiagnostico(
        id: 'sobrecalentamiento',
        titulo: '¿Se calienta más de lo normal?',
        opciones: {'si': 'Sí', 'no': 'No', 'no_sabe': 'No lo sé'},
      ),
      PreguntaDiagnostico(
        id: 'bateria_hinchada',
        titulo: '¿La batería parece hinchada?',
        ayuda: 'Por ejemplo, la tapa o la pantalla se está levantando.',
        opciones: {'si': 'Sí', 'no': 'No', 'no_sabe': 'No lo sé'},
      ),
    ],
  ),
];
