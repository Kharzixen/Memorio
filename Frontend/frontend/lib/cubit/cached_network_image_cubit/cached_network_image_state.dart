part of 'cached_network_image_cubit.dart';

sealed class CustomCachedNetworkImageState {}

class CachedNetworkImageInitialState extends CustomCachedNetworkImageState {}

class CachedNetworkImageLoading extends CustomCachedNetworkImageState {}

class CachedNetworkImageError extends CustomCachedNetworkImageState {
  String message;
  CachedNetworkImageError(this.message);
}

class CachedNetworkImageLoaded extends CustomCachedNetworkImageState {
  Uint8List imageBytes;
  CachedNetworkImageLoaded(this.imageBytes);
}
