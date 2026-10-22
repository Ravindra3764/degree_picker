import 'package:flutter/material.dart';

import '../models/degree.dart';
import 'degree_picker_config.dart';
import 'degree_picker_style.dart';
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
  final style = DegreePickerStyle.resolve(context, config.style);

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
        showDragHandle: false,
        backgroundColor: style.backgroundColor,
        shape: style.shape,
        elevation: style.elevation,
        barrierColor: style.barrierColor,
        builder: (ctx) {
          final mq = MediaQuery.of(ctx);
          return Padding(
            padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
            child: SizedBox(
              height: (mq.size.height - mq.viewInsets.bottom) *
                  config.sheetHeightFactor,
              child: Column(
                children: [
                  if (style.showDragHandle ?? true)
                    _DragHandle(color: style.dragHandleColor),
                  Expanded(child: panel(ctx)),
                ],
              ),
            ),
          );
        },
      );
    case DegreePickerMode.dialog:
      return showDialog<Degree>(
        context: context,
        barrierColor: style.barrierColor,
        builder: (ctx) => Dialog(
          clipBehavior: Clip.antiAlias,
          backgroundColor: style.backgroundColor,
          shape: style.shape,
          elevation: style.elevation,
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

class _DragHandle extends StatelessWidget {
  const _DragHandle({this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Container(
          width: 32,
          height: 4,
          decoration: BoxDecoration(
            color: color ??
                Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(100),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
}
