part of 'disposable_camera_cubit.dart';

sealed class DisposableCameraState {}

class DisposableCameraInitialState extends DisposableCameraState {}

class DisposableCameraLoadingState extends DisposableCameraState {}

class DisposableCameraLoadedState extends DisposableCameraState {
  PrivateAlbumInfo albumInfo;
  List<PrivateMemory> memories;
  List<PrivateMemory> allMemories;
  bool isAllMemoryShowing;
  DisposableCameraLoadedState(
      this.albumInfo, this.memories, this.allMemories, this.isAllMemoryShowing);
}

class DisposableCameraErrorState extends DisposableCameraState {
  String message;
  DisposableCameraErrorState(this.message);
}
