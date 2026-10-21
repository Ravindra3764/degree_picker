import 'package:flutter/material.dart';

import '../models/degree.dart';
import 'degree_picker_config.dart';
import 'degree_search_panel.dart';

/// Opens the picker (bottom sheet or dialog depending on [config]) and
/// returns the chosen degree, or `null` if dismissed.
///
/// Use this directly if you want your own trigger instead of
/// `DegreePickerField`.
Future<Degree?> showDegreePicker(
  BuildContext context, {
  required List<Degree> degrees,
  Degree? selected,
  DegreePickerConfig config = const DegreePickerConfig(),
}) {
  final items = config.filter(degrees);

  Widget panel(BuildContext ctx) => DegreeSearchPanel(
        degrees: items,
        selected: selected,
        config: config,
        onSelected: (d) => Navigator.of(ctx).pop(d),
      );

  switch (config.mode) {
    case DegreePickerMode.bottomSheet:
      return showModalBottomSheet<Degree>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        showDragHandle: true,
        builder: (ctx) {
          final mq = MediaQuery.of(ctx);
          return Padding(
            padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
            child: SizedBox(
              height: (mq.size.height - mq.viewInsets.bottom) *
                  config.sheetHeightFactor,
              child: panel(ctx),
            ),
          );
        },
      );
    case DegreePickerMode.dialog:
      return showDialog<Degree>(
        context: context,
        builder: (ctx) => Dialog(
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: config.dialogMaxWidth,
              maxHeight: config.dialogHeight,
            ),
            child: panel(ctx),
          ),
        ),
      );
  }
}
