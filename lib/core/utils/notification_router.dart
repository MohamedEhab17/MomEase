import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_mama/core/routers/app_router_paths.dart';
import '../../feature/notifications/presentation/widgets/tip_detail_bottom_sheet.dart';

class NotificationRouter {
  NotificationRouter._();

  /// Safely handles navigation for both push notifications and in-app clicks.
  static void navigate(
    BuildContext context, {
    String? actionUrl,
    required String type,
    int? relatedEntityId,
    required String title,
    required String body,
  }) {
    log('[NotificationRouter] Navigating to: type=$type, actionUrl=$actionUrl, relatedEntityId=$relatedEntityId');

    // Force showing the tip bottom sheet for mental health tips in all cases
    if (type == 'MentalHealthTip' ||
        type == 'SendDueTipsAsync' ||
        (actionUrl != null && actionUrl.contains('/mental-health/tips/'))) {
      TipDetailBottomSheet.show(context, title: title, body: body);
      return;
    }

    // 1. If we have a non-null, non-empty actionUrl, try to route directly
    if (actionUrl != null && actionUrl.trim().isNotEmpty) {
      final cleanUrl = actionUrl.trim();

      // Handle custom anchor tags in community links (e.g., /posts/50#comment-123)
      if (cleanUrl.contains('/posts/')) {
        final regExp = RegExp(r'\/posts\/(\d+)');
        final match = regExp.firstMatch(cleanUrl);
        if (match != null) {
          final postIdStr = match.group(1);
          if (postIdStr != null) {
            String query = '';
            final typeLower = type.toLowerCase();
            if (typeLower.contains('comment') || typeLower.contains('reply') || cleanUrl.contains('#comment-')) {
              query = '?action=comments';
            } else if (typeLower.contains('reaction')) {
              query = '?action=reactions';
            }
            context.push('/posts/$postIdStr$query');
            return;
          }
        }
      }

      // Handle my-posts / myposts links
      if (cleanUrl == '/my-posts' || cleanUrl == '/myposts') {
        context.push('/my-posts');
        return;
      }

      // Fallback: If it's another standard URL, push directly via GoRouter
      try {
        context.push(cleanUrl);
        return;
      } catch (e) {
        log('[NotificationRouter] GoRouter failed to push path: $cleanUrl. Falling back to type-based matching.');
      }
    }

    // 2. Fallback / direct mapping based on Notification type and relatedEntityId
    switch (type) {
      case 'CommunityComment':
      case 'AddCommentAsync':
      case 'AddReplyAsync':
        if (relatedEntityId != null) {
          context.push('/posts/$relatedEntityId?action=comments');
        } else {
          context.push(AppRoutesPaths.communityView);
        }
        break;

      case 'CommunityReaction':
      case 'AddReactionAsync':
      case 'AddCommentReactionAsync':
        if (relatedEntityId != null) {
          context.push('/posts/$relatedEntityId?action=reactions');
        } else {
          context.push(AppRoutesPaths.communityView);
        }
        break;

      case 'SavePostAsync':
        if (relatedEntityId != null) {
          context.push('/posts/$relatedEntityId');
        } else {
          context.push(AppRoutesPaths.communityView);
        }
        break;

      case 'ReviewReportAsync':
        // Warn goes to the post, Delete goes to my posts
        if (actionUrl == '/my-posts' || actionUrl == '/myposts') {
          context.push('/my-posts');
        } else if (relatedEntityId != null) {
          context.push('/posts/$relatedEntityId');
        } else {
          context.push(AppRoutesPaths.communityView);
        }
        break;

      case 'AssessmentResult':
      case 'AssessmentResultSevere':
      case 'AssessmentResultNormal':
      case 'AssessmentResultModerate':
      case 'AssessmentResultMild':
      case 'SendAssessmentResultNotificationAsync':
        if (relatedEntityId != null) {
          context.push('/assessments/results/$relatedEntityId');
        } else {
          context.push(AppRoutesPaths.depressionTestOptionsView);
        }
        break;

      case 'MentalHealthAssessmentReminder':
      case 'SendDueAssessmentRemindersAsync':
        context.push(AppRoutesPaths.depressionTestOptionsView);
        break;

      case 'DailyTrackingReminder':
      case 'SendTrackingNotificationAsync':
      case 'VaccinationCompleted':
        context.push(AppRoutesPaths.babyTrackView);
        break;

      case 'MentalHealthTip':
      case 'SendDueTipsAsync':
        TipDetailBottomSheet.show(context, title: title, body: body);
        break;

      default:
        context.go(AppRoutesPaths.appSectionView);
        break;
    }
  }
}
