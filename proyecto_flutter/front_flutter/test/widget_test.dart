import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front_flutter/main.dart';

Future<void> tocar(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> elegirOpcion(
  WidgetTester tester,
  String campo,
  String etiqueta,
) async {
  await tocar(tester, find.byKey(ValueKey(campo)));
  await tester.tap(find.text(etiqueta).last);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('El formulario cabe en una pantalla móvil angosta', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 740);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(const MyApp());

    expect(find.text('Nuevo diagnóstico'), findsOneWidget);
    expect(find.text('Funcionamiento general'), findsOneWidget);
    expect(find.text('Pantalla y carga'), findsOneWidget);
    expect(find.text('Historial y señales'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('enviar_formulario')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Las preguntas pendientes muestran su validación', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tocar(tester, find.byKey(const Key('enviar_formulario')));

    expect(find.text('Selecciona una respuesta.'), findsNWidgets(9));
    expect(find.byType(AlertDialog), findsNothing);
    expect(
      tester
          .widget<TextButton>(find.byKey(const Key('limpiar_formulario')))
          .onPressed,
      isNull,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Completar permite revisar y limpiar todas las respuestas', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    for (final campo in ['encendido', 'reinicios_frecuentes']) {
      await tocar(tester, find.byKey(ValueKey('${campo}_si')));
    }
    await elegirOpcion(tester, 'estado_pantalla', 'Se ve con normalidad');
    await elegirOpcion(tester, 'respuesta_tactil', 'Responde con normalidad');
    await elegirOpcion(tester, 'estado_carga', 'Carga con normalidad');
    for (final campo in [
      'golpe_reciente',
      'contacto_liquido',
      'sobrecalentamiento',
      'bateria_hinchada',
    ]) {
      await tocar(tester, find.byKey(ValueKey('${campo}_no')));
    }

    for (final campo in [
      'encendido',
      'reinicios_frecuentes',
      'estado_pantalla',
      'respuesta_tactil',
      'estado_carga',
      'golpe_reciente',
      'contacto_liquido',
      'sobrecalentamiento',
      'bateria_hinchada',
    ]) {
      expect(
        tester.state<FormFieldState<String>>(find.byKey(ValueKey(campo))).value,
        isNotNull,
      );
    }
    await tocar(tester, find.byKey(const Key('enviar_formulario')));
    expect(find.text('Formulario listo'), findsOneWidget);
    expect(
      find.textContaining('el envío todavía no está habilitado.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Seguir editando'));
    await tester.pumpAndSettle();
    await tocar(tester, find.byKey(const Key('limpiar_formulario')));

    expect(
      tester
          .widget<TextButton>(find.byKey(const Key('limpiar_formulario')))
          .onPressed,
      isNull,
    );
    expect(find.text('Selecciona una respuesta.'), findsNothing);
    expect(
      tester
          .widgetList<ChoiceChip>(find.byType(ChoiceChip))
          .every((chip) => !chip.selected),
      isTrue,
    );
    for (final campo in [
      'estado_pantalla',
      'respuesta_tactil',
      'estado_carga',
    ]) {
      expect(
        tester.state<FormFieldState<String>>(find.byKey(ValueKey(campo))).value,
        isNull,
      );
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('Se puede abrir el listado y volver al formulario', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tocar(tester, find.byKey(const Key('ver_folios')));
    expect(find.text('Listado de folios'), findsOneWidget);
    await tocar(tester, find.byKey(const Key('nuevo_diagnostico')));

    expect(find.byKey(const Key('enviar_formulario')), findsOneWidget);
    expect(find.text('Listado de folios'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
