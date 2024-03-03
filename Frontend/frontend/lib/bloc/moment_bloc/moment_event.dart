part of 'moment_bloc.dart';

sealed class MomentEvent {}

final class MomentFetched extends MomentEvent {
  String momentId;
  String albumId;
  MomentFetched({required this.momentId, required this.albumId});
}

final class ContentChangedToLikes extends MomentEvent {}

final class ContentChangedToComments extends MomentEvent {}

