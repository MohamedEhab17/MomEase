import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';

@lazySingleton
class BiometricHelper {
  final LocalAuthentication auth;

  BiometricHelper(this.auth);

  /// Checks if the device has biometric hardware and if it's enrolled/available
  Future<bool> isBiometricAvailable() async {
    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await auth.isDeviceSupported();
      return canAuthenticate;
    } on PlatformException catch (_) {
      return false;
    }
  }

  /// Attempts to authenticate the user using biometrics.
  /// Returns a tuple of (bool success, String? errorMessage)
  Future<(bool, String?)> authenticate({
    String localizedReason = 'Please authenticate to sign in securely',
  }) async {
    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: localizedReason,
      );
      return (didAuthenticate, null);
    } on PlatformException catch (e) {
      String errorMessage = 'Biometric authentication failed. ${e.message}';
      return (false, errorMessage);
    }
  }
}
