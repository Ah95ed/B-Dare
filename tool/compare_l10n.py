import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
en_file = ROOT / 'lib' / 'l10n' / 'app_en.arb'
ar_file = ROOT / 'lib' / 'l10n' / 'app_ar.arb'

def load(fp):
    return json.loads(fp.read_text(encoding='utf-8'))

en = load(en_file)
ar = load(ar_file)

def keys(d):
    return set(k for k in d.keys() if not k.startswith('@'))

en_keys = keys(en)
ar_keys = keys(ar)

only_en = sorted(en_keys - ar_keys)
only_ar = sorted(ar_keys - en_keys)

print('Keys present only in EN (missing in AR):')
for k in only_en:
    print('-', k)

print('\nKeys present only in AR (missing in EN):')
for k in only_ar:
    print('-', k)

print('\nCounts:')
print('EN total:', len(en_keys))
print('AR total:', len(ar_keys))
print('Only EN:', len(only_en))
print('Only AR:', len(only_ar))
