import 'package:frontend/model/user_model.dart';
import 'package:frontend/service/storage_service.dart';

class Memory {
  String memoryId;
  String caption;
  DateTime date;
  String photo;

  SimpleUser uploader;

  Memory({
    required this.memoryId,
    required this.uploader,
    required this.date,
    required this.caption,
    required this.photo,
  });
}
