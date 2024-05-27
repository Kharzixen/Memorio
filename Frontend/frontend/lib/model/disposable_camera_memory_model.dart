import 'package:frontend/model/disposable_camera_model.dart';
import 'package:frontend/model/user_model.dart';
import 'package:frontend/service/storage_service.dart';

class DisposableCameraMemory {
  String memoryId;
  String caption;
  DateTime creationDate;
  String imageLink;
  SimpleUser uploader;
  DisposableCamera disposableCamera;

  DisposableCameraMemory(
      {required this.memoryId,
      required this.caption,
      required this.creationDate,
      required this.imageLink,
      required this.uploader,
      required this.disposableCamera});

  factory DisposableCameraMemory.fromJson(Map<String, dynamic> json) {
    return DisposableCameraMemory(
        memoryId: json['id'].toString(),
        uploader: SimpleUser.fromMap(json["uploader"]),
        caption: json['caption'] as String,
        creationDate: DateTime.parse(json['creationDate']),
        disposableCamera: DisposableCamera.fromJson(json['disposableCamera']),
        imageLink:
            "${StorageService.connectionString}/private-album-images/${json['imageId']}");
  }
}
