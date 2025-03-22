import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'character_provider.dart';

class CharacterScreen extends StatelessWidget {
  const CharacterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final characterProvider = Provider.of<CharacterProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Rick and Morty Characters')),
      body: Column(
        children: [
          if (characterProvider.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (characterProvider.error != null)
            Center(child: Text('Error: ${characterProvider.error}'))
          else Expanded(
              child: ListView.builder(
                controller: ScrollController()..addListener(() {
                  if (characterProvider.hasNextPage && !characterProvider.isFetchingMore) {
                    characterProvider.loadMore();
                  }
                }),
                itemCount: characterProvider.characters.length + 1,
                itemBuilder: (context, index) {
                  if (index == characterProvider.characters.length) {
                    return _buildLoader(characterProvider);
                  }
                  final character = characterProvider.characters[index];
                  return ListTile(
                    title: Text(character.name),
                    subtitle: Text('${character.status} - ${character.species}'),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoader(CharacterProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: provider.isFetchingMore
            ? const CircularProgressIndicator()
            : provider.hasNextPage
            ? const Text('Load more...')
            : const Text('No more characters to load.'),
      ),
    );
  }
}
