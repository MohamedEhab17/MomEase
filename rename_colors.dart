import 'dart:developer';
import 'dart:io';

void main() async {
  final Map<String, String> renames = {
    'primaryHard': 'primaryDark',
    'primarySoft': 'primaryLighter', 
    'primarySoft5': 'primaryLight',
    'primarySoft3': 'primaryExtraLight', 
    'primarySoft2': 'primaryTint', 
    'primarySoft4': 'primaryBackground',

    'secondary': 'greyPrimary', 
    'secondarySoft3': 'greyMedium',
    'secondarySoft': 'greyLight', 
    'secondarySoft2': 'greyExtraLight', 

    'lightBackground2': 'backgroundPink',
    'lightGreenBackground': 'backgroundGreen',

    'lightTextDisabled2': 'textDisabledLighter',
  };

  final libDir = Directory('e:/graduation/app/MomEase/lib');
  final files = libDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'));

  int totalReplaces = 0;

  for (final file in files) {
    String content = await file.readAsString();
    bool changed = false;

    // Sort renames by length descending to avoid partial matches (e.g. primarySoft3 before primarySoft)
    final keys = renames.keys.toList()
      ..sort((a, b) => b.length.compareTo(a.length));

    for (final oldName in keys) {
      final newName = renames[oldName]!;
      // Use word boundary to ensure exact match
      final regex = RegExp('\\b$oldName\\b');
      if (regex.hasMatch(content)) {
        content = content.replaceAll(regex, newName);
        changed = true;
      }
    }

    if (changed) {
      await file.writeAsString(content);
      log('Updated \${file.path}');
      totalReplaces++;
    }
  }

  log('Done. Updated \$totalReplaces files.');
}
