import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class AuthScreen extends ConsumerWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Login/Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            if (authState.loading)
              const CircularProgressIndicator()
            else
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => authNotifier.login(
                        emailController.text, passwordController.text),
                    child: const Text('Login'),
                  ),
                  ElevatedButton(
                    onPressed: () => authNotifier.register(
                        emailController.text, passwordController.text),
                    child: const Text('Register'),
                  ),
                ],
              ),
            if (authState.error != null)
              Text(authState.error!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
