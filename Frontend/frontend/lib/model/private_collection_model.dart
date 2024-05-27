part of 'private-album_model.dart';

class PrivateCollectionPreview {
  String collectionId;
  String collectionName;
  DateTime creationDate;
  SimpleUser creator;
  String description;
  SimplePrivateAlbum simpleAlbum;
  List<PrivateCollectionMemory> latestMemories;

  PrivateCollectionPreview({
    required this.collectionId,
    required this.collectionName,
    required this.creator,
    required this.creationDate,
    required this.simpleAlbum,
    required this.description,
    required this.latestMemories,
  });

  factory PrivateCollectionPreview.fromJson(Map<String, dynamic> json) {
    return PrivateCollectionPreview(
        collectionId: json['id'].toString(),
        collectionName: json['collectionName'] as String,
        description: json['collectionDescription'] == null
            ? "Default description"
            : json['collectionDescription'] as String,
        creationDate: DateTime.parse(json[
            'creationDate']), //DateTime.parse(json['creationDate'] as String),
        latestMemories: json['latestMemories'] != null
            ? (json['latestMemories'] as List<dynamic>)
                .map((e) =>
                    PrivateCollectionMemory.fromJson(e as Map<String, dynamic>))
                .toList()
            : [],
        creator: SimpleUser.fromMap(json['creator']),
        simpleAlbum: SimplePrivateAlbum.fromJson(json['album']));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return (other is PrivateCollectionPreview) &&
        other.collectionId == collectionId;
  }

  @override
  int get hashCode => collectionId.hashCode;
}

class SimplePrivateCollection {
  String collectionName;
  String collectionId;
  SimplePrivateAlbum simpleAlbum;
  SimplePrivateCollection(
      {required this.collectionId,
      required this.collectionName,
      required this.simpleAlbum});

  factory SimplePrivateCollection.fromJson(Map<String, dynamic> json) {
    return SimplePrivateCollection(
        collectionId: json['id'].toString(),
        collectionName: json['collectionName'] as String,
        simpleAlbum: SimplePrivateAlbum.fromJson(json['album']));
  }

  static fromCollectionPreview(PrivateCollectionPreview collection) {
    return SimplePrivateCollection(
        collectionId: collection.collectionId,
        collectionName: collection.collectionName,
        simpleAlbum: collection.simpleAlbum);
  }
}
