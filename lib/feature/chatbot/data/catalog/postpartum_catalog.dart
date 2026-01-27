import 'package:genui/genui.dart';

import 'catalog_items/information_card.dart';
import 'catalog_items/mood_check_card.dart';
import 'catalog_items/trailhead.dart';

/// Minimal catalog for postpartum care chatbot.
/// Core + InformationCard + MoodCheckCard + Trailhead to keep schema small,
/// speed up inference, and ensure UI tool use (surfaceUpdate + beginRendering).
final Catalog postpartumCareCatalog = Catalog([
  CoreCatalogItems.button,
  CoreCatalogItems.column,
  CoreCatalogItems.text,
  CoreCatalogItems.imageFixedSize,
  CoreCatalogItems.row,
  informationCard,
  moodCheckCard,
  trailhead,
], catalogId: 'newmama.com:postpartum_v1');
