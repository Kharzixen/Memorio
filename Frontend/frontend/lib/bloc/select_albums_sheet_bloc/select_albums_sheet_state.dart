part of 'select_albums_sheet_bloc.dart';

sealed class SelectAlbumsSheetState {}

class SelectAlbumsSheetInitialState extends SelectAlbumsSheetState {}

class SelectAlbumsSheetLoadingState extends SelectAlbumsSheetState {}

class SelectAlbumsSheetLoadedState extends SelectAlbumsSheetState {
  String userId;
  final Map<String, SimplePrivateAlbum> albums;
  final Map<String, SimplePrivateAlbum> includedAlbums;
  final bool hasMoreData;
  SelectAlbumsSheetLoadedState(
      {required this.userId,
      required this.albums,
      required this.includedAlbums,
      required this.hasMoreData});
}
