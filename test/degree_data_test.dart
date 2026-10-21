import 'dart:convert';
import 'dart:io';

import 'package:degree_picker/degree_picker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final raw = File('assets/degrees.json').readAsStringSync();
  final json = jsonDecode(raw) as Map<String, dynamic>;
  final entries = (json['degrees'] as List).cast<Map<String, dynamic>>();
  final degrees = parseDegrees(raw);
  final levelNames = DegreeLevel.values.map((l) => l.name).toSet();

  test('dataset is version 2 and non-trivial', () {
    expect(json['version'], 2);
    expect(degrees.length, greaterThan(500));
  });

  test('ids are unique, lowercase slugs', () {
    final ids = entries.map((e) => e['id'] as String).toList();
    expect(ids.toSet().length, ids.length, reason: 'duplicate ids');
    for (final id in ids) {
      expect(id, matches(RegExp(r'^[a-z0-9]+(-[a-z0-9]+)*$')), reason: id);
    }
  });

  test('every entry has name and a known level', () {
    for (final e in entries) {
      expect((e['name'] as String).trim(), isNotEmpty, reason: '${e['id']}');
      expect(levelNames, contains(e['level']), reason: '${e['id']}');
    }
  });

  test('every level has at least one degree', () {
    final used = degrees.map((d) => d.level).toSet();
    expect(used,
        containsAll(DegreeLevel.values.where((l) => l != DegreeLevel.other)));
  });

  test('no country tags (global dataset)', () {
    expect(degrees.where((d) => d.countries.isNotEmpty), isEmpty);
  });

  test('ids from v1 are preserved', () {
    const v1 = [
      'btech',
      'be',
      'bsc',
      'ba',
      'bcom',
      'bba',
      'bca',
      'bfa',
      'barch',
      'bpharm',
      'bed',
      'llb',
      'mbbs',
      'bds',
      'mtech',
      'me',
      'msc',
      'ma',
      'mcom',
      'mba',
      'mca',
      'mfa',
      'mph',
      'med',
      'llm',
      'mpharm',
      'mphil',
      'pgdm',
      'phd',
      'edd',
      'dba',
      'md',
      'jd',
      'aa',
      'as',
      'diploma-engineering',
      'certificate-general',
    ];
    final ids = degrees.map((d) => d.id).toSet();
    expect(ids, containsAll(v1));
  });

  group('search on real data', () {
    final searcher = DegreeSearcher(degrees);
    String top(String q) => searcher.search(q).first.id;

    test('common abbreviations resolve to the right degree', () {
      expect(top('mba'), 'mba');
      expect(top('b.tech'), 'btech');
      expect(top('phd'), 'phd');
      expect(top('mbbs'), 'mbbs');
      expect(top('mca'), 'mca');
      expect(top('pgdm'), 'pgdm');
    });

    test('aliases work', () {
      expect(searcher.search('ph.d').map((d) => d.id), contains('phd'));
      expect(searcher.search('polytechnic').map((d) => d.id),
          contains('diploma-engineering'));
    });

    test('honours is its own level', () {
      final hons = degrees.where((d) => d.level == DegreeLevel.honours);
      expect(hons, isNotEmpty);
      expect(hons.map((d) => d.name), contains('Bachelor of Arts (Honours)'));
    });
  });
}
