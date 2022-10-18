import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  final String? displayName;
  const AuthUser(this.isEmailVerified, this.displayName);

  String get getDisplayName {
    return displayName ?? "Some guy";
  }

  factory AuthUser.fromFirebase(User user) {
    return AuthUser(user.emailVerified, user.displayName);
  }
}
