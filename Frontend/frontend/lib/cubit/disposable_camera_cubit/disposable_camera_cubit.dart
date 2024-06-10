import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/disposable_camera_memory_repository.dart';
import 'package:frontend/data/repository/private_album_repository.dart';
import 'package:frontend/model/disposable_camera_model.dart';
import 'package:frontend/model/memory_model.dart';
import 'package:frontend/model/private-album_model.dart';
import 'package:frontend/model/utils/paginated_response_generic.dart';

part 'disposable_camera_state.dart';

class DisposableCameraCubit extends Cubit<DisposableCameraState> {
  final PrivateAlbumRepository albumRepository;
  final DisposableCameraMemoryRepository memoryRepository;

  String albumId = "";
  String userId = "";

  late PrivateAlbumInfo albumInfo;
  late List<PrivateMemory> userMemories = [];
  int page = 0;
  int pageSize = 12;
  bool userMemoriesHasMoreData = true;

  bool isAllMemoryShowing = false;
  late List<PrivateMemory> allMemories = [];
  int allMemoriesPage = 0;
  int allMemoriesPageSize = 12;
  bool allMemoriesHasMoreData = true;

  DisposableCameraCubit(this.albumRepository, this.memoryRepository)
      : super(DisposableCameraInitialState());

  void loadDisposableCamera(String albumId, String userId) async {
    try {
      this.albumId = albumId;
      this.userId = userId;
      albumInfo = await albumRepository.getAlbumHeaderInfo(albumId);
      if (albumInfo.disposableCamera.isActive) {
        if (userMemoriesHasMoreData) {
          PaginatedResponse<PrivateMemory> memoriesPaginated =
              await memoryRepository.getMemoriesOfUserInDisposableCamera(
                  userId, albumId, page, pageSize);
          userMemoriesHasMoreData = !memoriesPaginated.last;
          userMemories.addAll(memoriesPaginated.content);
          page++;
        }
      }
      emit(DisposableCameraLoadedState(
          albumInfo, userMemories, allMemories, isAllMemoryShowing));
    } catch (e) {
      emit(DisposableCameraErrorState(e.toString()));
    }
  }

  void addNewMemory(PrivateMemory privateMemory) {
    if (albumId.isNotEmpty) {
      userMemories.insert(0, privateMemory);
      emit(DisposableCameraLoadedState(
          albumInfo, userMemories, allMemories, isAllMemoryShowing));
    }
  }

  void removeMemory(int index) {
    userMemories.removeAt(index);
    emit(DisposableCameraLoadedState(
        albumInfo, userMemories, allMemories, isAllMemoryShowing));
  }

  void closeDisposableCamera() async {
    try {
      DisposableCamera disposableCamera =
          await albumRepository.deactivateDisposableCamera(albumInfo.albumId);
      if (disposableCamera.isActive == false) {
        albumInfo.disposableCamera = disposableCamera;
        userMemories.clear();
        emit(DisposableCameraLoadedState(
            albumInfo, userMemories, allMemories, isAllMemoryShowing));
      } else {
        throw Exception("Unsuccessful deactivation");
      }
    } catch (e) {
      emit(DisposableCameraErrorState(e.toString()));
    }
  }

  void activateDisposableCamera(String description, String date) async {
    try {
      DisposableCamera disposableCamera =
          await albumRepository.activateDisposableCamera(
              albumInfo.albumId, DateTime.parse(date), description);
      if (disposableCamera.isActive == true) {
        albumInfo.disposableCamera = disposableCamera;
        emit(DisposableCameraLoadedState(
            albumInfo, userMemories, allMemories, isAllMemoryShowing));
      } else {
        throw Exception("Unsuccessful activation");
      }
    } catch (e) {
      emit(DisposableCameraErrorState(e.toString()));
    }
  }

  void showAllImages(String albumId) async {
    try {
      isAllMemoryShowing = true;
      if (albumInfo.disposableCamera.isActive) {
        if (allMemoriesHasMoreData) {
          PaginatedResponse<PrivateMemory> memoriesPaginated =
              await memoryRepository.getAllMemoriesInDisposableCamera(
                  albumId, allMemoriesPage, allMemoriesPageSize);
          allMemories.addAll(memoriesPaginated.content);
          allMemoriesHasMoreData = !memoriesPaginated.last;
          allMemoriesPage++;
        }
      }
      emit(DisposableCameraLoadedState(
          albumInfo, userMemories, allMemories, isAllMemoryShowing));
    } catch (e) {
      emit(DisposableCameraErrorState(e.toString()));
    }
  }

  void showYourImages(String albumId, String userId) async {
    try {
      isAllMemoryShowing = false;
      if (albumInfo.disposableCamera.isActive) {
        if (userMemoriesHasMoreData) {
          PaginatedResponse<PrivateMemory> memoriesPaginated =
              await memoryRepository.getMemoriesOfUserInDisposableCamera(
                  userId, albumId, page, pageSize);
          userMemoriesHasMoreData = !memoriesPaginated.last;
          userMemories.addAll(memoriesPaginated.content);
          page++;
        }
      }
      emit(DisposableCameraLoadedState(
          albumInfo, userMemories, allMemories, isAllMemoryShowing));
    } catch (e) {
      emit(DisposableCameraErrorState(e.toString()));
    }
  }

  void refreshState() async {
    if (isAllMemoryShowing) {
      allMemoriesHasMoreData = true;
      allMemories = [];
      allMemoriesPage = 0;
      try {
        isAllMemoryShowing = true;
        if (albumInfo.disposableCamera.isActive) {
          if (allMemoriesHasMoreData) {
            PaginatedResponse<PrivateMemory> memoriesPaginated =
                await memoryRepository.getAllMemoriesInDisposableCamera(
                    albumId, allMemoriesPage, allMemoriesPageSize);
            allMemories.addAll(memoriesPaginated.content);
            allMemoriesHasMoreData = !memoriesPaginated.last;
            allMemoriesPage++;
          }
        }
        emit(DisposableCameraLoadedState(
            albumInfo, userMemories, allMemories, isAllMemoryShowing));
      } catch (e) {
        emit(DisposableCameraErrorState(e.toString()));
      }
    } else {
      userMemoriesHasMoreData = true;
      userMemories = [];
      page = 0;
      try {
        albumInfo = await albumRepository.getAlbumHeaderInfo(albumId);
        if (albumInfo.disposableCamera.isActive) {
          if (userMemoriesHasMoreData) {
            PaginatedResponse<PrivateMemory> memoriesPaginated =
                await memoryRepository.getMemoriesOfUserInDisposableCamera(
                    userId, albumId, page, pageSize);
            userMemoriesHasMoreData = !memoriesPaginated.last;
            userMemories.addAll(memoriesPaginated.content);
            page++;
          }
        }
        emit(DisposableCameraLoadedState(
            albumInfo, userMemories, allMemories, isAllMemoryShowing));
      } catch (e) {
        emit(DisposableCameraErrorState(e.toString()));
      }
    }
  }
}
