class PaginatedResponse<T> {
  final List<T> content;
  final int totalPages;
  final int totalElements;
  final bool last;
  final int number;
  final int size;
  final int numberOfElements;

  PaginatedResponse({
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.last,
    required this.number,
    required this.size,
    required this.numberOfElements,
  });

  factory PaginatedResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return PaginatedResponse<T>(
      content:
          (json['content'] as List<dynamic>).map((e) => fromJsonT(e)).toList(),
      totalPages: json['totalPages'] as int,
      totalElements: json['totalElements'] as int,
      last: json['last'] as bool,
      number: json['number'] as int,
      size: json['size'] as int,
      numberOfElements: json['numberOfElements'] as int,
    );
  }

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) {
    return {
      'content': content.map((e) => toJsonT(e)).toList(),
      'totalPages': totalPages,
      'totalElements': totalElements,
      'last': last,
      'number': number,
      'size': size,
      'numberOfElements': numberOfElements,
    };
  }
}
