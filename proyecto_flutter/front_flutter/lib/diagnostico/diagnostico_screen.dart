import 'package:flutter/material.dart';

import 'preguntas_diagnostico.dart';

const _tinta = Color(0xFF192D40);
const _gris = Color(0xFF627487);
const _verde = Color(0xFF137F75);
const _borde = Color(0xFFE1E8ED);

class DiagnosticoScreen extends StatefulWidget {
  const DiagnosticoScreen({super.key});

  @override
  State<DiagnosticoScreen> createState() => _DiagnosticoScreenState();
}

class _DiagnosticoScreenState extends State<DiagnosticoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreEquipoController = TextEditingController();
  final _respuestas = <String, String>{};
  final _campos = {
    for (final seccion in seccionesDiagnostico)
      for (final pregunta in seccion.preguntas) pregunta.id: GlobalKey(),
  };
  bool _mostrarErrores = false;

  @override
  void dispose() {
    _nombreEquipoController.dispose();
    super.dispose();
  }

  void _revisarFormulario() {
    setState(() => _mostrarErrores = true);
    if (!_formKey.currentState!.validate()) {
      final pendiente = _campos.keys.firstWhere(
        (id) => !_respuestas.containsKey(id),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        final campoContext = _campos[pendiente]?.currentContext;
        if (campoContext != null) {
          Scrollable.ensureVisible(
            campoContext,
            duration: const Duration(milliseconds: 300),
            alignment: 0.15,
          );
        }
      });
      return;
    }

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.task_alt_rounded, color: _verde, size: 40),
        title: const Text('Formulario listo'),
        content: const Text(
          'Completaste las 9 preguntas. Esta es una vista previa: el envío todavía no está habilitado.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Seguir editando'),
          ),
        ],
      ),
    );
  }

  void _limpiar() {
    _formKey.currentState!.reset();
    _nombreEquipoController.clear();
    setState(() {
      _respuestas.clear();
      _mostrarErrores = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnóstico', style: TextStyle(fontSize: 18)),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actions: [
          TextButton.icon(
            key: const Key('ver_folios'),
            onPressed: () => Navigator.pushNamed(context, '/folios'),
            icon: const Icon(Icons.format_list_bulleted_rounded, size: 20),
            label: const Text('Ver folios'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          key: const Key('diagnostico_scroll'),
          padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Form(
                key: _formKey,
                autovalidateMode: _mostrarErrores
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Nuevo diagnóstico',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: _borde),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: TextFormField(
                        key: const Key('nombre_equipo'),
                        controller: _nombreEquipoController,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Nombre del equipo',
                          hintText: 'Ej. Samsung Galaxy A54',
                          prefixIcon: Icon(
                            Icons.smartphone_rounded,
                            color: _gris,
                          ),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(height: 18),
                    for (final seccion in seccionesDiagnostico) ...[
                      _seccion(seccion),
                      const SizedBox(height: 18),
                    ],
                    FilledButton.icon(
                      key: const Key('enviar_formulario'),
                      onPressed: _revisarFormulario,
                      icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                      iconAlignment: IconAlignment.end,
                      label: const Text('Enviar formulario'),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: TextButton.icon(
                        key: const Key('limpiar_formulario'),
                        onPressed:
                            _respuestas.isEmpty &&
                                _nombreEquipoController.text.isEmpty
                            ? null
                            : _limpiar,
                        icon: const Icon(Icons.restart_alt_rounded, size: 18),
                        label: const Text('Limpiar respuestas'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _seccion(SeccionDiagnostico seccion) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _borde),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFECF5F3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(seccion.icono, color: _verde, size: 21),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  seccion.titulo,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Divider(height: 1, color: _borde),
          ),
          for (var i = 0; i < seccion.preguntas.length; i++) ...[
            if (i > 0) const SizedBox(height: 24),
            _pregunta(seccion.preguntas[i]),
          ],
        ],
      ),
    );
  }

  Widget _pregunta(PreguntaDiagnostico pregunta) {
    return Column(
      key: _campos[pregunta.id],
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          pregunta.titulo,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        if (pregunta.ayuda != null) ...[
          const SizedBox(height: 4),
          Text(
            pregunta.ayuda!,
            style: const TextStyle(fontSize: 12, color: _gris),
          ),
        ],
        const SizedBox(height: 10),
        if (pregunta.selector)
          DropdownButtonFormField<String>(
            key: ValueKey(pregunta.id),
            isExpanded: true,
            hint: const Text(
              'Selecciona una opción',
              style: TextStyle(fontSize: 14, color: _gris),
            ),
            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: _gris),
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              color: _tinta,
            ),
            items: [
              for (final opcion in pregunta.opciones.entries)
                DropdownMenuItem(value: opcion.key, child: Text(opcion.value)),
            ],
            selectedItemBuilder: (context) => [
              for (final opcion in pregunta.opciones.entries)
                Text(opcion.value, overflow: TextOverflow.ellipsis),
            ],
            validator: (value) =>
                value == null ? 'Selecciona una respuesta.' : null,
            onChanged: (value) {
              if (value != null) {
                setState(() => _respuestas[pregunta.id] = value);
              }
            },
          )
        else
          FormField<String>(
            key: ValueKey(pregunta.id),
            validator: (value) =>
                value == null ? 'Selecciona una respuesta.' : null,
            builder: (field) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final opcion in pregunta.opciones.entries)
                      ChoiceChip(
                        key: ValueKey('${pregunta.id}_${opcion.key}'),
                        label: Text(opcion.value),
                        selected: field.value == opcion.key,
                        onSelected: (_) {
                          field.didChange(opcion.key);
                          setState(() => _respuestas[pregunta.id] = opcion.key);
                        },
                        showCheckmark: true,
                        checkmarkColor: _verde,
                        selectedColor: const Color(0xFFE5F3EF),
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: field.value == opcion.key ? _verde : _gris,
                          fontSize: 13,
                          fontWeight: field.value == opcion.key
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                        side: BorderSide(
                          color: field.value == opcion.key ? _verde : _borde,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                      ),
                  ],
                ),
                if (field.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 2),
                    child: Text(
                      field.errorText!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
