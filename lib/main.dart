import 'package:flutter/material.dart';
import 'package:rick_and_morty/CharacterScreen.dart';

void main() {
  runApp(const MaterialApp(
    home: CharacterScreen()
  ));
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rick and Morty"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Email"
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: TextField(
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2)
                  ), hintText: "Password",
                  labelText: "Password",
                helperText: "Password must be more than 8 characters"
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white
              ),
                onPressed: () {

                }, child: const Text("Login")
            ),
          )
        ],
      ),
    );
  }
}
