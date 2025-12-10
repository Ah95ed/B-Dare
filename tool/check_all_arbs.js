const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');
const l10nDir = path.join(ROOT, 'lib', 'l10n');

const files = fs.readdirSync(l10nDir).filter(f => f.startsWith('app_') && f.endsWith('.arb'))
const enFile = path.join(l10nDir, 'app_en.arb')
const en = JSON.parse(fs.readFileSync(enFile, 'utf8'))
const enKeys = new Set(Object.keys(en).filter(k => !k.startsWith('@')))

let anyMissing = false
files.forEach(f => {
    const fp = path.join(l10nDir, f)
    const data = JSON.parse(fs.readFileSync(fp, 'utf8'))
    const keys = new Set(Object.keys(data).filter(k => !k.startsWith('@')))
    const missing = [...enKeys].filter(k => !keys.has(k))
    if (missing.length) {
        anyMissing = true
        console.log(`${f} is missing ${missing.length} keys:`)
        missing.forEach(k => console.log(' -', k))
        console.log('')
    } else {
        console.log(`${f} : OK`)
    }
})

if (!anyMissing) console.log('\nAll ARB files contain the same keys as app_en.arb')
