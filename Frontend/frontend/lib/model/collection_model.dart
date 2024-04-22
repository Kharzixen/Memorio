part of 'album_model.dart';

class CollectionPreview {
  String collectionId;
  String collectionName;
  DateTime creationDate;
  SimpleUser creator;
  String description;
  SimpleAlbum simpleAlbum;
  List<Memory> latestMemories;

  CollectionPreview({
    required this.collectionId,
    required this.collectionName,
    required this.creator,
    required this.creationDate,
    required this.simpleAlbum,
    required this.description,
    required this.latestMemories,
  });

  factory CollectionPreview.fromJson(Map<String, dynamic> json) {
    return CollectionPreview(
        collectionId: json['id'].toString(),
        collectionName: json['collectionName'] as String,
        description: json['collectionDescription'] == null
            ? "Default description"
            : json['collectionDescription'] as String,
        creationDate:
            DateTime.now(), //DateTime.parse(json['creationDate'] as String),
        latestMemories: (json['latestMemories'] as List<dynamic>)
            .map((e) => Memory.fromJson(e as Map<String, dynamic>))
            .toList(),
        creator: SimpleUser.fromMap(json['creator']),
        simpleAlbum: SimpleAlbum.fromJson(json['album']));
  }

  @override
  bool operator ==(Object other) {
    return (other is CollectionPreview) && other.collectionId == collectionId;
  }

  @override
  int get hashCode => super.hashCode;
}

class SimpleCollection {
  String collectionName;
  String collectionId;
  SimpleAlbum simpleAlbum;
  SimpleCollection(
      {required this.collectionId,
      required this.collectionName,
      required this.simpleAlbum});

  factory SimpleCollection.fromJson(Map<String, dynamic> json) {
    return SimpleCollection(
        collectionId: json['id'].toString(),
        collectionName: json['collectionName'] as String,
        simpleAlbum: SimpleAlbum.fromJson(json['album']));
  }

  static fromCollectionPreview(CollectionPreview collection) {
    return SimpleCollection(
        collectionId: collection.collectionId,
        collectionName: collection.collectionName,
        simpleAlbum: collection.simpleAlbum);
  }
}
