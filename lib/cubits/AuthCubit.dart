import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth_state.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  late StreamSubscription<UserModel?> _authSubscription;

  AuthCubit({required this.authRepository}) : super(AuthInitial()) {
    _authSubscription = authRepository.authStateChanges.listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(user)); // ✅ Emit state directly
      } else {
        emit(AuthLoggedOut());
      }
    });
  }

  Future<void> appStarted() async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 1)); // Simulate splash delay
    final user = await authRepository.authStateChanges.first;
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthLoggedOut());
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.loginWithEmail(email, password);
      emit(AuthAuthenticated(user));
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  Future<void> register(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.registerWithEmail(email, password);
      emit(AuthAuthenticated(user));
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await authRepository.logout();
      emit(AuthLoggedOut());
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel(); // ✅ Prevent memory leaks
    return super.close();
  }
}