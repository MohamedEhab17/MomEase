import 'package:flutter/widgets.dart';
import 'package:new_mama/core/di/injection.dart';
import 'package:new_mama/core/routers/app_router.dart';

/// Global notifier to trigger a root-level widget tree rebuild upon logout or session expiration.
final sessionNotifier = ValueNotifier<int>(0);

/// Global notifier indicating if a reset is in progress, to safely swap the active widget tree
/// with a lightweight loading placeholder before destroying/recreating registered dependencies.
final isResettingNotifier = ValueNotifier<bool>(false);

bool _isResetting = false;

/// Resets the entire dependency injection container, re-initializes the GoRouter
/// config, and increments the session notifier to trigger a fresh app rebuild.
Future<void> performAppReset() async {
  if (_isResetting) return;
  _isResetting = true;
  debugPrint('Reset started');
  try {
    isResettingNotifier.value = true;
    
    // Allow Flutter to rebuild into the reset screen
    await WidgetsBinding.instance.endOfFrame;
    debugPrint('Frame disposed');

    await getIt.reset();
    debugPrint('GetIt reset completed');

    await configureDependencies();
    debugPrint('Dependencies registered');

    await AppRouter.initRouter();
    debugPrint('Router initialized');

    sessionNotifier.value++;
  } catch (e, stackTrace) {
    debugPrint(
      'performAppReset failed: $e\n$stackTrace',
    );
  } finally {
    isResettingNotifier.value = false;
    _isResetting = false;
    debugPrint('Reset completed');
  }
}
