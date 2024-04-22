import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/collection_repository.dart';
import 'package:frontend/service/storage_service.dart';

part 'collection_creation_state.dart';

class CollectionCreationCubit extends Cubit<CollectionCreationState> {
  final CollectionRepository collectionRepository;

  CollectionCreationCubit(this.collectionRepository)
      : super(CollectionCreationInitialState());

  Future<void> createCollection(String albumId, String collectionName,
      String collectionDescription) async {
    try {
      emit(CollectionCreationInProgressState());
      var response = await collectionRepository.createCollection(albumId,
          StorageService().userId, collectionName, collectionDescription);
      print(response.collectionId);
      emit(CollectionCreationSuccessState());
    } catch (e) {
      // Emit error state if an error occurs
      emit(CollectionCreationErrorState('Failed to fetch user data: $e'));
    }
  }
}
