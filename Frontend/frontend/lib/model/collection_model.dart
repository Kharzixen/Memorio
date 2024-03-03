part of 'album_model.dart';

class CollectionPreview {
  String collectionName;
  DateTime creationDate;
  List<Moment> previewEntries;

  CollectionPreview({
    required this.collectionName,
    required this.creationDate,
    required this.previewEntries,
  });
}
