import 'package:flutter/material.dart';
import 'package:rick_and_morty/CharacterScreen.dart';
import 'package:provider/provider.dart';
import 'character_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CharacterProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick and Morty Characters',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CharacterScreen(),
    );
  }
}