import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_state.dart';
import '../cubits/AuthCubit.dart';
import '../repositories/auth_repository.dart';
import '../screens/bloc/login_screen.dart';
import '../screens/home_screen.dart';

class AuthCheckerCubit extends StatelessWidget {
  final AuthRepository authRepository = AuthRepository();

  AuthCheckerCubit({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(authRepository: authRepository)..appStarted(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Navigator.pushReplacementNamed(context, '/home');
          } else if (state is AuthLoggedOut) {
            // Navigator.pushReplacementNamed(context, '/login');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return const HomeScreen();
            } else if (state is AuthLoggedOut || state is AuthError) {
              return LoginScreen();
            } else {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ),
    );
  }
}
