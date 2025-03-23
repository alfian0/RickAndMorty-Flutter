import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../screens/home_screen.dart';
import '../screens/auth_screen.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (authState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return authState.user != null ? const HomeScreen() : AuthScreen();
  }
}
