part of 'following_suggestion_cubit.dart';

sealed class FollowingSuggestionState {}

class FollowingSuggestionInitialState extends FollowingSuggestionState {}

class FollowingSuggestionLoadingState extends FollowingSuggestionState {}

class FollowingSuggestionLoadedState extends FollowingSuggestionState {
  List<SimpleUserWithFollowedStatus> users;
  FollowingSuggestionLoadedState(this.users);
}

class FollowingSuggestionErrorState extends FollowingSuggestionState {
  String message;
  FollowingSuggestionErrorState(this.message);
}
