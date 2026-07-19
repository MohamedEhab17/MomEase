import os
import re
import json

def to_camel_case(text):
    s = re.sub(r'[^a-zA-Z0-9]', ' ', text)
    words = s.split()
    if not words: return 'emptyKey'
    return words[0].lower() + ''.join(word.capitalize() for word in words[1:])

extracted = {}

for root, _, files in os.walk('lib/feature'):
    for file in files:
        if file.endswith('.dart'):
            path = os.path.join(root, file)
            with open(path, 'r', encoding='utf-8') as f:
                content = f.read()

            def replacer(m):
                full = m.group(0)
                quote = m.group(1)
                text = m.group(2)
                
                if '$' in text or not text.strip():
                    return full
                
                key = to_camel_case(text)
                original_key = key
                counter = 1
                while key in extracted and extracted[key] != text:
                    key = f"{original_key}{counter}"
                    counter += 1
                
                extracted[key] = text
                
                return f"Text(context.trContext(TranslationKeys.{key})"

            new_content = re.sub(r"Text\(\s*(['\"])(.*?)\1", replacer, content)

            if new_content != content:
                new_content = new_content.replace('const Text(', 'Text(')
                
                if 'trContext' in new_content and 'localization_ex.dart' not in new_content:
                    new_content = "import 'package:new_mama/core/extensions/localization_ex.dart';\nimport 'package:new_mama/core/localization/translation_keys.dart';\n" + new_content

                with open(path, 'w', encoding='utf-8') as f:
                    f.write(new_content)

keys_dart = "class TranslationKeys {\n"
for k in extracted.keys():
    keys_dart += f"  static const String {k} = '{k}';\n"
keys_dart += "}\n"

with open('lib/core/localization/translation_keys.dart', 'w', encoding='utf-8') as f:
    f.write(keys_dart)

en_json = {}
ar_json = {}
for k, v in extracted.items():
    en_json[k] = v
    ar_json[k] = v + " (AR)"

with open('assets/translations/en.json', 'w', encoding='utf-8') as f:
    json.dump(en_json, f, indent=2, ensure_ascii=False)

with open('assets/translations/ar.json', 'w', encoding='utf-8') as f:
    json.dump(ar_json, f, indent=2, ensure_ascii=False)

print(f"Extracted {len(extracted)} strings.")
