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