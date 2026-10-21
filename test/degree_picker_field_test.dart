import 'package:degree_picker/degree_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _degrees = [
  Degree(
    id: 'mba',
    name: 'Master of Business Administration',
    shortName: 'MBA',
    level: DegreeLevel.master,
  ),
  Degree(
    id: 'btech',
    name: 'Bachelor of Technology',
    shortName: 'B.Tech',
    level: DegreeLevel.bachelor,
  ),
];

Future<Degree?> _pickWith(WidgetTester tester, DegreePickerMode mode) async {
  Degree? picked;
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: DegreePickerField(
          degrees: _degrees,
          config: DegreePickerConfig(mode: mode),
          onChanged: (d) => picked = d,
        ),
      ),
    ),
  );
  await tester.tap(find.byType(DegreePickerField));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField), 'mba');
  await tester.pumpAndSettle();
  await tester.tap(find.text('Master of Business Administration'));
  await tester.pumpAndSettle();
  return picked;
}

void main() {
  testWidgets('bottom sheet: search and select', (tester) async {
    final picked = await _pickWith(tester, DegreePickerMode.bottomSheet);
    expect(picked?.id, 'mba');
    expect(
        find.text('Master of Business Administration (MBA)'), findsOneWidget);
  });

  testWidgets('dialog: search and select', (tester) async {
    final picked = await _pickWith(tester, DegreePickerMode.dialog);
    expect(picked?.id, 'mba');
  });

  testWidgets('validator error shows in form', (tester) async {
    final key = GlobalKey<FormState>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: key,
            child: DegreePickerField(
              degrees: _degrees,
              validator: (d) => d == null ? 'Required' : null,
            ),
          ),
        ),
      ),
    );
    expect(key.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text('Required'), findsOneWidget);
  });
}
