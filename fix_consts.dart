import 'dart:io';

void main() {
  final file = File('analyze_results_utf8.txt');
  final lines = file.readAsLinesSync();

  for (final line in lines) {
    if (line.contains('invalid_constant') ||
        line.contains('const_eval_method_invocation') ||
        line.contains('non_constant_default_value')) {
      // Example line: error - feature\baby_profile_setup\presentation\widgets\all_set_up.dart:36:20 - Invalid constant value. - invalid_constant
      final parts = line.split(' - ');
      if (parts.length >= 3) {
        final locationPart = parts[1]
            .trim(); // e.g. feature\baby_profile_setup\presentation\widgets\all_set_up.dart:36:20
        final locParts = locationPart.split(':');
        if (locParts.length >= 2) {
          final filePath = 'lib/' + locParts[0].replaceAll('\\', '/');

          if (filePath.contains('app_theme.dart') ||
              filePath.contains('app_styles.dart')) {
            continue;
          }

          final lineNum = int.tryParse(locParts[1]);

          if (lineNum != null) {
            final f = File(filePath);
            if (f.existsSync()) {
              final fileLines = f.readAsLinesSync();
              final targetIdx = lineNum - 1;

              if (targetIdx >= 0 && targetIdx < fileLines.length) {
                // Search backwards for the nearest 'const' and remove it
                bool found = false;
                for (int i = targetIdx; i >= 0 && i >= targetIdx - 5; i--) {
                  if (fileLines[i].contains('const ')) {
                    fileLines[i] = fileLines[i].replaceFirst(
                      RegExp(r'\bconst\s+'),
                      '',
                    );
                    found = true;
                    break;
                  }
                }

                if (found) {
                  f.writeAsStringSync(fileLines.join('\n') + '\n');
                  print('Fixed const in $filePath:$lineNum');
                }
              }
            }
          }
        }
      }
    }
  }
}
