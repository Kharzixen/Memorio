import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/private_album_repository.dart';
import 'package:frontend/data/repository/private_memory_repository.dart';
import 'package:frontend/model/memory_model.dart';
import 'package:frontend/model/user_model.dart';
import 'package:frontend/model/utils/paginated_response_generic.dart';

part 'contributor_state.dart';

class ContributorCubit extends Cubit<ContributorState> {
  final PrivateMemoryRepository memoryRepository;
  final PrivateAlbumRepository albumRepository;

  late SimpleUser contributor;
  late String albumId;
  late List<PrivateMemory> memoriesOfUser = [];

  int page = 0;
  int pageSize = 12;

  ContributorCubit(this.memoryRepository, this.albumRepository)
      : super(ContributorInitialState());

  void loadContributor(String albumId, String contributorId) async {
    this.albumId = albumId;
    try {
      emit(ContributorLoadingState());
      contributor = await albumRepository.getContributorOfAlbumById(
          albumId, contributorId);
      PaginatedResponse<PrivateMemory> nextBatchOfMemories =
          await memoryRepository.getMemoriesOfUserInAlbum(
              albumId, contributorId, page, pageSize);
      memoriesOfUser.addAll(nextBatchOfMemories.content);
      emit(ContributorLoadedState(contributor, memoriesOfUser));
    } catch (e) {
      emit(ContributorErrorState(e.toString()));
    }
  }
}
