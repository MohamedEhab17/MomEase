import 'package:flutter/widgets.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/feature/articles/data/models/article_model.dart';
import 'package:new_mama/feature/community/data/models/post_model.dart';
import 'package:new_mama/feature/profile/data/models/profile_model.dart';

class ProfileDummyData {
  static ProfileModel getDummyProfile(BuildContext context) {
    return ProfileModel(
      id: "u123",
      name: "Ana Soso",
      avatarUrl: "https://i.pravatar.cc/150?img=5",
      subtitle: "Mom of baby Adam",
      journey: ParentingJourney(
        lastMoodEmoji: "😌",
        lastMoodStatus: "Calm",
        lastMoodColor: context.ext.colors.greenText,
        depressionTestStatus: "Completed",
        depressionTestColor: context.ext.colors.mentionBlue,
        babyTrackingStatus: "Updated today",
        babyTrackingColor: context.ext.colors.primaryDark,
      ),
      babyProfile: BabyProfile(
        name: "Adam",
        ageString: "8 months old",
        avatarUrl: "https://i.pravatar.cc/150?img=12",
      ),
      recentPosts: [
        PostModel(
          id: "p1",
          userName: "Ana Soso",
          userImage: "https://i.pravatar.cc/150?img=5",
          text:
              "Finally found a routine that works for Adam's nap time. Feeling so relieved!",
          images: ["https://picsum.photos/seed/leaf/400/300"],
          likes: 12,
          comments: 5,
          saves: 0,
          isLiked: true,
          isSaved: false,
        ),
        PostModel(
          id: "p2",
          userName: "Ana Soso",
          userImage: "https://i.pravatar.cc/150?img=5",
          text:
              "Any tips for healthy postpartum snacks that are quick to make?",
          images: [],
          likes: 8,
          comments: 14,
          saves: 0,
          isLiked: false,
          isSaved: false,
        ),
      ],
      savedArticles: [
        ArticleModel(
          id: "a1",
          category: "NUTRITION",
          title: "7 useful meals for postpartum moms",
          authorName: "Dr. Jane",
          date: "Oct 12",
          readTime: "5 min",
          imageUrl: "https://picsum.photos/seed/nutrition/300/200",
          overview: "A comprehensive guide on what to eat.",
          sections: [],
          isSaved: true,
        ),
        ArticleModel(
          id: "a2",
          category: "WELLNESS",
          title: "Understanding sleep cycles",
          authorName: "Dr. Smith",
          date: "Oct 10",
          readTime: "8 min",
          imageUrl: "https://picsum.photos/seed/sleep/300/200",
          overview: "Learn how to match your sleep with your baby's.",
          sections: [],
          isSaved: true,
        ),
      ],
      accountSupportItems: [
        AccountSupportItem(
          title: "Manage Profile",
          iconPath: "person_outline",
          iconBackgroundColor: context.ext.colors.primaryExtraLight,
          iconColor: context.ext.colors.primaryDark,
        ),
        AccountSupportItem(
          title: "Security",
          iconPath: "lock_outline",
          iconBackgroundColor: context.ext.colors.primaryExtraLight,
          iconColor: context.ext.colors.primaryDark,
        ),
        AccountSupportItem(
          title: "Notifications",
          iconPath: "notifications_none",
          iconBackgroundColor: context.ext.colors.primaryExtraLight,
          iconColor: context.ext.colors.primaryDark,
        ),
        AccountSupportItem(
          title: "Language",
          iconPath: "translate",
          iconBackgroundColor: context.ext.colors.primaryExtraLight,
          iconColor: context.ext.colors.primaryDark,
          trailingText: "English (US)",
        ),
        AccountSupportItem(
          title: "Theme",
          iconPath: "palette_outlined",
          iconBackgroundColor: context.ext.colors.primaryExtraLight,
          iconColor: context.ext.colors.primaryDark,
          trailingText: "Pastel Pink",
        ),
        AccountSupportItem(
          title: "Help Center",
          iconPath: "help_outline",
          iconBackgroundColor: context.ext.colors.primaryExtraLight,
          iconColor: context.ext.colors.primaryDark,
        ),
      ],
    );
  }
}
