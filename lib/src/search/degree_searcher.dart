import '../models/degree.dart';

/// Fast in-memory ranked search over degrees.
///
/// Matches name, short name and aliases, ignoring case and punctuation
/// (`btech`, `b.tech` and `B Tech` all find "B.Tech").
class DegreeSearcher {
  /// Builds the index once; reuse the instance across keystrokes.
  DegreeSearcher(Iterable<Degree> degrees)
      : _entries = degrees.map(_Entry.new).toList(growable: false);

  final List<_Entry> _entries;

  static final _nonWord = RegExp(r'[^\p{L}\p{N}]+', unicode: true);

  /// Lowercases and collapses punctuation to single spaces.
  static String normalize(String input) =>
      input.toLowerCase().replaceAll(_nonWord, ' ').trim();

  /// Returns degrees ranked by relevance. Empty query returns everything.
  List<Degree> search(String query, {int? limit}) {
    final q = normalize(query);
    List<Degree> result;
    if (q.isEmpty) {
      result = _entries.map((e) => e.degree).toList(growable: false);
    } else {
      final scored = <(Degree, int)>[];
      for (final e in _entries) {
        final s = e.score(q);
        if (s > 0) scored.add((e.degree, s));
      }
      scored.sort((a, b) {
        final c = b.$2.compareTo(a.$2);
        return c != 0 ? c : a.$1.name.compareTo(b.$1.name);
      });
      result = scored.map((e) => e.$1).toList(growable: false);
    }
    return limit == null || result.length <= limit
        ? result
        : result.sublist(0, limit);
  }
}

class _Entry {
  _Entry(this.degree)
      : keys = [
          degree.name,
          if (degree.shortName != null) degree.shortName!,
          ...degree.aliases,
        ]
            .map(DegreeSearcher.normalize)
            .where((k) => k.isNotEmpty)
            .toList(growable: false),
        field = DegreeSearcher.normalize(degree.field ?? '');

  final Degree degree;
  final List<String> keys;
  final String field;

  int score(String q) {
    final qc = q.replaceAll(' ', '');
    var best = 0;
    for (final k in keys) {
      final kc = k.replaceAll(' ', '');
      int s = 0;
      if (k == q) {
        s = 100;
      } else if (kc == qc) {
        s = 95;
      } else if (k.startsWith(q)) {
        s = 80;
      } else if (kc.startsWith(qc)) {
        s = 75;
      } else if (k.split(' ').any((w) => w.startsWith(q))) {
        s = 60;
      } else if (k.contains(q)) {
        s = 40;
      } else if (kc.contains(qc)) {
        s = 35;
      }
      if (s > best) best = s;
    }
    if (best == 0) {
      final hay = '${keys.join(' ')} $field';
      if (q.split(' ').every(hay.contains)) {
        best = 30;
      } else if (field.contains(q)) {
        best = 20;
      }
    }
    return best;
  }
}
