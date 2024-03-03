import 'dart:convert';

import 'package:frontend/data/data_provider/user_data_provider.dart';
import 'package:frontend/model/user_model.dart';

class UserRepository {
  final UserDataProvider userDataProvider;
  UserRepository(this.userDataProvider);

  Future<User> getUser(String userId) async {
    try {
      final rawData = await userDataProvider.getProfileUser(userId);

      //print(data);
      if (rawData.statusCode == 200) {
        String response = utf8.decode(rawData.bodyBytes);
        return User.fromJson(response);
      } else {
        throw "Unexpected error occurred";
      }
    } catch (e) {
      throw e.toString();
    }
  }
  //       userId: userId,
  //       username: "mark.mellau",
  //       bio: "nemtimiedzizunk",
  //       name: "Mellau Mark-Mate",
  //       pfpLink:
  //           "https://www.everypixel.com/preview_collections/20221003/cyberpunk_man_in_sunglasses_17",
  //       followersCount: "32",
  //       followingCount: "52");
}
