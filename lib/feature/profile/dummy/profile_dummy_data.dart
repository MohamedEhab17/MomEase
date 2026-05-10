import 'package:flutter/widgets.dart';

import 'package:new_mama/feature/articles/domain/entities/article.dart';
import 'package:new_mama/feature/community/data/models/post_model.dart';
import 'package:new_mama/feature/profile/data/models/profile_model.dart';

class ProfileDummyData {
  static ProfileModel getDummyProfile() {
    return ProfileModel(
      id: "u123",
      name: "Ana Soso",
      avatarUrl: "https://i.pravatar.cc/150?img=5",
      subtitle: "Mom of baby Adam",
      journey: ParentingJourney(
        lastMoodEmoji: "😌",
        lastMoodStatus: "Calm",
        lastMoodColor: const Color(0xFF2E7D32),
        depressionTestStatus: "Completed",
        depressionTestColor: const Color(0xFF1976D2),
        babyTrackingStatus: "Updated today",
        babyTrackingColor: const Color(0xFFC2185B),
      ),
      babyProfile: BabyProfile(
        name: "Adam",
        ageString: "8 months old",
        avatarUrl: "https://i.pravatar.cc/150?img=12",
      ),
      recentPosts: [
        PostModel(
          postId: 101,
          userId: 123,
          userName: "Ana Soso",
          userPhoto: "https://i.pravatar.cc/150?img=5",
          text: "Finally found a routine that works for Adam's nap time. Feeling so relieved!",
          media: const [
            PostMedia(mediaId: 1, mediaUrl: "https://picsum.photos/seed/leaf/400/300", mediaType: 0),
          ],
          reactionsCount: 12,
          commentsCount: 5,
          createdAt: DateTime.now(),
        ),
        PostModel(
          postId: 102,
          userId: 123,
          userName: "Ana Soso",
          userPhoto: "https://i.pravatar.cc/150?img=5",
          text: "Any tips for healthy postpartum snacks that are quick to make?",
          media: const [],
          reactionsCount: 8,
          commentsCount: 14,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
      savedArticles: [
        Article(
          articleId: 1,
          categoryName: "NUTRITION",
          title: "7 useful meals for postpartum moms",
          sourceName: "Dr. Jane",
          publishedDate: "Oct 12",
          readingTimeMinutes: 5,
          imageUrl: "https://picsum.photos/seed/nutrition/300/200",
          shortDescription: "A comprehensive guide on what to eat.",
          content: "Content",
          isSaved: true,
          categoryId: 1,
        ),
        Article(
          articleId: 2,
          categoryName: "WELLNESS",
          title: "Understanding sleep cycles",
          sourceName: "Dr. Smith",
          publishedDate: "Oct 10",
          readingTimeMinutes: 8,
          imageUrl: "https://picsum.photos/seed/sleep/300/200",
          shortDescription: "Learn how to match your sleep with your baby's.",
          content: "Content",
          isSaved: true,
          categoryId: 2,
        ),
      ],
      accountSupportItems: [
        AccountSupportItem(
          title: "Manage Profile",
          iconPath: "person_outline",
          iconBackgroundColor: const Color(0xFFFCE4EC),
          iconColor: const Color(0xFFC2185B),
        ),
        AccountSupportItem(
          title: "Security",
          iconPath: "lock_outline",
          iconBackgroundColor: const Color(0xFFFCE4EC),
          iconColor: const Color(0xFFC2185B),
        ),
        AccountSupportItem(
          title: "Notifications",
          iconPath: "notifications_none",
          iconBackgroundColor: const Color(0xFFFCE4EC),
          iconColor: const Color(0xFFC2185B),
        ),
        AccountSupportItem(
          title: "Language",
          iconPath: "translate",
          iconBackgroundColor: const Color(0xFFFCE4EC),
          iconColor: const Color(0xFFC2185B),
          trailingText: "English (US)",
        ),
        AccountSupportItem(
          title: "Theme",
          iconPath: "palette_outlined",
          iconBackgroundColor: const Color(0xFFFCE4EC),
          iconColor: const Color(0xFFC2185B),
          trailingText: "Pastel Pink",
        ),
        AccountSupportItem(
          title: "Help Center",
          iconPath: "help_outline",
          iconBackgroundColor: const Color(0xFFFCE4EC),
          iconColor: const Color(0xFFC2185B),
        ),
      ],
    );
  }
}
