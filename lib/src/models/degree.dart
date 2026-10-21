import 'package:flutter/foundation.dart';

/// Academic level of a [Degree].
enum DegreeLevel {
  /// Certificate programs.
  certificate('Certificate'),

  /// Diploma programs.
  diploma('Diploma'),

  /// Associate degrees.
  associate('Associate'),

  /// Foundation / bridging programs.
  foundation('Foundation'),

  /// Vocational and technical qualifications.
  vocational('Vocational'),

  /// Bachelor degrees.
  bachelor('Bachelor'),

  /// Bachelor (Honours) degrees.
  honours('Honours'),

  /// Postgraduate diplomas / certificates.
  postgraduateDiploma('Postgraduate Diploma'),

  /// Master degrees.
  master('Master'),

  /// Combined bachelor + master programs (MEng, MSci, dual degrees).
  integratedMaster('Integrated Master'),

  /// Doctorates (PhD, EdD, ...).
  doctorate('Doctorate'),

  /// Post-doctoral qualifications (Habilitation, D.Sc, ...).
  postdoctoral('Postdoctoral'),

  /// Professional degrees (MD, JD, ...).
  professional('Professional'),

  /// Anything else.
  other('Other');

  const DegreeLevel(this.label);

  /// Human readable label.
  final String label;

  /// Parses the JSON value (the enum name). Unknown values map to [other].
  static DegreeLevel parse(String? value) {
    for (final level in values) {
      if (level.name == value) return level;
    }
    return DegreeLevel.other;
  }
}

/// A single academic degree.
@immutable
class Degree {
  /// Creates a degree.
  const Degree({
    required this.id,
    required this.name,
    this.shortName,
    this.level = DegreeLevel.other,
    this.field,
    this.aliases = const [],
    this.countries = const [],
  });

  /// Creates a user-typed degree that is not part of the dataset.
  factory Degree.custom(String name) {
    final trimmed = name.trim();
    return Degree(id: '$customPrefix${trimmed.toLowerCase()}', name: trimmed);
  }

  /// Builds a degree from a JSON map.
  factory Degree.fromJson(Map<String, dynamic> json) => Degree(
        id: json['id'] as String,
        name: json['name'] as String,
        shortName: json['short'] as String?,
        level: DegreeLevel.parse(json['level'] as String?),
        field: json['field'] as String?,
        aliases: _strings(json['aliases']),
        countries: _strings(json['countries']),
      );

  /// Prefix of ids created through [Degree.custom].
  static const customPrefix = 'custom:';

  /// Stable unique id, e.g. `btech`.
  final String id;

  /// Full name, e.g. `Bachelor of Technology`.
  final String name;

  /// Abbreviation, e.g. `B.Tech`.
  final String? shortName;

  /// Academic level.
  final DegreeLevel level;

  /// Broad field, e.g. `Engineering`.
  final String? field;

  /// Alternative spellings / names used for search.
  final List<String> aliases;

  /// ISO 3166-1 alpha-2 codes where this degree is common. Empty = global.
  final List<String> countries;

  /// `true` when created by the user rather than the dataset.
  bool get isCustom => id.startsWith(customPrefix);

  /// Name plus abbreviation, e.g. `Bachelor of Technology (B.Tech)`.
  String get displayName => shortName == null ? name : '$name ($shortName)';

  /// Serializes to JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (shortName != null) 'short': shortName,
        'level': level.name,
        if (field != null) 'field': field,
        if (aliases.isNotEmpty) 'aliases': aliases,
        if (countries.isNotEmpty) 'countries': countries,
      };

  static List<String> _strings(Object? value) => value is List
      ? value.whereType<String>().toList(growable: false)
      : const [];

  @override
  bool operator ==(Object other) => other is Degree && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Degree($id)';
}
