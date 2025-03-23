import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthState {
  final User? user;
  final bool loading;
  final String? error;

  AuthState({this.user, this.loading = false, this.error});
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState()) {
    _checkAuthState(); // Automatically check if user is logged in
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _checkAuthState() async {
    _auth.authStateChanges().listen((user) {
      state = AuthState(user: user, loading: false);
    });
  }

  Future<void> login(String email, String password) async {
    state = AuthState(user: null, loading: true);
    try {
      final UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      state = AuthState(user: userCredential.user, loading: false);
    } catch (e) {
      state = AuthState(user: null, loading: false, error: e.toString());
    }
  }

  Future<void> register(String email, String password) async {
    state = AuthState(user: null, loading: true);
    try {
      final UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      state = AuthState(user: userCredential.user, loading: false);
    } catch (e) {
      state = AuthState(user: null, loading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    state = AuthState(user: null, loading: false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
