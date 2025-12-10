# Culture Pack Pipeline (Draft)

This document summarizes how to prepare localized “Culture Link Packs” for Mystery Link. The loader currently expects a simple CSV format that can be exported from Google Sheets or Notion.

## CSV format

Each line describes one multi-hop chain:

```
start,end,path_nodes,locale,category
Iraq,Date Palm,"Agriculture;Oasis;Trade Routes",ar,"History & Heritage"
Baghdad,House of Wisdom,"Scholars;Knowledge;Innovation",ar,
```

- **start / end**: localized labels for A and Z.
- **path_nodes**: `;` separated intermediate nodes (3–10 recommended).
- **locale**: `ar`, `en`, etc. Defaults to `ar` if empty.
- **category** (optional): theme label (History, Culture, Science…).

Comments and empty lines are ignored (lines starting with `#`).

## Loader usage

```dart
final loader = CulturePackLoader();
final entries =
    await loader.loadFromAsset('assets/data/culture_packs/iraq_pack.csv');
```

`entries` returns `CulturePackEntry` objects; integrate them with puzzle generation logic (e.g., convert to `Puzzle` or queue for AI validation).

## Next steps

1. **Validation**: add automated checks (duplicate nodes, minimum length) before importing.
2. **Tooling**: provide a sheet template and scripts to export to `/assets/data/culture_packs`.
3. **Moderation**: review submissions for historical accuracy and tone.
