import 'package:flutter/material.dart';

/// Visual customisation of the picker (sheet, dialog, search box, rows, chips).
///
/// Every field is optional. Anything left `null` falls back to the app's
/// [Theme], so the picker matches your app out of the box.
///
/// ```dart
/// DegreePickerField(
///   config: DegreePickerConfig(
///     style: DegreePickerStyle(
///       backgroundColor: Colors.white,
///       selectedTileColor: Colors.indigo.shade50,
///       shape: RoundedRectangleBorder(
///         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
///       ),
///     ),
///   ),
/// )
/// ```
///
/// To style every picker in your app once, add a [DegreePickerTheme] to
/// `ThemeData.extensions`.
@immutable
class DegreePickerStyle {
  /// Creates a style. All parameters are optional.
  const DegreePickerStyle({
    this.backgroundColor,
    this.shape,
    this.elevation,
    this.barrierColor,
    this.showDragHandle,
    this.dragHandleColor,
    this.titleStyle,
    this.titlePadding,
    this.searchDecoration,
    this.searchTextStyle,
    this.searchPadding,
    this.itemTitleStyle,
    this.itemSubtitleStyle,
    this.itemPadding,
    this.selectedColor,
    this.selectedTileColor,
    this.selectedIcon,
    this.showDividers,
    this.dividerColor,
    this.chipTheme,
    this.chipsPadding,
    this.emptyTextStyle,
    this.customIcon,
  });

  // --- Container (bottom sheet / dialog) ---

  /// Background of the sheet or dialog.
  final Color? backgroundColor;

  /// Shape (corners) of the sheet or dialog.
  final ShapeBorder? shape;

  /// Elevation of the sheet or dialog.
  final double? elevation;

  /// Color of the scrim behind the picker.
  final Color? barrierColor;

  /// Whether the bottom sheet shows a drag handle. Defaults to `true`.
  final bool? showDragHandle;

  /// Color of the drag handle.
  final Color? dragHandleColor;

  // --- Header ---

  /// Text style of the title.
  final TextStyle? titleStyle;

  /// Padding around the title.
  final EdgeInsetsGeometry? titlePadding;

  // --- Search box ---

  /// Decoration of the search box. Its `hintText` and `prefixIcon` are
  /// filled from the config / defaults when you leave them `null`.
  final InputDecoration? searchDecoration;

  /// Text style of the text typed in the search box.
  final TextStyle? searchTextStyle;

  /// Padding around the search box.
  final EdgeInsetsGeometry? searchPadding;

  // --- Rows ---

  /// Text style of a degree name.
  final TextStyle? itemTitleStyle;

  /// Text style of the second line (`B.Tech · Bachelor · Engineering`).
  final TextStyle? itemSubtitleStyle;

  /// Padding of a row. Uses the [ListTile] default when `null`.
  final EdgeInsetsGeometry? itemPadding;

  /// Text / icon color of the selected row.
  final Color? selectedColor;

  /// Background color of the selected row.
  final Color? selectedTileColor;

  /// Icon at the end of the selected row. Defaults to a check mark.
  final Widget? selectedIcon;

  /// Draw a divider between rows. Defaults to `false`.
  final bool? showDividers;

  /// Color of the dividers.
  final Color? dividerColor;

  // --- Level chips ---

  /// Theme of the level filter chips (selected color, shape, label style...).
  final ChipThemeData? chipTheme;

  /// Padding around the chip row.
  final EdgeInsetsGeometry? chipsPadding;

  // --- Misc ---

  /// Text style of the "no results" message.
  final TextStyle? emptyTextStyle;

  /// Leading icon of the "use what I typed" row.
  final Widget? customIcon;

  /// Returns a copy with the given fields replaced.
  DegreePickerStyle copyWith({
    Color? backgroundColor,
    ShapeBorder? shape,
    double? elevation,
    Color? barrierColor,
    bool? showDragHandle,
    Color? dragHandleColor,
    TextStyle? titleStyle,
    EdgeInsetsGeometry? titlePadding,
    InputDecoration? searchDecoration,
    TextStyle? searchTextStyle,
    EdgeInsetsGeometry? searchPadding,
    TextStyle? itemTitleStyle,
    TextStyle? itemSubtitleStyle,
    EdgeInsetsGeometry? itemPadding,
    Color? selectedColor,
    Color? selectedTileColor,
    Widget? selectedIcon,
    bool? showDividers,
    Color? dividerColor,
    ChipThemeData? chipTheme,
    EdgeInsetsGeometry? chipsPadding,
    TextStyle? emptyTextStyle,
    Widget? customIcon,
  }) =>
      DegreePickerStyle(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        shape: shape ?? this.shape,
        elevation: elevation ?? this.elevation,
        barrierColor: barrierColor ?? this.barrierColor,
        showDragHandle: showDragHandle ?? this.showDragHandle,
        dragHandleColor: dragHandleColor ?? this.dragHandleColor,
        titleStyle: titleStyle ?? this.titleStyle,
        titlePadding: titlePadding ?? this.titlePadding,
        searchDecoration: searchDecoration ?? this.searchDecoration,
        searchTextStyle: searchTextStyle ?? this.searchTextStyle,
        searchPadding: searchPadding ?? this.searchPadding,
        itemTitleStyle: itemTitleStyle ?? this.itemTitleStyle,
        itemSubtitleStyle: itemSubtitleStyle ?? this.itemSubtitleStyle,
        itemPadding: itemPadding ?? this.itemPadding,
        selectedColor: selectedColor ?? this.selectedColor,
        selectedTileColor: selectedTileColor ?? this.selectedTileColor,
        selectedIcon: selectedIcon ?? this.selectedIcon,
        showDividers: showDividers ?? this.showDividers,
        dividerColor: dividerColor ?? this.dividerColor,
        chipTheme: chipTheme ?? this.chipTheme,
        chipsPadding: chipsPadding ?? this.chipsPadding,
        emptyTextStyle: emptyTextStyle ?? this.emptyTextStyle,
        customIcon: customIcon ?? this.customIcon,
      );

  /// Returns this style with every non-null field of [other] on top.
  DegreePickerStyle merge(DegreePickerStyle? other) => other == null
      ? this
      : copyWith(
          backgroundColor: other.backgroundColor,
          shape: other.shape,
          elevation: other.elevation,
          barrierColor: other.barrierColor,
          showDragHandle: other.showDragHandle,
          dragHandleColor: other.dragHandleColor,
          titleStyle: other.titleStyle,
          titlePadding: other.titlePadding,
          searchDecoration: other.searchDecoration,
          searchTextStyle: other.searchTextStyle,
          searchPadding: other.searchPadding,
          itemTitleStyle: other.itemTitleStyle,
          itemSubtitleStyle: other.itemSubtitleStyle,
          itemPadding: other.itemPadding,
          selectedColor: other.selectedColor,
          selectedTileColor: other.selectedTileColor,
          selectedIcon: other.selectedIcon,
          showDividers: other.showDividers,
          dividerColor: other.dividerColor,
          chipTheme: other.chipTheme,
          chipsPadding: other.chipsPadding,
          emptyTextStyle: other.emptyTextStyle,
          customIcon: other.customIcon,
        );

  /// The style to use for [context]: the app-wide [DegreePickerTheme] (if
  /// any) overridden by [local].
  static DegreePickerStyle resolve(
    BuildContext context,
    DegreePickerStyle? local,
  ) {
    final base = Theme.of(context).extension<DegreePickerTheme>()?.style ??
        const DegreePickerStyle();
    return base.merge(local);
  }
}

/// App-wide [DegreePickerStyle]. Set it once and every picker follows.
///
/// ```dart
/// MaterialApp(
///   theme: ThemeData(
///     extensions: [
///       DegreePickerTheme(
///         style: DegreePickerStyle(selectedTileColor: Colors.indigo.shade50),
///       ),
///     ],
///   ),
/// )
/// ```
///
/// A `style` passed to a single `DegreePickerConfig` wins over this theme.
@immutable
class DegreePickerTheme extends ThemeExtension<DegreePickerTheme> {
  /// Creates the theme extension.
  const DegreePickerTheme({this.style = const DegreePickerStyle()});

  /// The style applied to every picker below this theme.
  final DegreePickerStyle style;

  @override
  DegreePickerTheme copyWith({DegreePickerStyle? style}) =>
      DegreePickerTheme(style: style ?? this.style);

  /// Pickers do not animate between themes; switches to [other] at `t >= 0.5`.
  @override
  DegreePickerTheme lerp(ThemeExtension<DegreePickerTheme>? other, double t) =>
      other is DegreePickerTheme && t >= 0.5 ? other : this;
}
