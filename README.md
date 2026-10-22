# degree_picker

[![pub package](https://img.shields.io/pub/v/degree_picker.svg)](https://pub.dev/packages/degree_picker)
[![license: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Searchable **degree picker** and **education qualification dropdown** for Flutter forms.
Pick from **1000+ degrees, diplomas, bachelor, master and PhD programs** (B.Tech, MBA, M.Sc, Ph.D, MBBS, LLB, ...)
in a **bottom sheet** or **floating dialog**. Works offline, no API.

## Features

- Searchable `FormField` with validator support (`DegreePickerField`)
- 1000+ degrees across 13 levels: certificate, diploma, bachelor, honours, master, doctorate and more
- Smart search: abbreviations, aliases and punctuation (`btech`, `B.Tech`, `b tech`)
- Level filter chips, custom entry ("Add my degree"), clear button
- Bottom sheet or dialog, custom item builder
- Plain JSON data, easy to extend or replace
- Android, iOS, web, desktop

## Usage

```dart
DegreePickerField(
  decoration: const InputDecoration(labelText: 'Degree'),
  config: const DegreePickerConfig(
    mode: DegreePickerMode.bottomSheet, // or DegreePickerMode.dialog
    allowCustom: true,
    allowClear: true,
  ),
  validator: (d) => d == null ? 'Required' : null,
  onChanged: (degree) => print(degree?.name),
);
```

Use your own trigger:

```dart
final degree = await showDegreePicker(context, degrees: myList);
```

## Config

| Property | Default | Description |
|---|---|---|
| `mode` | `bottomSheet` | `bottomSheet` or `dialog` |
| `title`, `searchHint`, `emptyText` | English | Texts (localize here) |
| `showLevelFilter` | `true` | Bachelor / Master / ... chips |
| `allowCustom` | `false` | Let users add a degree not in the list |
| `allowClear` | `false` | Clear button on the field |
| `levels` | all | Restrict to certain `DegreeLevel`s |
| `countries` | all | ISO codes; untagged degrees are always kept (bundled data is untagged) |
| `itemBuilder` | default tile | Fully custom row |
| `autofocusSearch` | `false` | Open keyboard immediately |

## Using your own JSON

```dart
DegreePickerField(
  repository: DegreeRepository(assetPath: 'assets/my_degrees.json'),
);
```

## Customize the look

Nothing to configure by default: the picker follows your app `Theme`
(light/dark, Material 3). To change anything, pass a `DegreePickerStyle`.
Every field is optional.

```dart
DegreePickerField(
  textStyle: const TextStyle(fontWeight: FontWeight.w600), // selected value
  config: DegreePickerConfig(
    title: 'Your qualification',
    style: DegreePickerStyle(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      selectedTileColor: Colors.indigo.shade50,
      selectedColor: Colors.indigo,
      showDividers: true,
    ),
  ),
)
```

Style every picker in the app once with a theme extension:

```dart
MaterialApp(
  theme: ThemeData(
    extensions: [
      DegreePickerTheme(
        style: DegreePickerStyle(selectedTileColor: Colors.indigo.shade50),
      ),
    ],
  ),
)
```

A style on one `DegreePickerConfig` overrides the app-wide theme.

| Group | `DegreePickerStyle` fields |
|---|---|
| Sheet / dialog | `backgroundColor`, `shape`, `elevation`, `barrierColor`, `showDragHandle`, `dragHandleColor` |
| Title | `titleStyle`, `titlePadding` |
| Search box | `searchDecoration`, `searchTextStyle`, `searchPadding` |
| Rows | `itemTitleStyle`, `itemSubtitleStyle`, `itemPadding`, `selectedColor`, `selectedTileColor`, `selectedIcon`, `showDividers`, `dividerColor` |
| Level chips | `chipTheme`, `chipsPadding` |
| Other | `emptyTextStyle`, `customIcon` |

Texts live in `DegreePickerConfig`: `title`, `searchHint`, `emptyText`,
`customOptionPrefix`, `clearTooltip`. Need a fully custom row? Use `itemBuilder`.

## JSON format

```json
{
  "version": 2,
  "degrees": [
    {
      "id": "btech",
      "name": "Bachelor of Technology",
      "short": "B.Tech",
      "level": "bachelor",
      "field": "Engineering",
      "aliases": ["BTech"]
    }
  ]
}
```

`level`: `certificate | vocational | foundation | diploma | associate | bachelor | honours | postgraduateDiploma | master | integratedMaster | doctorate | professional | postdoctoral | other`.
`id` must be unique and never renamed (apps may have it saved). `countries` is optional and unused in the bundled data (empty = global); it still works for custom JSON.

## Contributing degrees

Edit `assets/degrees.json` and open a PR. `flutter test` validates unique ids and the schema. See [CONTRIBUTING.md](CONTRIBUTING.md).
