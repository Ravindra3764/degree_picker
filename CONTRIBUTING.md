# Contributing degrees

Data lives in `assets/degrees.json`. One degree per line.

## Rules

- `id`: unique, lowercase slug (`a-z`, `0-9`, `-`). **Never rename an existing id.**
- `name`: full official English name.
- `short`: common abbreviation, optional.
- `level`: one of `certificate`, `vocational`, `foundation`, `diploma`, `associate`, `bachelor`, `honours`, `postgraduateDiploma`, `master`, `integratedMaster`, `doctorate`, `professional`, `postdoctoral`, `other`.
- `field`: broad field (Engineering, Science, Business, ...), optional.
- `aliases`: alternate spellings used by search. Avoid aliases shared with another degree (e.g. `MS`).
- Only add commonly used degrees. No country tags.

## Check

```
flutter test
```

Validates unique ids, known levels, id format and that v1 ids still exist.
