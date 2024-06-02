import 'package:frontend/model/memory_model.dart';
import 'package:frontend/model/user_model.dart';
import 'package:frontend/service/storage_service.dart';

class PublicMemory extends Memory {
  PublicMemory({
    required String memoryId,
    required SimpleUser uploader,
    required DateTime date,
    required String caption,
    required String photo,
  }) : super(
            memoryId: memoryId,
            uploader: uploader,
            date: date,
            caption: caption,
            photo: photo);

  factory PublicMemory.fromJson(Map<String, dynamic> json) {
    return PublicMemory(
        memoryId: json['id'].toString(),
        caption: json['caption'] as String,
        photo:
            "${StorageService.connectionString}/private-album-images/${json['imageId']}",
        date: DateTime.parse(json['creationDate']),
        uploader: SimpleUser.fromMap(json["uploader"]));
  }
}
