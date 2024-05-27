part of 'disposable_camera_memory_cubit.dart';

sealed class DisposableCameraMemoryState {}

class DisposableCameraMemoryInitialState extends DisposableCameraMemoryState {}

class DisposableCameraMemoryLoadingState extends DisposableCameraMemoryState {}

class DisposableCameraMemoryLoadedState extends DisposableCameraMemoryState {
  bool asyncMethodInProgress;
  DisposableCameraMemory memory;
  DisposableCameraMemoryLoadedState(this.memory, this.asyncMethodInProgress);
}

class DisposableCameraMemoryErrorState extends DisposableCameraMemoryState {
  String error;
  DisposableCameraMemoryErrorState(this.error);
}

class DisposableCameraMemoryDeletedState extends DisposableCameraMemoryState {}
