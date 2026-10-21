# degree_picker

A text-box style form field that opens a **searchable list of degrees**
(B.Tech, MBA, Ph.D, ...) in a **bottom sheet** or **floating dialog**.
Degrees live in a plain JSON file, so anyone can extend or replace the data.

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
