import 'dart:convert';

import 'package:admin_panel/model/user_model.dart';
import 'package:admin_panel/model/utils/paginated_response_generic.dart';
import 'package:admin_panel/service/storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'users_panel_state.dart';

class UsersPanelCubit extends Cubit<UsersPanelState> {
  int pageSize = 10;
  int currentPage = 0;
  late int totalPages;
  List<User> users = [];

  UsersPanelCubit() : super(UsersPanelInitialState()) {
    _loadUsers(currentPage);
  }

  void _loadUsers(int page) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await StorageService().getAccessToken()}'
    };

    try {
      var uri = Uri.parse(
          'http://localhost:8080/admin/users?page=$page&pageSize=$pageSize');
      var response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        PaginatedResponse<User> paginatedResponse =
            PaginatedResponse.fromJson(responseJson, User.fromJson);
        users = paginatedResponse.content;
        totalPages = paginatedResponse.totalPages - 1;
        emit(UsersPanelLoaded(users, currentPage, totalPages));
      }
    } catch (e) {
      print(e);
    }
  }

  void nextPage() {
    if (currentPage < totalPages) {
      currentPage++;
      _loadUsers(currentPage);
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      currentPage--;
      _loadUsers(currentPage);
    }
  }

  void deleteUser(String id) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await StorageService().getAccessToken()}'
    };

    try {
      var uri = Uri.parse('http://localhost:8080/admin/users/$id');
      var response = await http.delete(uri, headers: headers);
      if (response.statusCode == 204) {
        _loadUsers(currentPage);
      }
    } catch (e) {
      print(e);
    }
  }

  void suspendUser(String id) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await StorageService().getAccessToken()}'
    };

    Map<String, dynamic> requestBody = {
      'isActive': false,
    };

    try {
      var uri = Uri.parse('http://localhost:8080/admin/users/$id');
      var response = await http.patch(uri,
          headers: headers, body: json.encode(requestBody));
      if (response.statusCode == 200) {
        _loadUsers(currentPage);
      }
    } catch (e) {
      print(e);
    }
  }

  void activateUser(String id) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await StorageService().getAccessToken()}'
    };

    Map<String, dynamic> requestBody = {
      'isActive': true,
    };

    try {
      var uri = Uri.parse('http://localhost:8080/admin/users/$id');
      var response = await http.patch(uri,
          headers: headers, body: json.encode(requestBody));
      if (response.statusCode == 200) {
        _loadUsers(currentPage);
      }
    } catch (e) {
      print(e);
    }
  }
}
