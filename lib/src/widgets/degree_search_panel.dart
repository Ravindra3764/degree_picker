import 'package:flutter/material.dart';

import '../models/degree.dart';
import '../search/degree_searcher.dart';
import 'degree_picker_config.dart';
import 'degree_picker_style.dart';

/// The searchable list used inside the sheet and dialog. Exposed so you can
/// embed it in your own page or layout.
class DegreeSearchPanel extends StatefulWidget {
  /// Creates the panel.
  const DegreeSearchPanel({
    super.key,
    required this.degrees,
    required this.onSelected,
    this.selected,
    this.config = const DegreePickerConfig(),
    this.scrollController,
  });

  /// Degrees to show (already filtered).
  final List<Degree> degrees;

  /// Called when the user picks a degree.
  final ValueChanged<Degree> onSelected;

  /// Currently selected degree.
  final Degree? selected;

  /// Presentation settings.
  final DegreePickerConfig config;

  /// Optional scroll controller for the list.
  final ScrollController? scrollController;

  @override
  State<DegreeSearchPanel> createState() => _DegreeSearchPanelState();
}

class _DegreeSearchPanelState extends State<DegreeSearchPanel> {
  late DegreeSearcher _searcher;
  late List<DegreeLevel> _levels;
  final _controller = TextEditingController();
  String _query = '';
  DegreeLevel? _level;
  late List<Degree> _results;

  @override
  void initState() {
    super.initState();
    _index();
  }

  @override
  void didUpdateWidget(covariant DegreeSearchPanel old) {
    super.didUpdateWidget(old);
    if (old.degrees != widget.degrees) {
      _index();
    }
  }

  void _index() {
    _searcher = DegreeSearcher(widget.degrees);
    _levels = widget.degrees.map((d) => d.level).toSet().toList()
      ..sort((a, b) => a.index.compareTo(b.index));
    _results = _run();
  }

  List<Degree> _run() {
    final r = _searcher.search(_query);
    return _level == null
        ? r
        : r.where((d) => d.level == _level).toList(growable: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _subtitle(Degree d) => [
        if (d.shortName != null) d.shortName!,
        d.level.label,
        if (d.field != null) d.field!,
      ].join(' · ');

  InputDecoration _searchDecoration(
    DegreePickerStyle st,
    DegreePickerConfig cfg,
  ) {
    final base = st.searchDecoration ??
        InputDecoration(
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        );
    return base.copyWith(
      hintText: base.hintText ?? cfg.searchHint,
      prefixIcon: base.prefixIcon ?? const Icon(Icons.search),
      suffixIcon: base.suffixIcon ??
          (_query.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: cfg.clearTooltip,
                  onPressed: () => setState(() {
                    _controller.clear();
                    _query = '';
                    _results = _run();
                  }),
                )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cfg = widget.config;
    final st = DegreePickerStyle.resolve(context, cfg.style);
    final q = _query.trim();
    final normalizedQ = DegreeSearcher.normalize(q);
    final showCustom = cfg.allowCustom &&
        q.isNotEmpty &&
        !_results.any((d) => DegreeSearcher.normalize(d.name) == normalizedQ);
    final offset = showCustom ? 1 : 0;
    final count = _results.length + offset;

    return Column(
      children: [
        Padding(
          padding: st.titlePadding ?? const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              cfg.title,
              style: st.titleStyle ?? theme.textTheme.titleMedium,
            ),
          ),
        ),
        Padding(
          padding:
              st.searchPadding ?? const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _controller,
            autofocus: cfg.autofocusSearch,
            textInputAction: TextInputAction.search,
            style: st.searchTextStyle,
            onChanged: (v) => setState(() {
              _query = v;
              _results = _run();
            }),
            decoration: _searchDecoration(st, cfg),
          ),
        ),
        if (cfg.showLevelFilter && _levels.length > 1)
          SizedBox(
            height: 52,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: st.chipsPadding ??
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _levels.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final level = i == 0 ? null : _levels[i - 1];
                final chip = ChoiceChip(
                  label: Text(level?.label ?? 'All'),
                  selected: _level == level,
                  onSelected: (_) => setState(() {
                    _level = level;
                    _results = _run();
                  }),
                );
                final chipTheme = st.chipTheme;
                return chipTheme == null
                    ? chip
                    : ChipTheme(data: chipTheme, child: chip);
              },
            ),
          ),
        const SizedBox(height: 4),
        Expanded(
          child: count == 0
              ? Center(child: Text(cfg.emptyText, style: st.emptyTextStyle))
              : ListView.builder(
                  controller: widget.scrollController,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: count,
                  itemBuilder: (context, i) {
                    if (showCustom && i == 0) {
                      return ListTile(
                        contentPadding: st.itemPadding,
                        leading: st.customIcon ??
                            const Icon(Icons.add_circle_outline),
                        title: Text(
                          '${cfg.customOptionPrefix} "$q"',
                          style: st.itemTitleStyle,
                        ),
                        onTap: () => widget.onSelected(Degree.custom(q)),
                      );
                    }
                    final degree = _results[i - offset];
                    final selected = degree == widget.selected;
                    final builder = cfg.itemBuilder;
                    if (builder != null) {
                      return InkWell(
                        onTap: () => widget.onSelected(degree),
                        child: builder(context, degree, selected),
                      );
                    }
                    final tile = ListTile(
                      contentPadding: st.itemPadding,
                      title: Text(degree.name, style: st.itemTitleStyle),
                      subtitle: Text(
                        _subtitle(degree),
                        style: st.itemSubtitleStyle,
                      ),
                      selected: selected,
                      selectedColor: st.selectedColor,
                      selectedTileColor: st.selectedTileColor,
                      trailing: selected
                          ? st.selectedIcon ?? const Icon(Icons.check)
                          : null,
                      onTap: () => widget.onSelected(degree),
                    );
                    if (st.showDividers != true) return tile;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        tile,
                        Divider(height: 1, color: st.dividerColor),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }
}
