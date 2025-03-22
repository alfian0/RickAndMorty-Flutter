import 'package:flutter/material.dart';
import 'character_state.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({super.key});

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  final CharacterState _characterState = CharacterState();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _characterState.error = null; // Reset error before fetching
    });

    await _characterState.fetchCharacters();
    setState(() {}); // UI updates after fetching data
  }

  Future<void> _loadMore() async {
    await _characterState.fetchCharacters(isLoadMore: true);
    setState(() {}); // UI updates after fetching more data
  }

  void _refetch() {
    setState(() {
      _characterState.page = 1;
    });
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rick and Morty Characters')),
      body: Column(
        children: [
          if (_characterState.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_characterState.error != null)
            Center(child: Text('Error: ${_characterState.error}'))
          else
            Expanded(
              child: ListView.builder(
                controller: ScrollController()..addListener(() {
                  if (_characterState.hasNextPage && !_characterState.isFetchingMore) {
                    _loadMore();
                  }
                }),
                itemCount: _characterState.characters.length + 1,
                itemBuilder: (context, index) {
                  if (index == _characterState.characters.length) {
                    return _buildLoader();
                  }
                  final character = _characterState.characters[index];
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

  Widget _buildLoader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: _characterState.isFetchingMore
            ? const CircularProgressIndicator()
            : _characterState.hasNextPage
            ? const Text('Load more...')
            : const Text('No more characters to load.'),
      ),
    );
  }
}
