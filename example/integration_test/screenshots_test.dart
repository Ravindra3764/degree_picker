import 'package:degree_picker/degree_picker.dart';
import 'package:degree_picker_example/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> shot(WidgetTester t, String name) async {
    await t.pumpAndSettle();
    await binding.takeScreenshot(name);
  }

  testWidgets('readme screenshots', (t) async {
    await binding.convertFlutterSurfaceToImage();
    app.main();
    await t.pumpAndSettle();

    // Default bottom sheet, searching.
    await t.tap(find.byType(DegreePickerField).at(0));
    await t.pumpAndSettle();
    await shot(t, '2_sheet');
    await t.enterText(find.byType(TextField), 'b.tech');
    await shot(t, '3_search');
    // Pick one to close.
    await t.tap(find.text('Bachelor of Technology').first);
    await t.pumpAndSettle();

    // Dialog mode.
    await t.tap(find.byType(DegreePickerField).at(1));
    await t.pumpAndSettle();
    await shot(t, '4_dialog');
    await t.tap(find.byType(ListTile).first);
    await t.pumpAndSettle();

    // Custom style.
    await t.drag(find.byType(ListView).first, const Offset(0, -300));
    await t.pumpAndSettle();
    await t.tap(find.text('Degree (custom style)'));
    await t.pumpAndSettle();
    await shot(t, '5_custom_style');
  });
}
