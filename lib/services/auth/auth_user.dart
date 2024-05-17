import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  // email field is added so that it can be used later in the notes_view page
  // to get all the notes of that user using its email from the database
  final String? email;
  final bool isEmailVerified;
  const AuthUser({
    required this.email,
    required this.isEmailVerified,
  });
  factory AuthUser.fromFirebase(User user) => AuthUser(
        email: user.email,
        isEmailVerified: user.emailVerified,
      );
}
