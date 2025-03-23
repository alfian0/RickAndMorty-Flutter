import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/models.dart';

class CharacterProvider {
  final ApiService _apiService = ApiService();

  final ValueNotifier<List<Character>> _data = ValueNotifier([]);
  final ValueNotifier<dynamic> _error = ValueNotifier(null);
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  final ValueNotifier<bool> _isFetchingMore = ValueNotifier(false);
  final ValueNotifier<int> _page = ValueNotifier(1);
  final ValueNotifier<bool> _hasNextPage = ValueNotifier(true);

  ValueNotifier<List<Character>> get data => _data;
  ValueNotifier<dynamic> get error => _error;
  ValueNotifier<bool> get isLoading => _isLoading;
  ValueNotifier<bool> get isFetchingMore => _isFetchingMore;
  ValueNotifier<bool> get hasNextPage => _hasNextPage;

  Future<void> fetchData(int pageNumber) async {
    if (pageNumber == 1) {
      _isLoading.value = true;
    } else {
      _isFetchingMore.value = true;
    }

    try {
      final apiResponse = await _apiService.fetchCharacters(pageNumber);
      _data.value = pageNumber == 1 ? apiResponse.results : [..._data.value, ...apiResponse.results];
      _hasNextPage.value = apiResponse.info.next != null;
    } catch (err) {
      _error.value = err;
    } finally {
      _isLoading.value = false;
      _isFetchingMore.value = false;
    }
  }

  void loadMore() {
    if (_hasNextPage.value && !_isFetchingMore.value) {
      _page.value++;
      fetchData(_page.value);
    }
  }

  void refetch() {
    _page.value = 1;
    fetchData(_page.value);
  }
}