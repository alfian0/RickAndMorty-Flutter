import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ✅ Helper function to map Firebase User -> UserModel
  UserModel? _mapFirebaseUserToUserModel(User? user) {
    if (user == null) return null;
    return UserModel(
      displayName: user.displayName ?? "",
      email: user.email ?? "",
      phoneNumber: user.phoneNumber,
      photoURL: user.photoURL,
    );
  }

  // ✅ Get current user without waiting for stream
  UserModel? getCurrentUser() => _mapFirebaseUserToUserModel(_auth.currentUser);

  // ✅ Listen to auth state changes
  Stream<UserModel?> get authStateChanges => _auth.authStateChanges().map(_mapFirebaseUserToUserModel);

  // ✅ Login with email and password
  Future<UserModel> loginWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return _mapFirebaseUserToUserModel(userCredential.user)!;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Login failed");
    }
  }

  // ✅ Register with email and password
  Future<UserModel> registerWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return _mapFirebaseUserToUserModel(userCredential.user)!;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Registration failed");
    }
  }

  // ✅ Logout user
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception("Logout failed");
    }
  }
}

