import 'package:flutter/material.dart';
import 'models.dart';
import 'api_service.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({super.key});

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  final ApiService _apiService = ApiService();
  final ScrollController _scrollController = ScrollController();

  List<Character> _characters = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;
  int _page = 1;
  bool _hasNextPage = true;
  dynamic _error;

  @override
  void initState() {
    super.initState();
    _fetchData(_page);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && _hasNextPage && !_isFetchingMore) {
      _loadMore();
    }
  }

  Future<void> _fetchData(int page) async {
    setState(() => page == 1 ? _isLoading = true : _isFetchingMore = true);

    try {
      final apiResponse = await _apiService.fetchCharacters(page);
      setState(() {
        if (page == 1) {
          _characters = apiResponse.results;
        } else {
          _characters.addAll(apiResponse.results);
        }
        _hasNextPage = apiResponse.info.next != null;
      });
    } catch (err) {
      setState(() => _error = err.toString());
    } finally {
      setState(() {
        _isLoading = false;
        _isFetchingMore = false;
      });
    }
  }

  void _loadMore() {
    _fetchData(++_page);
  }

  void _refetch() {
    setState(() {
      _page = 1;
      _characters.clear();
      _error = null;
    });
    _fetchData(_page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rick and Morty Characters')),
      body: Column(
        children: [
          if (_isLoading) const Center(child: CircularProgressIndicator())
          else if (_error != null) Center(child: Text('Error: $_error'))
          else Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _characters.length + 1,
                itemBuilder: (context, index) {
                  if (index == _characters.length) return _buildLoader();
                  final character = _characters[index];
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
        child: _isFetchingMore
            ? const CircularProgressIndicator()
            : _hasNextPage
            ? const Text('Load more...')
            : const Text('No more characters to load.'),
      ),
    );
  }
}
