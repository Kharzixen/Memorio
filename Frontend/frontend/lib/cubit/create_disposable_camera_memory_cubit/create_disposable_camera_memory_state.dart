part of 'create_disposable_camera_memory_cubit.dart';

sealed class CreateDisposableCameraMemoryState {}

class CreateDisposableCameraMemoryInitialState
    extends CreateDisposableCameraMemoryState {}

class DisposableCameraMemoryCreationLoadingState
    extends CreateDisposableCameraMemoryState {}

class DisposableCameraMemoryCreationInProgressState
    extends CreateDisposableCameraMemoryState {
  Uint8List image;
  String caption;
  bool saveInProgress;
  bool savedToGallery;
  DisposableCameraMemoryCreationInProgressState(
      {required this.image,
      required this.caption,
      required this.saveInProgress,
      required this.savedToGallery});
}

class DisposableCameraMemoryCreationNoImageSelectedState
    extends CreateDisposableCameraMemoryState {}

class DisposableCameraMemoryCreationFinishedState
    extends CreateDisposableCameraMemoryState {
  PrivateMemory memory;
  DisposableCameraMemoryCreationFinishedState({required this.memory});
}

class DisposableCameraMemoryCreationErrorState
    extends CreateDisposableCameraMemoryState {
  final String message;
  DisposableCameraMemoryCreationErrorState({required this.message});
}
