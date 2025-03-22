import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Character {
  final String name;
  final String status;
  final String species;

  Character({required this.name, required this.status, required this.species});

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'],
      status: json['status'],
      species: json['species'],
    );
  }
}

class ApiResponse {
  final List<Character> results;
  final ApiInfo info;

  ApiResponse({required this.results, required this.info});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      results: (json['results'] as List).map((e) => Character.fromJson(e)).toList(),
      info: ApiInfo.fromJson(json['info']),
    );
  }
}

class ApiInfo {
  final String? next;

  ApiInfo({required this.next});

  factory ApiInfo.fromJson(Map<String, dynamic> json) {
    return ApiInfo(
      next: json['next'],
    );
  }
}

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({super.key});

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  final List<Character> _data = [];
  dynamic _error;
  bool _isLoading = false;
  bool _isFetchingMore = false;
  int _page = 1;
  bool _hasNextPage = true;

  final Dio _dio = Dio();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchData(_page);

    // Add a listener to the scroll controller for infinite scroll
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose the controller to avoid memory leaks
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // User has reached the bottom of the list
      if (_hasNextPage && !_isFetchingMore) {
        _loadMore();
      }
    }
  }

  Future<void> _fetchData(int pageNumber) async {
    if (pageNumber == 1) {
      setState(() {
        _isLoading = true;
      });
    } else {
      setState(() {
        _isFetchingMore = true;
      });
    }

    try {
      final response = await _dio.get('https://rickandmortyapi.com/api/character?page=$pageNumber');
      final apiResponse = ApiResponse.fromJson(response.data);

      setState(() {
        if (pageNumber == 1) {
          _data.clear();
          _data.addAll(apiResponse.results);
        } else {
          _data.addAll(apiResponse.results);
        }
        _hasNextPage = apiResponse.info.next != null;
      });
    } catch (err) {
      setState(() {
        _error = err is DioException ? err.response?.data ?? 'API Error' : 'Something went wrong';
      });
    } finally {
      setState(() {
        _isLoading = false;
        _isFetchingMore = false;
      });
    }
  }

  void _loadMore() {
    if (_hasNextPage && !_isFetchingMore) {
      setState(() {
        _page++;
      });
      _fetchData(_page);
    }
  }

  void _refetch() {
    setState(() {
      _page = 1;
    });
    _fetchData(_page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick and Morty Characters'),
      ),
      body: Column(
        children: [
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_error != null)
            Center(child: Text('Error: $_error'))
          else
            Expanded(
              child: ListView.builder(
                controller: _scrollController, // Attach the scroll controller
                itemCount: _data.length + 1, // +1 for the loading indicator
                itemBuilder: (context, index) {
                  if (index == _data.length) {
                    // Show a loading indicator at the bottom
                    return _buildLoader();
                  }
                  final character = _data[index];
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