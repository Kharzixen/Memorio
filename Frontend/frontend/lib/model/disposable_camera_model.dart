class DisposableCamera {
  String id;
  bool isActive;
  String description;

  DisposableCamera(
      {required this.id, required this.isActive, required this.description});

  factory DisposableCamera.fromJson(Map<String, dynamic> json) {
    return DisposableCamera(
      id: json['id'].toString(),
      isActive: json['isActive'] as bool,
      description: json['description'] as String,
    );
  }
}
