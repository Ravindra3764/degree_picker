## 0.2.0

- Dataset grown from 37 to ~1000 degrees: certificates, vocational, foundation, diplomas, associate, bachelor, honours, PG diplomas, master, integrated master, doctorate, professional, postdoctoral. Asia-first coverage (IN, PK, BD, LK, NP, CN, JP, KR, SEA) plus UK/US/AU/EU.
- New `DegreeLevel` values: `foundation`, `vocational`, `honours`, `integratedMaster`, `postdoctoral`.
- `mbbs` and `bds` moved from `professional` to `bachelor`. All existing ids kept.
- Removed `countries` tags from bundled data (names are global). The `countries` filter still works for custom JSON.
- Dataset version bumped to 2. Added data validation tests.

## 0.1.0

- Initial release: `DegreePickerField`, bottom sheet / dialog modes, search, level filter, custom JSON support.
