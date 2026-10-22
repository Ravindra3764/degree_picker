import 'package:flutter/widgets.dart';

import '../models/degree.dart';
import 'degree_picker_style.dart';

/// How the picker is presented when the field is tapped.
enum DegreePickerMode {
  /// Modal bottom sheet.
  bottomSheet,

  /// Centered floating dialog.
  dialog,
}

/// Builds a custom row for a degree in the list.
typedef DegreeItemBuilder = Widget Function(
  BuildContext context,
  Degree degree,
  bool selected,
);

/// Configuration shared by [DegreePickerField] and `showDegreePicker`.
@immutable
class DegreePickerConfig {
  /// Creates a configuration.
  const DegreePickerConfig({
    this.mode = DegreePickerMode.bottomSheet,
    this.title = 'Select degree',
    this.searchHint = 'Search degrees',
    this.emptyText = 'No degrees found',
    this.customOptionPrefix = 'Use',
    this.clearTooltip = 'Clear',
    this.showLevelFilter = true,
    this.allowCustom = false,
    this.allowClear = false,
    this.autofocusSearch = false,
    this.levels,
    this.countries,
    this.itemBuilder,
    this.dialogMaxWidth = 480,
    this.dialogHeight = 560,
    this.sheetHeightFactor = 0.85,
    this.style,
  });

  /// Bottom sheet or dialog.
  final DegreePickerMode mode;

  /// Header text.
  final String title;

  /// Hint inside the search box.
  final String searchHint;

  /// Text shown when nothing matches.
  final String emptyText;

  /// Prefix of the "use what I typed" row, e.g. `Use "Foo"`.
  final String customOptionPrefix;

  /// Tooltip of the clear buttons (field and search box).
  final String clearTooltip;

  /// Show level chips (Bachelor, Master, ...).
  final bool showLevelFilter;

  /// Let users submit a degree that is not in the list.
  final bool allowCustom;

  /// Show a clear button on the field when a value is selected.
  final bool allowClear;

  /// Focus the search box (and open the keyboard) immediately.
  final bool autofocusSearch;

  /// Restrict to these levels. `null` = all.
  final Set<DegreeLevel>? levels;

  /// Restrict to degrees common in these ISO country codes. Degrees with no
  /// country are treated as global and always kept. `null` = all.
  final Set<String>? countries;

  /// Custom row builder.
  final DegreeItemBuilder? itemBuilder;

  /// Max width of the dialog.
  final double dialogMaxWidth;

  /// Height of the dialog.
  final double dialogHeight;

  /// Bottom sheet height as a fraction of the available screen height.
  final double sheetHeightFactor;

  /// Colors, shapes and text styles. `null` = follow the app theme (or the
  /// app-wide [DegreePickerTheme]).
  final DegreePickerStyle? style;

  /// Applies [levels] and [countries] filters.
  List<Degree> filter(List<Degree> all) {
    final lv = levels;
    final cc = countries?.map((c) => c.toUpperCase()).toSet();
    if (lv == null && cc == null) return all;
    return all.where((d) {
      if (lv != null && !lv.contains(d.level)) return false;
      if (cc != null &&
          d.countries.isNotEmpty &&
          !d.countries.any((c) => cc.contains(c.toUpperCase()))) {
        return false;
      }
      return true;
    }).toList(growable: false);
  }
}
