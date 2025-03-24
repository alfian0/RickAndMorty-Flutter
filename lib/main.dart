import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rick_and_morty/repositories/auth_repository.dart';
import 'package:rick_and_morty/widgets/auth_checker_bloc.dart';
import 'package:rick_and_morty/widgets/auth_checker_cubit.dart';

import 'widgets/auth_checker.dart';
import 'firebase/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick and Morty Characters',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AuthCheckerCubit(),
    );
  }
}