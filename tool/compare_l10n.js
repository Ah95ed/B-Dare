const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');
const enFile = path.join(ROOT, 'lib', 'l10n', 'app_en.arb');
const arFile = path.join(ROOT, 'lib', 'l10n', 'app_ar.arb');

function load(fp) {
    return JSON.parse(fs.readFileSync(fp, 'utf8'))
}

const en = load(enFile)
const ar = load(arFile)

function keys(obj) {
    return Object.keys(obj).filter(k => !k.startsWith('@'))
}

const enKeys = new Set(keys(en))
const arKeys = new Set(keys(ar))

const onlyEn = [...enKeys].filter(k => !arKeys.has(k)).sort()
const onlyAr = [...arKeys].filter(k => !enKeys.has(k)).sort()

console.log('Keys present only in EN (missing in AR):')
onlyEn.forEach(k => console.log('-', k))
console.log('\nKeys present only in AR (missing in EN):')
onlyAr.forEach(k => console.log('-', k))
console.log('\nCounts:')
console.log('EN total:', enKeys.size)
console.log('AR total:', arKeys.size)
console.log('Only EN:', onlyEn.length)
console.log('Only AR:', onlyAr.length)
