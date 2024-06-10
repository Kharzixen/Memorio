import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/private_collection_repository.dart';
import 'package:frontend/data/repository/private_memory_repository.dart';
import 'package:frontend/model/memory_model.dart';
import 'package:frontend/model/utils/paginated_response_generic.dart';
import 'package:frontend/service/storage_service.dart';

part 'add_memories_to_collection_state.dart';

class AddMemoriesToCollectionCubit
    extends Cubit<AddMemoriesToCollectionPageState> {
  final PrivateCollectionRepository collectionRepository;
  final PrivateMemoryRepository memoryRepository;

  int page = 0;
  bool hasMoreData = true;

  List<PrivateMemory> memories = [];
  List<bool> isSelected = [];
  int nrOfSelected = 0;

  late String albumId;
  late String collectionId;

  AddMemoriesToCollectionCubit(this.collectionRepository, this.memoryRepository)
      : super(AddMemoriesToCollectionPageInitialState());

  Future<void> loadMemoriesWhichCanBeAddedToCollection(
      String albumId, String collectionId) async {
    if (hasMoreData) {
      this.albumId = albumId;
      this.collectionId = collectionId;
      PaginatedResponse<PrivateMemory> paginatedResponse =
          await memoryRepository.getMemoriesWhichCanBeAddedToCollection(
              albumId, collectionId, StorageService().userId, page);
      page++;
      if (paginatedResponse.last) {
        hasMoreData = false;
      }

      memories.addAll(paginatedResponse.content);
      for (int i = 0; i < paginatedResponse.numberOfElements; i++) {
        isSelected.add(false);
      }
      emit(AddMemoriesToCollectionPageLoadedState(
          memories, isSelected, nrOfSelected, false));
    }
  }

  void selectMemory(int memoryListId) {
    isSelected[memoryListId] = true;
    nrOfSelected++;
    emit(AddMemoriesToCollectionPageLoadedState(
        memories, isSelected, nrOfSelected, false));
  }

  void unselectMemory(int memoryListId) {
    isSelected[memoryListId] = false;
    nrOfSelected--;
    emit(AddMemoriesToCollectionPageLoadedState(
        memories, isSelected, nrOfSelected, false));
  }

  void selectAll() {
    for (int i = 0; i < memories.length; i++) {
      isSelected[i] = true;
    }
    nrOfSelected = memories.length;
    emit(AddMemoriesToCollectionPageLoadedState(
        memories, isSelected, nrOfSelected, false));
  }

  void addSelectedImagesToCollection() async {
    emit(AddMemoriesToCollectionPageLoadedState(
        memories, isSelected, nrOfSelected, true));
    List<PrivateMemory> selectedMemories = [];
    for (int i = 0; i < memories.length; i++) {
      if (isSelected[i]) {
        selectedMemories.add(memories[i]);
      }
    }
    int _ = await collectionRepository.addMemoriesToCollection(
        albumId, collectionId, selectedMemories);

    emit(AddMemoriesToCollectionPageFinishedState(selectedMemories));
  }
}
