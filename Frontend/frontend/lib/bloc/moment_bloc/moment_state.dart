part of 'moment_bloc.dart';

sealed class MomentState {}

final class MomentInitialState extends MomentState {}

final class MomentLoadingState extends MomentState {}

final class MomentLoadedState extends MomentState {
  final DetailedMemory moment;
  final bool asyncMethodInProgress;
  MomentLoadedState(this.moment, this.asyncMethodInProgress);
}

final class MomentErrorState extends MomentState {
  final String errorMessage;
  MomentErrorState(this.errorMessage);
}

final class MomentDeletedState extends MomentState {}
