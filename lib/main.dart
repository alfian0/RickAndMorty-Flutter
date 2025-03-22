import 'package:flutter/material.dart';
import 'package:rick_and_morty/CharacterScreen.dart';

void main() {
  runApp(const MyApp());
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