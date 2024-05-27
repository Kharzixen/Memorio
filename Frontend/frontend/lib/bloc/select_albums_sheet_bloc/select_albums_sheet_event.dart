part of 'select_albums_sheet_bloc.dart';

sealed class SelectAlbumsSheetEvent {}

class NextAlbumsDatasetFetched extends SelectAlbumsSheetEvent {
  String userId;
  List<SimplePrivateAlbum> includedAlbums;
  NextAlbumsDatasetFetched(
      {required this.userId, required this.includedAlbums});
}

class AlbumAddedToIncluded extends SelectAlbumsSheetEvent {
  String albumId;
  AlbumAddedToIncluded({required this.albumId});
}

class AlbumRemovedFromIncluded extends SelectAlbumsSheetEvent {
  String albumId;
  AlbumRemovedFromIncluded({required this.albumId});
}
