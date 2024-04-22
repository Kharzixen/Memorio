import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/collection_repository.dart';
import 'package:frontend/data/repository/memory_repository.dart';
import 'package:frontend/model/album_model.dart';
import 'package:frontend/model/utils/paginated_response_generic.dart';
import 'package:frontend/service/storage_service.dart';

part 'add_memories_to_collection_state.dart';

class AddMemoriesToCollectionCubit
    extends Cubit<AddMemoriesToCollectionPageState> {
  final CollectionRepository collectionRepository;
  final MemoryRepository memoryRepository;

  int page = 0;
  bool hasMoreData = true;

  List<Memory> memories = [];
  List<bool> isSelected = [];
  int nrOfSelected = 0;

  AddMemoriesToCollectionCubit(this.collectionRepository, this.memoryRepository)
      : super(AddMemoriesToCollectionPageInitialState());

  Future<void> loadMemoriesWhichCanBeAddedToCollection(
      String albumId, String collectionId) async {
    if (hasMoreData) {
      PaginatedResponse<Memory> paginatedResponse =
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
          memories, isSelected, nrOfSelected));
    }
  }

  void selectMemory(int memoryListId) {
    isSelected[memoryListId] = true;
    nrOfSelected++;
    emit(AddMemoriesToCollectionPageLoadedState(
        memories, isSelected, nrOfSelected));
  }

  void unselectMemory(int memoryListId) {
    isSelected[memoryListId] = false;
    nrOfSelected--;
    emit(AddMemoriesToCollectionPageLoadedState(
        memories, isSelected, nrOfSelected));
  }

  void selectAll() {
    for (int i = 0; i < memories.length; i++) {
      isSelected[i] = true;
    }
    nrOfSelected = memories.length;
    emit(AddMemoriesToCollectionPageLoadedState(
        memories, isSelected, nrOfSelected));
  }
}
