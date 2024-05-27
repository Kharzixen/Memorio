import 'package:frontend/model/user_model.dart';

class SimpleUserWithFollowedStatus {
  SimpleUser user;
  bool isFollowed;
  bool isFollowInitiated;
  SimpleUserWithFollowedStatus(
      {required this.user,
      required this.isFollowed,
      required this.isFollowInitiated});
}
