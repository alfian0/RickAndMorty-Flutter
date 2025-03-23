import 'package:flutter/material.dart';

import 'CharacterProvider.dart';

class CharacterScreen extends StatelessWidget {
  final CharacterProvider _characterProvider = CharacterProvider();

  CharacterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    _characterProvider.fetchData(1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick and Morty Characters'),
      ),
      body: ListenableBuilder(
        listenable: _characterProvider,
        builder: (context, child) {
          if (_characterProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (_characterProvider.error != null) {
            return Center(child: Text('Error: ${_characterProvider.error}'));
          } else {
            return ListView.builder(
              controller: ScrollController()..addListener(() {
                if (_characterProvider.hasNextPage && !_characterProvider.isFetchingMore) {
                  _characterProvider.loadMore();
                }
              }),
              itemCount: _characterProvider.data.length + 1,
              itemBuilder: (context, index) {
                if (index == _characterProvider.data.length) {
                  return _buildLoader(_characterProvider);
                }
                final character = _characterProvider.data[index];
                return ListTile(
                  title: Text(character.name),
                  subtitle: Text('${character.status} - ${character.species}'),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildLoader(CharacterProvider characterProvider) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: characterProvider.isFetchingMore
            ? const CircularProgressIndicator()
            : characterProvider.hasNextPage
            ? const Text('Load more...')
            : const Text('No more characters to load.'),
      ),
    );
  }
}