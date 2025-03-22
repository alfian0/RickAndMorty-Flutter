import 'package:dio/dio.dart';

import 'models.dart';

class CharacterState {
  final List<Character> characters = [];
  bool isLoading = false;
  bool isFetchingMore = false;
  bool hasNextPage = true;
  int page = 1;
  String? error;
  final Dio _dio = Dio();

  Future<void> fetchCharacters({bool isLoadMore = false}) async {
    if (isLoadMore) {
      isFetchingMore = true;
    } else {
      isLoading = true;
      error = null;
    }

    try {
      final response = await _dio.get('https://rickandmortyapi.com/api/character?page=$page');
      final apiResponse = ApiResponse.fromJson(response.data);

      if (isLoadMore) {
        characters.addAll(apiResponse.results);
      } else {
        characters.clear();
        characters.addAll(apiResponse.results);
      }

      hasNextPage = apiResponse.info.next != null;
      if (hasNextPage) {
        page++;
      }
    } catch (err) {
      error = err.toString();
    } finally {
      isLoading = false;
      isFetchingMore = false;
    }
  }
}
