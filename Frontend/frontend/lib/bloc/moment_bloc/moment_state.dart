part of 'moment_bloc.dart';

sealed class MomentState {}

final class MomentInitialState extends MomentState {}

final class MomentLoadingState extends MomentState {}

final class MomentLoadedState extends MomentState {
  final DetailedMoment moment;
  final String contentToShow;
  MomentLoadedState(this.moment, this.contentToShow);
}

final class MomentErrorState extends MomentState {
  final String errorMessage;
  MomentErrorState(this.errorMessage);
}
