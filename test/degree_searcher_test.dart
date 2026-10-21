import 'dart:convert';
import 'dart:io';

import 'package:degree_picker/degree_picker.dart';
import 'package:flutter_test/flutter_test.dart';

const _degrees = [
  Degree(
    id: 'btech',
    name: 'Bachelor of Technology',
    shortName: 'B.Tech',
    level: DegreeLevel.bachelor,
    aliases: ['BTech'],
  ),
  Degree(
    id: 'mba',
    name: 'Master of Business Administration',
    shortName: 'MBA',
    level: DegreeLevel.master,
  ),
  Degree(
    id: 'msc',
    name: 'Master of Science',
    shortName: 'M.Sc',
    level: DegreeLevel.master,
    field: 'Science',
  ),
];

void main() {
  final searcher = DegreeSearcher(_degrees);

  test('exact short name ranks first', () {
    expect(searcher.search('mba').first.id, 'mba');
  });

  test('ignores case and punctuation', () {
    expect(searcher.search('btech').map((d) => d.id), contains('btech'));
    expect(searcher.search('B.TECH').map((d) => d.id), contains('btech'));
    expect(searcher.search('m sc').map((d) => d.id), contains('msc'));
  });

  test('empty query returns everything, limit is applied', () {
    expect(searcher.search('').length, 3);
    expect(searcher.search('', limit: 2).length, 2);
  });

  test('no match returns empty', () {
    expect(searcher.search('zzzz'), isEmpty);
  });

  test('model json round trip', () {
    final d = Degree.fromJson(_degrees.first.toJson());
    expect(d, _degrees.first);
    expect(d.displayName, 'Bachelor of Technology (B.Tech)');
  });

  test('bundled degrees.json is valid with unique ids', () {
    final raw = File('assets/degrees.json').readAsStringSync();
    final ids = [
      for (final m in (jsonDecode(raw) as Map)['degrees'] as List)
        (m as Map)['id'] as String,
    ];
    expect(ids.toSet().length, ids.length, reason: 'duplicate ids');
    expect(parseDegrees(raw).length, ids.length);
  });

  test('config filters by level and country', () {
    const all = [
      Degree(
          id: 'a', name: 'A', level: DegreeLevel.bachelor, countries: ['IN']),
      Degree(
          id: 'b', name: 'B', level: DegreeLevel.bachelor, countries: ['US']),
      Degree(id: 'c', name: 'C', level: DegreeLevel.master),
    ];
    const cfg = DegreePickerConfig(
      levels: {DegreeLevel.bachelor},
      countries: {'in'},
    );
    expect(cfg.filter(all).map((d) => d.id), ['a']);
  });
}
