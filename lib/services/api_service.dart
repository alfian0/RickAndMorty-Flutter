import 'package:dio/dio.dart';
import '../models/models.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<ApiResponse> fetchCharacters(int page) async {
    try {
      final response = await _dio.get('https://rickandmortyapi.com/api/character?page=$page');
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      throw e is DioException ? e.response?.data ?? 'API Error' : 'Something went wrong';
    }
  }
}