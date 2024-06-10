import 'dart:convert';
import 'dart:typed_data';

import 'package:frontend/data/data_provider/disposable_camera_memory_data_provider.dart';
import 'package:frontend/model/disposable_camera_memory_model.dart';
import 'package:frontend/model/memory_model.dart';
import 'package:frontend/model/utils/paginated_response_generic.dart';

class DisposableCameraMemoryRepository {
  Future<DisposableCameraMemory> getDisposableCameraMemoryById(
      String albumId, String memoryId) async {
    try {
      var response = await DisposableCameraMemoryDataProvider
          .getDisposableCameraMemoryById(albumId, memoryId);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        DisposableCameraMemory memory =
            DisposableCameraMemory.fromJson(responseJson);
        return memory;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  deleteDisposableCameraMemoryById(String albumId, String memoryId) async {
    try {
      var response = await DisposableCameraMemoryDataProvider
          .deleteDisposableCameraMemoryById(albumId, memoryId);
      if (response.statusCode == 204) {
        return true;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<PaginatedResponse<PrivateMemory>> getMemoriesOfUserInDisposableCamera(
      String userId, String albumId, int page, int pageSize) async {
    try {
      var response = await DisposableCameraMemoryDataProvider
          .getMemoriesOfUserInDisposableCamera(albumId, userId, page, pageSize);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        PaginatedResponse<PrivateMemory> paginatedMemories =
            PaginatedResponse.fromJson(responseJson, PrivateMemory.fromJson);
        return paginatedMemories;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<PaginatedResponse<PrivateMemory>> getAllMemoriesInDisposableCamera(
      String albumId, int page, int pageSize) async {
    try {
      var response = await DisposableCameraMemoryDataProvider
          .getAllMemoriesInDisposableCamera(albumId, page, pageSize);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = json.decode(response.body);
        PaginatedResponse<PrivateMemory> paginatedMemories =
            PaginatedResponse.fromJson(responseJson, PrivateMemory.fromJson);
        return paginatedMemories;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<PrivateMemory> createDisposableCameraMemory(
      String userId, String albumId, Uint8List image, String caption) async {
    try {
      var response =
          await DisposableCameraMemoryDataProvider.createDisposableCameraMemory(
              userId, albumId, caption, image);
      String jsonBody = await response.stream.bytesToString();
      if (response.statusCode == 201) {
        Map<String, dynamic> responseJson = json.decode(jsonBody);
        PrivateMemory createdMemory = PrivateMemory.fromJson(responseJson);
        return createdMemory;
      } else {
        throw Exception(jsonBody);
      }
    } catch (e) {
      rethrow;
    }
  }
}
