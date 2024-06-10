class DisposableCamera {
  String id;
  bool isActive;
  String description;
  DateTime closeTime;

  DisposableCamera(
      {required this.id,
      required this.isActive,
      required this.closeTime,
      required this.description});

  factory DisposableCamera.fromJson(Map<String, dynamic> json) {
    return DisposableCamera(
      id: json['id'].toString(),
      isActive: json['isActive'] as bool,
      closeTime: json['closeTime'] == null
          ? DateTime.now()
          : DateTime.parse(json['closeTime'] as String),
      description: json['description'] as String,
    );
  }
}
