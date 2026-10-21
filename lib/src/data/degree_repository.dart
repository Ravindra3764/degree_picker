import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/degree.dart';

/// Parses a JSON string into degrees. Accepts either
/// `{"degrees": [...]}` or a bare array. Duplicate ids are dropped.
///
/// Top-level so it can run in an isolate via [compute].
List<Degree> parseDegrees(String raw) {
  final decoded = jsonDecode(raw);
  final list = decoded is Map<String, dynamic> ? decoded['degrees'] : decoded;
  if (list is! List) {
    throw const FormatException('Expected a "degrees" array.');
  }
  final seen = <String>{};
  return [
    for (final item in list)
      if (item is Map<String, dynamic>) Degree.fromJson(item),
  ].where((d) => seen.add(d.id)).toList(growable: false);
}

/// Loads and caches degrees from an asset bundle.
class DegreeRepository {
  /// Creates a repository. Pass your own [assetPath] to use a custom JSON.
  DegreeRepository({this.assetPath = defaultAssetPath, AssetBundle? bundle})
      : _bundle = bundle ?? rootBundle;

  /// Path of the dataset bundled with this package.
  static const defaultAssetPath = 'packages/degree_picker/assets/degrees.json';

  /// Shared repository using the bundled dataset.
  static final DegreeRepository instance = DegreeRepository();

  /// Asset path this repository reads.
  final String assetPath;

  final AssetBundle _bundle;
  Future<List<Degree>>? _cache;

  /// Loads degrees once; later calls return the cached future.
  Future<List<Degree>> load() => _cache ??= _load();

  Future<List<Degree>> _load() async {
    try {
      final raw = await _bundle.loadString(assetPath);
      return await compute(parseDegrees, raw);
    } catch (_) {
      _cache = null; // allow retry
      rethrow;
    }
  }
}
