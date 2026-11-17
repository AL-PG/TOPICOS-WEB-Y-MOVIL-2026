import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front_flutter/folios/folios_screen.dart';

Future<void> abrirListado(WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: FoliosScreen()));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('El listado vacío cabe en una pantalla móvil angosta', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 740);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await abrirListado(tester);

    expect(find.byKey(const Key('folios_vacio')), findsOneWidget);
    expect(find.text('No hay folios registrados'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
    expect(find.text('Datos de ejemplo'), findsNothing);
    expect(find.textContaining('FOL-2026-'), findsNothing);
    expect(find.byType(AlertDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'La tabla vacía conserva las columnas de prioridad y diagnóstico',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1200, 900);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      await abrirListado(tester);

      expect(find.text('PRIORIDAD'), findsOneWidget);
      expect(find.text('DIAGNÓSTICO'), findsOneWidget);
      expect(find.text('ESTADO'), findsNothing);
      expect(find.text('Total de folios'), findsNothing);
      expect(find.text('Pendientes'), findsNothing);
      expect(find.byType(ChoiceChip), findsNothing);
      expect(find.byType(TextField), findsNothing);
      expect(find.byKey(const Key('folios_vacio')), findsOneWidget);
      expect(find.text('No hay folios registrados'), findsOneWidget);
      expect(find.text('Datos de ejemplo'), findsNothing);
      expect(find.textContaining('FOL-2026-'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
