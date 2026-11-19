## 0.1.1

- Silence the `package:flutter/material.dart` deprecation reported on Flutter 3.47+ (pub.dev static analysis). Minimum Flutter stays 3.22; migration to `package:material_ui` will come with a future SDK bump.

## 0.1.0

- Initial release: `DegreePickerField`, bottom sheet / dialog modes, level filter chips, custom entry, custom JSON support.
- Bundled dataset of ~1000 degrees across 13 levels (certificate, vocational, foundation, diploma, associate, bachelor, honours, postgraduate diploma, master, integrated master, doctorate, professional, postdoctoral). Asia-first coverage plus UK/US/AU/EU.
- Styling: `DegreePickerStyle` (sheet/dialog, title, search box, rows, chips), app-wide `DegreePickerTheme`, `DegreePickerField.textStyle`, `DegreePickerConfig.clearTooltip`.
- Ranked search over names, abbreviations and aliases, ignoring case and punctuation.
