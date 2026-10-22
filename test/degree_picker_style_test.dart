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

Future<void> _open(
  WidgetTester tester, {
  DegreePickerStyle? style,
  DegreePickerMode mode = DegreePickerMode.bottomSheet,
  ThemeData? theme,
  Degree? initial,
  TextStyle? textStyle,
  String clearTooltip = 'Clear',
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: theme,
      home: Scaffold(
        body: DegreePickerField(
          degrees: _degrees,
          initialValue: initial,
          textStyle: textStyle,
          config: DegreePickerConfig(
            mode: mode,
            style: style,
            allowClear: true,
            clearTooltip: clearTooltip,
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.byType(DegreePickerField));
  await tester.pumpAndSettle();
}

Text _text(WidgetTester tester, String data) =>
    tester.widget<Text>(find.text(data));

void main() {
  test('merge: non-null wins, null keeps base', () {
    const a = DegreePickerStyle(backgroundColor: Colors.red, elevation: 1);
    const b = DegreePickerStyle(backgroundColor: Colors.blue);
    final m = a.merge(b);
    expect(m.backgroundColor, Colors.blue);
    expect(m.elevation, 1);
    expect(a.merge(null), same(a));
  });

  testWidgets('no style: defaults render', (tester) async {
    await _open(tester);
    expect(find.text('Select degree'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets('title and item text styles apply', (tester) async {
    const title = TextStyle(fontSize: 31, color: Colors.green);
    const item = TextStyle(fontSize: 17, color: Colors.purple);
    await _open(
      tester,
      style: const DegreePickerStyle(titleStyle: title, itemTitleStyle: item),
    );
    expect(_text(tester, 'Select degree').style?.fontSize, 31);
    expect(_text(tester, 'Bachelor of Technology').style?.color, Colors.purple);
  });

  testWidgets('selected row color, icon and dividers apply', (tester) async {
    await _open(
      tester,
      initial: _degrees.first,
      style: const DegreePickerStyle(
        selectedTileColor: Colors.amber,
        selectedIcon: Icon(Icons.star),
        showDividers: true,
      ),
    );
    final tile = tester.widget<ListTile>(
      find.widgetWithText(ListTile, 'Master of Business Administration'),
    );
    expect(tile.selectedTileColor, Colors.amber);
    expect(find.byIcon(Icons.star), findsOneWidget);
    expect(find.byType(Divider), findsWidgets);
  });

  testWidgets('sheet background and shape apply', (tester) async {
    await _open(
      tester,
      style: const DegreePickerStyle(
        backgroundColor: Colors.teal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
      ),
    );
    final sheet = tester.widget<BottomSheet>(find.byType(BottomSheet));
    expect(sheet.backgroundColor, Colors.teal);
    expect(sheet.shape, isA<RoundedRectangleBorder>());
  });

  testWidgets('dialog background applies', (tester) async {
    await _open(
      tester,
      mode: DegreePickerMode.dialog,
      style: const DegreePickerStyle(backgroundColor: Colors.teal),
    );
    expect(tester.widget<Dialog>(find.byType(Dialog)).backgroundColor,
        Colors.teal);
  });

  testWidgets('drag handle can be hidden', (tester) async {
    await _open(
      tester,
      style: const DegreePickerStyle(showDragHandle: false),
    );
    expect(
      find.byWidgetPredicate(
        (w) => w is Container && (w.constraints?.maxWidth == 32),
      ),
      findsNothing,
    );
  });

  testWidgets('search decoration keeps hint and icon when not overridden',
      (tester) async {
    await _open(
      tester,
      style: const DegreePickerStyle(
        searchDecoration: InputDecoration(filled: true, fillColor: Colors.grey),
      ),
    );
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.decoration?.filled, true);
    expect(field.decoration?.hintText, 'Search degrees');
    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets('app-wide DegreePickerTheme applies; local style wins',
      (tester) async {
    final theme = ThemeData(
      extensions: const [
        DegreePickerTheme(
          style: DegreePickerStyle(
            titleStyle: TextStyle(fontSize: 40),
            backgroundColor: Colors.orange,
          ),
        ),
      ],
    );
    await _open(
      tester,
      theme: theme,
      style: const DegreePickerStyle(backgroundColor: Colors.teal),
    );
    expect(_text(tester, 'Select degree').style?.fontSize, 40);
    expect(tester.widget<BottomSheet>(find.byType(BottomSheet)).backgroundColor,
        Colors.teal);
  });

  testWidgets('field textStyle and clearTooltip apply', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DegreePickerField(
            degrees: _degrees,
            initialValue: _degrees.first,
            textStyle: const TextStyle(fontSize: 22),
            config: const DegreePickerConfig(
              allowClear: true,
              clearTooltip: 'Hatao',
            ),
          ),
        ),
      ),
    );
    expect(
      _text(tester, 'Master of Business Administration (MBA)').style?.fontSize,
      22,
    );
    expect(find.byTooltip('Hatao'), findsOneWidget);
  });
}
