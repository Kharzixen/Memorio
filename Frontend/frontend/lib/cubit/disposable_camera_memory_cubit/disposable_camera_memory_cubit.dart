import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/disposable_camera_memory_repository.dart';
import 'package:frontend/model/disposable_camera_memory_model.dart';

part 'disposable_camera_memory_state.dart';

class DisposableCameraMemoryCubit extends Cubit<DisposableCameraMemoryState> {
  final DisposableCameraMemoryRepository memoryRepository;
  late DisposableCameraMemory memory;
  late String albumId;

  DisposableCameraMemoryCubit(this.memoryRepository)
      : super(DisposableCameraMemoryInitialState());

  void fetchDisposableCameraMemory(String albumId, String memoryId) async {
    try {
      this.albumId = albumId;
      emit(DisposableCameraMemoryLoadingState());
      memory = await memoryRepository.getDisposableCameraMemoryById(
          albumId, memoryId);
      emit(DisposableCameraMemoryLoadedState(memory, false));
    } catch (e) {
      emit(DisposableCameraMemoryErrorState(e.toString()));
    }
  }

  void deletePost() async {
    try {
      emit(DisposableCameraMemoryLoadedState(memory, true));
      bool resp = await memoryRepository.deleteDisposableCameraMemoryById(
          albumId, memory.memoryId);
      if (resp == true) {
        emit(DisposableCameraMemoryDeletedState());
      } else {
        throw Exception("Unsuccessful delete");
      }
    } catch (e) {
      emit(DisposableCameraMemoryErrorState(e.toString()));
    }
  }
}
