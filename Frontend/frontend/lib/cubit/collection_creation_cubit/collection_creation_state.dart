part of 'collection_creation_cubit.dart';

sealed class CollectionCreationState {}

class CollectionCreationInitialState extends CollectionCreationState {}

class CollectionCreationInProgressState extends CollectionCreationState {}

class CollectionCreationSuccessState extends CollectionCreationState {}

class CollectionCreationErrorState extends CollectionCreationState {
  final String message;
  CollectionCreationErrorState(this.message);
}
