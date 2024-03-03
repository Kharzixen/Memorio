part 'moment_model.dart';
part 'collection_model.dart';
part 'comment_model.dart';

class AlbumHeaderInfo {
  String albumId;
  String name;
  String albumPicture;
  String albumDescription;
  int nrOfContributors;
  List<String> contributors;
  AlbumHeaderInfo({
    required this.albumId,
    required this.name,
    required this.nrOfContributors,
    required this.contributors,
    required this.albumPicture,
    required this.albumDescription,
  });
}

class AlbumPreview {
  String albumId;
  String name;
  String albumPicture;
  String caption;
  List<String> imageIds;

  AlbumPreview({
    required this.albumId,
    required this.name,
    required this.caption,
    required this.albumPicture,
    required this.imageIds,
  });
}
