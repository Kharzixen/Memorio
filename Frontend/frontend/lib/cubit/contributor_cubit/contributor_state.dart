part of 'contributor_cubit.dart';

sealed class ContributorState {}

class ContributorInitialState extends ContributorState {}

class ContributorLoadingState extends ContributorState {}

class ContributorErrorState extends ContributorState {
  String message;
  ContributorErrorState(this.message);
}

class ContributorLoadedState extends ContributorState {
  SimpleUser contributor;
  List<PrivateMemory> memories;
  ContributorLoadedState(this.contributor, this.memories);
}
