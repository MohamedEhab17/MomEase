import 'package:flutter/material.dart';
import 'package:new_mama/feature/articles/domain/entities/article.dart';
import 'package:new_mama/feature/community/data/models/post_model.dart';

class ProfileModel {
  final String id;
  final String name;
  final String avatarUrl;
  final String subtitle;
  final ParentingJourney journey;
  final BabyProfile babyProfile;
  final List<PostModel> recentPosts;
  final List<Article> savedArticles;
  final List<AccountSupportItem> accountSupportItems;

  ProfileModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.subtitle,
    required this.journey,
    required this.babyProfile,
    required this.recentPosts,
    required this.savedArticles,
    required this.accountSupportItems,
  });
}

class ParentingJourney {
  final String lastMoodEmoji;
  final String lastMoodStatus;
  final Color lastMoodColor;
  final String depressionTestStatus;
  final Color depressionTestColor;
  final String babyTrackingStatus;
  final Color babyTrackingColor;

  ParentingJourney({
    required this.lastMoodEmoji,
    required this.lastMoodStatus,
    required this.lastMoodColor,
    required this.depressionTestStatus,
    required this.depressionTestColor,
    required this.babyTrackingStatus,
    required this.babyTrackingColor,
  });
}

class BabyProfile {
  final String name;
  final String ageString;
  final String avatarUrl;

  BabyProfile({
    required this.name,
    required this.ageString,
    required this.avatarUrl,
  });
}

class AccountSupportItem {
  final String title;
  final String iconPath;
  final Color iconBackgroundColor;
  final Color iconColor;
  final String? trailingText;

  AccountSupportItem({
    required this.title,
    required this.iconPath,
    required this.iconBackgroundColor,
    required this.iconColor,
    this.trailingText,
  });
}
