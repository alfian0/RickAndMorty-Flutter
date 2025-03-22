import 'package:flutter/material.dart';
import 'api_service.dart';
import 'models.dart';

class CharacterProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Character> _characters = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;
  int _page = 1;
  bool _hasNextPage = true;
  dynamic _error;

  List<Character> get characters => _characters;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasNextPage => _hasNextPage;
  dynamic get error => _error;

  CharacterProvider() {
    fetchData(_page); // Automatically fetch data when provider is initialized
  }

  Future<void> fetchData(int page) async {
    if (page == 1) {
      _isLoading = true;
    } else {
      _isFetchingMore = true;
    }
    notifyListeners();

    try {
      final apiResponse = await _apiService.fetchCharacters(page);
      if (page == 1) {
        _characters = apiResponse.results;
      } else {
        _characters.addAll(apiResponse.results);
      }
      _hasNextPage = apiResponse.info.next != null;
    } catch (err) {
      _error = err.toString();
    } finally {
      _isLoading = false;
      _isFetchingMore = false;
      notifyListeners();
    }
  }

  void loadMore() {
    if (_hasNextPage && !_isFetchingMore) {
      _page++;
      fetchData(_page);
    }
  }

  void refetch() {
    _page = 1;
    _characters.clear();
    _error = null;
    fetchData(_page);
  }
}
