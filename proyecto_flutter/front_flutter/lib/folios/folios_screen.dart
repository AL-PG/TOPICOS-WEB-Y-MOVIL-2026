import 'package:flutter/material.dart';

import 'folio.dart';

const _tinta = Color(0xFF192D40);
const _gris = Color(0xFF627487);
const _verde = Color(0xFF137F75);
const _borde = Color(0xFFE1E8ED);

class FoliosScreen extends StatelessWidget {
  const FoliosScreen({super.key, this.folios = const []});

  final List<Folio> folios;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Folios', style: TextStyle(fontSize: 18)),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final tabla = constraints.maxWidth >= 940;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _encabezado(context, constraints.maxWidth >= 650),
                      const SizedBox(height: 28),
                      if (tabla)
                        _tabla(context)
                      else if (folios.isEmpty)
                        _contenedor(const _SinFolios())
                      else
                        for (final folio in folios) ...[
                          _tarjeta(context, folio),
                          const SizedBox(height: 14),
                        ],
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _encabezado(BuildContext context, bool amplio) {
    const titulo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Listado de folios',
          style: TextStyle(
            color: _tinta,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
    final boton = FilledButton.icon(
      key: const Key('nuevo_diagnostico'),
      onPressed: () => Navigator.pushNamed(context, '/diagnostico'),
      icon: const Icon(Icons.add_rounded, size: 20),
      label: const Text('Nuevo diagnóstico'),
    );

    return amplio
        ? Row(
            children: [
              const Expanded(child: titulo),
              const SizedBox(width: 24),
              boton,
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [titulo, const SizedBox(height: 20), boton],
          );
  }

  Widget _contenedor(Widget child) => Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: _borde),
      borderRadius: BorderRadius.circular(18),
    ),
    child: child,
  );

  Widget _tabla(BuildContext context) {
    return _contenedor(
      Column(
        children: [
          Container(
            color: const Color(0xFFF8FAFB),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: const DefaultTextStyle(
              style: TextStyle(
                color: _gris,
                fontFamily: 'Roboto',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.7,
              ),
              child: Row(
                children: [
                  Expanded(flex: 3, child: Text('FOLIO')),
                  Expanded(flex: 3, child: Text('EQUIPO')),
                  Expanded(flex: 2, child: Text('FECHA')),
                  Expanded(flex: 2, child: Text('PRIORIDAD')),
                  Expanded(flex: 2, child: Text('DIAGNÓSTICO')),
                  SizedBox(width: 40),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: _borde),
          if (folios.isEmpty)
            const _SinFolios()
          else
            for (var i = 0; i < folios.length; i++) ...[
              if (i > 0) const Divider(height: 1, color: _borde),
              _fila(context, folios[i]),
            ],
        ],
      ),
    );
  }

  Widget _fila(BuildContext context, Folio folio) {
    return Material(
      color: Colors.white,
      child: InkWell(
        key: ValueKey('folio_${folio.folio}'),
        onTap: () => _verDetalle(context, folio),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  folio.folio,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: _verde,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    folio.equipo,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: _tinta),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  _fecha(folio.fecha),
                  style: const TextStyle(fontSize: 12, color: _gris),
                ),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _Prioridad(prioridad: folio.prioridad),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  folio.diagnostico.etiqueta,
                  style: const TextStyle(fontSize: 13, color: _tinta),
                ),
              ),
              _botonDetalle(context, folio),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Folio folio) {
    return _contenedor(
      Material(
        color: Colors.white,
        child: InkWell(
          key: ValueKey('folio_${folio.folio}'),
          onTap: () => _verDetalle(context, folio),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        folio.folio,
                        style: const TextStyle(
                          color: _verde,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    _botonDetalle(context, folio),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  folio.equipo,
                  style: const TextStyle(
                    color: _tinta,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  folio.descripcion,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _gris, fontSize: 13),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: _gris,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      _fecha(folio.fecha),
                      style: const TextStyle(color: _gris, fontSize: 12),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(height: 1, color: _borde),
                ),
                Wrap(
                  spacing: 28,
                  runSpacing: 16,
                  children: [
                    _CampoDetalle(
                      etiqueta: 'Prioridad',
                      child: _Prioridad(prioridad: folio.prioridad),
                    ),
                    _CampoDetalle(
                      etiqueta: 'Diagnóstico',
                      child: Text(
                        folio.diagnostico.etiqueta,
                        style: const TextStyle(
                          color: _tinta,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _botonDetalle(BuildContext context, Folio folio) => SizedBox(
    width: 40,
    child: IconButton(
      key: ValueKey('detalle_${folio.folio}'),
      tooltip: 'Ver detalle del folio',
      onPressed: () => _verDetalle(context, folio),
      icon: const Icon(Icons.chevron_right_rounded, color: _gris, size: 22),
    ),
  );

  void _verDetalle(BuildContext context, Folio folio) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalle del folio'),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  folio.folio,
                  style: const TextStyle(
                    color: _verde,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24),
                _CampoDetalle(etiqueta: 'Equipo', child: Text(folio.equipo)),
                const SizedBox(height: 18),
                _CampoDetalle(
                  etiqueta: 'Fecha de registro',
                  child: Text(_fecha(folio.fecha)),
                ),
                const SizedBox(height: 18),
                _CampoDetalle(
                  etiqueta: 'Descripción',
                  child: Text(folio.descripcion),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 22),
                  child: Divider(height: 1, color: _borde),
                ),
                Wrap(
                  spacing: 32,
                  runSpacing: 20,
                  children: [
                    _CampoDetalle(
                      etiqueta: 'Prioridad',
                      child: _Prioridad(prioridad: folio.prioridad),
                    ),
                    _CampoDetalle(
                      etiqueta: 'Diagnóstico',
                      child: Text(folio.diagnostico.etiqueta),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}

class _SinFolios extends StatelessWidget {
  const _SinFolios();

  @override
  Widget build(BuildContext context) => Container(
    key: const Key('folios_vacio'),
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
    child: Column(
      children: [
        const Icon(Icons.folder_open_rounded, color: _gris, size: 42),
        const SizedBox(height: 16),
        const Text(
          'No hay folios registrados',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _gris,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

class _CampoDetalle extends StatelessWidget {
  const _CampoDetalle({required this.etiqueta, required this.child});

  final String etiqueta;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(etiqueta, style: const TextStyle(color: _gris, fontSize: 12)),
      const SizedBox(height: 6),
      child,
    ],
  );
}

class _Prioridad extends StatelessWidget {
  const _Prioridad({required this.prioridad});

  final PrioridadFolio prioridad;

  @override
  Widget build(BuildContext context) {
    final (color, fondo) = switch (prioridad) {
      PrioridadFolio.baja => (_verde, const Color(0xFFE5F3EF)),
      PrioridadFolio.media => (
        const Color(0xFF376BA4),
        const Color(0xFFEBF2FC),
      ),
      PrioridadFolio.alta => (const Color(0xFFAC5620), const Color(0xFFFFEBDD)),
      PrioridadFolio.critica => (
        const Color(0xFFB53D45),
        const Color(0xFFFCE8EB),
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        prioridad.etiqueta,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

String _fecha(DateTime fecha) {
  const meses = [
    'ene',
    'feb',
    'mar',
    'abr',
    'may',
    'jun',
    'jul',
    'ago',
    'sep',
    'oct',
    'nov',
    'dic',
  ];
  return '${fecha.day} ${meses[fecha.month - 1]} ${fecha.year}';
}
