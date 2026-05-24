import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GoogleAuthHelper {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId:
        '900654604916-io28lnaen96nuudm7pa2nh9s2nacsac7.apps.googleusercontent.com',
  );

  Future<(String?, String?)> getGoogleIdToken() async {
    try {
      // Prompt the user to select an account by signing out first
      await _googleSignIn.signOut();

      // signIn() is available in version 6.x
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return (null, 'Google Sign-In was cancelled by the user.');
      }

      // authentication is a Future in version 6.x
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null || idToken.isEmpty) {
        return (null, 'Authentication succeeded but no ID Token was received.');
      }
      log('ID Token: $idToken');

      return (idToken, null);
    } on PlatformException catch (e) {
      if (e.code == GoogleSignIn.kSignInCanceledError) {
        return (null, 'Google Sign-In was cancelled by the user.');
      }
      return (null, 'An error occurred during Google Sign-In: ${e.message}');
    } catch (e) {
      return (null, 'An unexpected error occurred: $e');
    }
  }

  /// Silently disconnects the user from Google Sign In.
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
