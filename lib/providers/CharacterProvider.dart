import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/models.dart';

class CharacterProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Character> _data = [];
  dynamic _error;
  bool _isLoading = false;
  bool _isFetchingMore = false;
  int _page = 1;
  bool _hasNextPage = true;

  List<Character> get data => _data;
  dynamic get error => _error;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasNextPage => _hasNextPage;

  Future<void> fetchData(int pageNumber) async {
    if (pageNumber == 1) {
      _isLoading = true;
    } else {
      _isFetchingMore = true;
    }
    notifyListeners();

    try {
      final apiResponse = await _apiService.fetchCharacters(pageNumber);
      _data = pageNumber == 1 ? apiResponse.results : [..._data, ...apiResponse.results];
      _hasNextPage = apiResponse.info.next != null;
    } catch (err) {
      _error = err;
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
    fetchData(_page);
  }
}