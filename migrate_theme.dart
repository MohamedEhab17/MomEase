import 'dart:io';

void main(List<String> args) async {
  final Map<String, String> colorMap = {
    'AppColors.primaryDark':
        'Theme.of(context).extension<AppThemeExtension>()!.primaryDark',
    'AppColors.primary': 'Theme.of(context).colorScheme.primary',
    'AppColors.primaryLighter':
        'Theme.of(context).extension<AppThemeExtension>()!.primaryLighter',
    'AppColors.primaryAccent':
        'Theme.of(context).extension<AppThemeExtension>()!.primaryAccent',
    'AppColors.primaryTint':
        'Theme.of(context).extension<AppThemeExtension>()!.primaryTint',
    'AppColors.primaryExtraLight':
        'Theme.of(context).extension<AppThemeExtension>()!.primaryExtraLight',
    'AppColors.primaryBackground':
        'Theme.of(context).extension<AppThemeExtension>()!.primaryBackground',
    'AppColors.primaryLight':
        'Theme.of(context).extension<AppThemeExtension>()!.primaryLight',
    'AppColors.greyPrimary':
        'Theme.of(context).extension<AppThemeExtension>()!.greyPrimary',
    'AppColors.greyLight':
        'Theme.of(context).extension<AppThemeExtension>()!.greyLight',
    'AppColors.greyExtraLight':
        'Theme.of(context).extension<AppThemeExtension>()!.greyExtraLight',
    'AppColors.greyMedium':
        'Theme.of(context).extension<AppThemeExtension>()!.greyMedium',
    'AppColors.mentionBlue':
        'Theme.of(context).extension<AppThemeExtension>()!.mentionBlue',
    'AppColors.lighterBorder':
        'Theme.of(context).extension<AppThemeExtension>()!.lighterBorder',
    'AppColors.accent': 'Theme.of(context).colorScheme.secondary',
    'AppColors.accentSoft': 'Theme.of(context).colorScheme.secondaryContainer',
    'AppColors.lightBackground': 'Theme.of(context).colorScheme.surface',
    'AppColors.backgroundPink':
        'Theme.of(context).extension<AppThemeExtension>()!.backgroundPink',
    'AppColors.darkBackground': 'Theme.of(context).colorScheme.surface',
    'AppColors.backgroundGreen':
        'Theme.of(context).extension<AppThemeExtension>()!.backgroundGreen',
    'AppColors.backgroundBlue':
        'Theme.of(context).extension<AppThemeExtension>()!.backgroundBlue',
    'AppColors.backgroundBlueDarker':
        'Theme.of(context).extension<AppThemeExtension>()!.backgroundBlueDarker',
    'AppColors.lightTextPrimary': 'Theme.of(context).colorScheme.onSurface',
    'AppColors.lightTextSecondary':
        'Theme.of(context).colorScheme.onSurfaceVariant',
    'AppColors.lightTextDisabled':
        'Theme.of(context).extension<AppThemeExtension>()!.lightTextDisabled',
    'AppColors.textDisabledLighter':
        'Theme.of(context).extension<AppThemeExtension>()!.textDisabledLighter',
    'AppColors.greenText':
        'Theme.of(context).extension<AppThemeExtension>()!.greenText',
    'AppColors.darkTextPrimary': 'Theme.of(context).colorScheme.onSurface',
    'AppColors.darkTextSecondary':
        'Theme.of(context).colorScheme.onSurfaceVariant',
  };

  final Map<String, String> styleMap = {
    'AppStyles.styleScriptMT32': 'Theme.of(context).textTheme.displayLarge!',
    'AppStyles.styleInter32': 'Theme.of(context).textTheme.displayMedium!',
    'AppStyles.styleInter24': 'Theme.of(context).textTheme.displaySmall!',
    'AppStyles.styleRoboto24': 'Theme.of(context).textTheme.headlineLarge!',
    'AppStyles.styleInter20': 'Theme.of(context).textTheme.headlineMedium!',
    'AppStyles.styleRoboto20': 'Theme.of(context).textTheme.headlineSmall!',
    'AppStyles.styleInter16': 'Theme.of(context).textTheme.titleLarge!',
    'AppStyles.styleRoboto16': 'Theme.of(context).textTheme.titleMedium!',
    'AppStyles.styleInter14': 'Theme.of(context).textTheme.titleSmall!',
    'AppStyles.styleInter12': 'Theme.of(context).textTheme.bodyLarge!',
    'AppStyles.styleRoboto12': 'Theme.of(context).textTheme.bodyMedium!',
    'AppStyles.styleInter10': 'Theme.of(context).textTheme.bodySmall!',
    'AppStyles.styleInter8': 'Theme.of(context).textTheme.labelLarge!',
  };

  if (args.isEmpty) {
    print('Please provide a directory path, e.g., lib/feature/home');
    return;
  }

  final directoryPath = args[0];
  final directory = Directory(directoryPath);

  if (!directory.existsSync()) {
    print('Directory does not exist!');
    return;
  }

  final files = directory
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  // Exclude app_section since it's already migrated
  final targetFiles = files
      .where((f) => !f.path.contains('app_section'))
      .toList();

  int totalReplacements = 0;

  for (final file in targetFiles) {
    String originalContent = file.readAsStringSync();
    String newContent = originalContent;
    bool modified = false;

    final colorKeys = colorMap.keys.toList()
      ..sort((a, b) => b.length.compareTo(a.length));
    for (final key in colorKeys) {
      if (newContent.contains(key)) {
        newContent = newContent.replaceAll(key, colorMap[key]!);
        modified = true;
      }
    }

    final styleKeys = styleMap.keys.toList()
      ..sort((a, b) => b.length.compareTo(a.length));
    for (final key in styleKeys) {
      if (newContent.contains(key)) {
        newContent = newContent.replaceAll(key, styleMap[key]!);
        modified = true;
      }
    }

    if (modified) {
      // Remove unused imports
      newContent = newContent.replaceAll(
        "import 'package:new_mama/core/constants/app_colors.dart';\n",
        "",
      );
      newContent = newContent.replaceAll(
        "import 'package:new_mama/core/utils/app_styles.dart';\n",
        "",
      );

      // Add AppThemeExtension if it's used
      if (newContent.contains('AppThemeExtension') &&
          !newContent.contains(
            "import 'package:new_mama/core/theme/app_theme_extension.dart';",
          )) {
        // Insert import at top of file, below other imports or at 0
        final importLine =
            "import 'package:new_mama/core/theme/app_theme_extension.dart';\n";

        // Find the last import line
        int insertPos = 0;
        final lines = newContent.split('\n');
        for (int i = 0; i < lines.length; i++) {
          if (lines[i].startsWith('import ')) {
            insertPos = newContent.indexOf(lines[i]) + lines[i].length + 1;
          }
        }

        newContent =
            newContent.substring(0, insertPos) +
            importLine +
            newContent.substring(insertPos);
      }

      if (newContent.contains('Theme.of(context)') &&
          !newContent.contains("import 'package:flutter/material.dart';")) {
        final importLine = "import 'package:flutter/material.dart';\n";
        int insertPos = 0;
        final lines = newContent.split('\n');
        for (int i = 0; i < lines.length; i++) {
          if (lines[i].startsWith('import ')) {
            insertPos = newContent.indexOf(lines[i]) + lines[i].length + 1;
          }
        }
        newContent =
            newContent.substring(0, insertPos) +
            importLine +
            newContent.substring(insertPos);
      }

      file.writeAsStringSync(newContent);
      print('Migrated: ${file.path}');
      totalReplacements++;
    }
  }

  print('Finished replacing in $totalReplacements files.');
}
