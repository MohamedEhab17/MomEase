import 'package:genui/genui.dart';

import 'catalog_items/information_card.dart';
import 'catalog_items/mood_check_card.dart';
import 'catalog_items/personal_dashboard.dart';
import 'catalog_items/progress_view.dart';
import 'catalog_items/reflection_card.dart';
import 'catalog_items/topic_carousel.dart';
import 'catalog_items/trailhead.dart';
import 'catalog_items/wellbeing_carousel.dart';

/// Minimal catalog used by the chatbot surface.
///
/// Contains only the components required for stable, fast chat rendering.
/// Prefer this over [postpartumCareCatalog] for the chat GenUiSurface.
final Catalog postpartumChatCatalog = Catalog(
  [
    CoreCatalogItems.button,
    CoreCatalogItems.column,
    CoreCatalogItems.text,
    CoreCatalogItems.row,
    informationCard,
    trailhead,
    moodCheckCard,
  ],
  catalogId: 'newmama.com:postpartum_chat_v1',
);

/// Full catalog used by the rest of the application (dashboards, carousels, etc.).
///
/// Prefer this for any surface outside the chatbot to keep the chat
/// renderer as lightweight as possible.
final Catalog postpartumCareCatalog = Catalog(
  [
    CoreCatalogItems.button,
    CoreCatalogItems.column,
    CoreCatalogItems.text,
    CoreCatalogItems.imageFixedSize,
    CoreCatalogItems.row,
    informationCard,
    moodCheckCard,
    trailhead,
    personalDashboard,
    progressView,
    reflectionCard,
    topicCarousel,
    wellbeingCarousel,
  ],
  catalogId: 'newmama.com:postpartum_v1',
);
