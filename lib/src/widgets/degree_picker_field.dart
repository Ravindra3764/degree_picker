import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../data/degree_repository.dart';
import '../models/degree.dart';
import 'degree_picker_config.dart';
import 'degree_picker_launcher.dart';

/// A text-box looking form field. Tapping it opens a searchable picker as a
/// bottom sheet or dialog (see [DegreePickerConfig.mode]).
///
/// Works inside a [Form] (validator, onSaved, autovalidateMode).
class DegreePickerField extends StatefulWidget {
  /// Creates the field.
  ///
  /// Degrees come from [degrees] if given, otherwise from [repository],
  /// otherwise from the dataset bundled with the package.
  const DegreePickerField({
    super.key,
    this.degrees,
    this.repository,
    this.initialValue,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.autovalidateMode,
    this.decoration = const InputDecoration(labelText: 'Degree'),
    this.config = const DegreePickerConfig(),
    this.enabled = true,
    this.onLoadError,
  });

  /// Explicit list of degrees (overrides [repository]).
  final List<Degree>? degrees;

  /// Custom repository, e.g. pointing at your own JSON asset.
  final DegreeRepository? repository;

  /// Initially selected degree.
  final Degree? initialValue;

  /// Called when the selection changes (including clear).
  final ValueChanged<Degree?>? onChanged;

  /// Form onSaved callback.
  final FormFieldSetter<Degree>? onSaved;

  /// Form validator.
  final FormFieldValidator<Degree>? validator;

  /// Form auto validation mode.
  final AutovalidateMode? autovalidateMode;

  /// Look of the box. Defaults to a labelled field.
  final InputDecoration decoration;

  /// Picker behaviour and texts.
  final DegreePickerConfig config;

  /// Disables interaction.
  final bool enabled;

  /// Called if the dataset fails to load. If null, the error is reported
  /// through [FlutterError.reportError].
  final void Function(Object error, StackTrace stack)? onLoadError;

  @override
  State<DegreePickerField> createState() => _DegreePickerFieldState();
}

class _DegreePickerFieldState extends State<DegreePickerField> {
  late Future<List<Degree>> _future;

  @override
  void initState() {
    super.initState();
    _future = _resolve();
  }

  @override
  void didUpdateWidget(covariant DegreePickerField old) {
    super.didUpdateWidget(old);
    if (!identical(old.degrees, widget.degrees) ||
        old.repository != widget.repository) {
      _future = _resolve();
    }
  }

  Future<List<Degree>> _resolve() {
    final f = widget.degrees != null
        ? Future.value(widget.degrees!)
        : (widget.repository ?? DegreeRepository.instance).load();
    f.ignore(); // errors are handled when the user taps
    return f;
  }

  void _set(FormFieldState<Degree> state, Degree? value) {
    state.didChange(value);
    widget.onChanged?.call(value);
  }

  Future<void> _open(FormFieldState<Degree> state) async {
    FocusScope.of(context).unfocus();
    final List<Degree> all;
    try {
      all = await _future;
    } catch (e, st) {
      final handler = widget.onLoadError;
      if (handler != null) {
        handler(e, st);
      } else {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: e,
            stack: st,
            library: 'degree_picker',
          ),
        );
      }
      return;
    }
    if (!mounted) return;
    final picked = await showDegreePicker(
      context,
      degrees: all,
      selected: state.value,
      config: widget.config,
    );
    if (picked != null && mounted) _set(state, picked);
  }

  @override
  Widget build(BuildContext context) {
    final cfg = widget.config;
    return FormField<Degree>(
      initialValue: widget.initialValue,
      enabled: widget.enabled,
      validator: widget.validator,
      onSaved: widget.onSaved,
      autovalidateMode: widget.autovalidateMode,
      builder: (state) {
        final value = state.value;
        final showClear = cfg.allowClear && value != null && widget.enabled;
        final decoration = widget.decoration.copyWith(
          errorText: state.errorText,
          enabled: widget.enabled,
          suffixIcon: showClear
              ? IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: 'Clear',
                  onPressed: () => _set(state, null),
                )
              : widget.decoration.suffixIcon ??
                  const Icon(Icons.arrow_drop_down),
        );
        return InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: widget.enabled ? () => _open(state) : null,
          child: InputDecorator(
            decoration: decoration,
            isEmpty: value == null,
            child: Text(
              value?.displayName ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }
}
