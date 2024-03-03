import 'package:frontend/model/album_model.dart';

class AlbumRepository {
  Future<List<AlbumPreview>> getAlbumPreviewById(String userId) async {
    await Future.delayed(Duration(seconds: 1));
    return <AlbumPreview>[
      AlbumPreview(
          albumId: "1",
          name: "Friend group demo",
          caption: "Unbelievable adventures together",
          albumPicture: "https://c.stocksy.com/a/tplJ00/z9/4712117.jpg",
          imageIds: [
            "http://static3.depositphotos.com/1005782/208/i/450/depositphotos_2088010-Silver-light-and-cheering-crowd.jpg",
            "https://c.stocksy.com/a/lplJ00/z9/4712109.jpg",
            "https://c.stocksy.com/a/mplJ00/z9/4712110.jpg",
            "https://as2.ftcdn.net/v2/jpg/06/52/00/59/500_F_652005941_98aPE8bSq0u3KR4UqQ6xhNK2cSiENlcK.jpg"
          ]),
      AlbumPreview(
          albumId: "2",
          name: "Hiking Demo",
          caption: "Memories made in nature",
          albumPicture:
              "https://img.freepik.com/premium-photo/young-traveler-hiking-girl-with-backpacks-hiking-mountains-sunny-landscape-tourist-traveler-background-view-mockup-high-tatras-slovakia_527096-5340.jpg",
          imageIds: [
            "https://c.stocksy.com/a/FMJI00/z9/4364319.jpg",
            "https://c.stocksy.com/a/C93N00/z9/5493646.jpg",
            "https://c.stocksy.com/a/NdcF00/z9/3723433.jpg",
            "https://c.stocksy.com/a/r28A00/z9/2414209.jpg"
          ]),
      AlbumPreview(
          albumId: "3",
          name: "Loving memories demo",
          caption: "Memories meant to happen, love meant to be",
          albumPicture:
              "https://www.everypixel.com/preview_collections/20230814/couple_in_love_7",
          imageIds: [
            "https://cdn.stocksnap.io/img-thumbs/960w/couple-holding_WCZBVEEQKC.jpg",
            "https://cdn.stocksnap.io/img-thumbs/960w/couple-bedroom_ZZEIZLP6ZD.jpg",
            "https://c.stocksy.com/a/6ReC00/z9/3015376.jpg",
            "https://c.stocksy.com/a/PnhN00/z9/5649899.jpg"
          ]),
      AlbumPreview(
          albumId: "4",
          name: "Wedding Demo",
          caption: "Happiest day of our lives",
          albumPicture:
              "http://static.everypixel.com/ep-pixabay/1154/2226/6752/64188/11542226675264188872-wedding.jpg",
          imageIds: [
            "https://images.pexels.com/photos/1696871/pexels-photo-1696871.jpeg?cs=srgb&dl=dress-elegance-fun-1696871.jpg&fm=jpg",
            "https://images.pexels.com/photos/13110257/pexels-photo-13110257.jpeg?auto=compress&cs=tinysrgb&h=650&w=940",
            "http://static.everypixel.com/ep-pixabay/0465/0956/5450/94853/4650956545094853485-wedding.jpg",
            "https://images.pexels.com/photos/59884/pexels-photo-59884.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200"
          ]),
    ];
  }

  Future<AlbumHeaderInfo> getAlbumHeaderInfo(String albumId) async {
    await Future.delayed(Duration(seconds: 1));
    switch (albumId) {
      case "1":
        return AlbumHeaderInfo(
          albumId: albumId,
          name: "Friend group demo",
          albumPicture: "https://c.stocksy.com/a/tplJ00/z9/4712117.jpg",
          albumDescription: "asd asd description ",
          nrOfContributors: 5,
          contributors: [
            "https://c.stocksy.com/a/QYmD00/z9/3284910.jpg",
            "https://c.stocksy.com/a/z2t000/z9/211605.jpg",
            "https://c.stocksy.com/a/s01G00/za/3817146.jpg",
            "https://c.stocksy.com/a/ZQVJ00/z9/4649043.jpg",
          ],
        );
      default:
        return AlbumHeaderInfo(
          albumId: albumId,
          name: "Friend group demo",
          albumPicture: "https://c.stocksy.com/a/tplJ00/z9/4712117.jpg",
          albumDescription: "asd asd description ",
          nrOfContributors: 10,
          contributors: [
            "https://c.stocksy.com/a/QYmD00/z9/3284910.jpg",
            "https://c.stocksy.com/a/z2t000/z9/211605.jpg",
            "https://c.stocksy.com/a/s01G00/za/3817146.jpg"
          ],
        );
    }
  }

  Future<List<Moment>> getEntriesByTimeline(
      String albumId, int pageNumber) async {
    await Future.delayed(Duration(seconds: 1));
    if (pageNumber == 0) {
      return <Moment>[
        Moment(
            entryId: "1",
            userId: "1",
            username: "Paul",
            date: DateTime.parse("2024-01-03 02:48:04"),
            photo: "https://c.stocksy.com/a/LnxD00/za/3328119.jpg"),
        Moment(
            entryId: "2",
            userId: "1",
            username: "Paul",
            date: DateTime.parse("2024-01-03 02:48:04"),
            photo: "https://c.stocksy.com/a/FueN00/za/5638791.jpg"),
        Moment(
            entryId: "3",
            userId: "1",
            username: "Paul",
            date: DateTime.parse("2024-01-02 02:48:04"),
            photo: "https://c.stocksy.com/a/Cw3O00/z9/5735012.jpg"),
        Moment(
            entryId: "4",
            userId: "1",
            username: "Paul",
            date: DateTime.parse("2024-01-01 02:48:04"),
            photo: "https://c.stocksy.com/a/hplJ00/z9/4712105.jpg"),
        Moment(
            entryId: "5",
            userId: "1",
            username: "Paul",
            date: DateTime.parse("2024-01-01 02:27:04"),
            photo: "https://c.stocksy.com/a/q7pJ00/za/4724762.jpg"),
        Moment(
            entryId: "6",
            userId: "1",
            username: "Paul",
            date: DateTime.parse("2024-01-01 01:22:04"),
            photo: "https://c.stocksy.com/a/qEwI00/za/4513776.jpg"),
      ];
    }
    if (pageNumber == 1) {
      return [
        Moment(
            entryId: "7",
            userId: "1",
            username: "Paul",
            date: DateTime.parse("2024-01-01 01:18:04"),
            photo: "https://c.stocksy.com/a/AIPO00/za/5817098.jpg"),
        Moment(
            entryId: "8",
            userId: "2",
            username: "June",
            date: DateTime.parse("2023-12-31 20:18:35"),
            photo: "https://c.stocksy.com/a/lplJ00/z9/4712109.jpg"),
        Moment(
            entryId: "9",
            userId: "1",
            username: "Paul",
            date: DateTime.parse("2023-12-31 20:19:12"),
            photo: "https://c.stocksy.com/a/mplJ00/z9/4712110.jpg"),
        Moment(
            entryId: "10",
            userId: "1",
            username: "Paul",
            date: DateTime.parse("2023-12-25 20:18:04"),
            photo: "https://c.stocksy.com/a/2dAL00/z9/5045748.jpg"),
        Moment(
            entryId: "11",
            userId: "2",
            username: "June",
            date: DateTime.parse("2023-12-25 20:18:35"),
            photo: "https://c.stocksy.com/a/fdAL00/z9/5045787.jpg"),
        Moment(
            entryId: "12",
            userId: "1",
            username: "Paul",
            date: DateTime.parse("2023-12-25 20:19:12"),
            photo: "https://c.stocksy.com/a/JrQO00/z9/5823121.jpg"),
      ];
    } else {
      return [];
    }
  }

  Future<List<CollectionPreview>> getCollections(
      String albumId, int page) async {
    await Future.delayed(Duration(seconds: 1));
    return [
      CollectionPreview(
          collectionName: "Espresso Expedition",
          creationDate: DateTime.parse("2024-01-02 18:33:12"),
          previewEntries: [
            Moment(
                entryId: albumId + "_1",
                userId: "1",
                username: "Paul",
                date: DateTime.parse("2024-01-03 02:48:04"),
                photo: "https://c.stocksy.com/a/LnxD00/za/3328119.jpg"),
            Moment(
                entryId: albumId + "_1",
                userId: "1",
                username: "Paul",
                date: DateTime.parse("2024-01-03 02:48:04"),
                photo: "https://c.stocksy.com/a/FueN00/za/5638791.jpg"),
            Moment(
                entryId: albumId + "_1",
                userId: "1",
                username: "Paul",
                date: DateTime.parse("2024-01-02 02:48:04"),
                photo: "https://c.stocksy.com/a/Cw3O00/z9/5735012.jpg"),
          ]),
      CollectionPreview(
          collectionName: "New Year's Eve Party",
          creationDate: DateTime.parse("2023-12-31 12:35:18"),
          previewEntries: [
            Moment(
                entryId: albumId + "_1",
                userId: "1",
                username: "Paul",
                date: DateTime.parse("2024-01-01 02:48:04"),
                photo: "https://c.stocksy.com/a/hplJ00/z9/4712105.jpg"),
            Moment(
                entryId: albumId + "_1",
                userId: "1",
                username: "Paul",
                date: DateTime.parse("2024-01-01 02:27:04"),
                photo: "https://c.stocksy.com/a/q7pJ00/za/4724762.jpg"),
            Moment(
                entryId: albumId + "_1",
                userId: "1",
                username: "Paul",
                date: DateTime.parse("2024-01-01 01:22:04"),
                photo: "https://c.stocksy.com/a/qEwI00/za/4513776.jpg"),
            Moment(
                entryId: albumId + "_1",
                userId: "1",
                username: "Paul",
                date: DateTime.parse("2024-01-01 01:18:04"),
                photo: "https://c.stocksy.com/a/AIPO00/za/5817098.jpg"),
          ]),
      CollectionPreview(
          collectionName: "Christmas Dinner",
          creationDate: DateTime.parse("2023-12-31 12:35:18"),
          previewEntries: [
            Moment(
                entryId: albumId + "_1",
                userId: "1",
                username: "Paul",
                date: DateTime.parse("2023-12-25 20:18:04"),
                photo: "https://c.stocksy.com/a/2dAL00/z9/5045748.jpg"),
            Moment(
                entryId: albumId + "_2",
                userId: "2",
                username: "June",
                date: DateTime.parse("2023-12-25 20:18:35"),
                photo: "https://c.stocksy.com/a/fdAL00/z9/5045787.jpg"),
            Moment(
                entryId: albumId + "_3",
                userId: "1",
                username: "Paul",
                date: DateTime.parse("2023-12-25 20:19:12"),
                photo: "https://c.stocksy.com/a/JrQO00/z9/5823121.jpg"),
          ]),
    ];
  }

  Future<Moment> getMomentById(String albumId, String momentId) async {
    await Future.delayed(Duration(seconds: 1)); // Simulating some delay

    switch (momentId) {
      case '1':
        return Moment(
          entryId: "1",
          userId: "1",
          username: "Paul",
          date: DateTime.parse("2024-01-03 02:48:04"),
          photo: "https://c.stocksy.com/a/LnxD00/za/3328119.jpg",
        );
      case '2':
        return Moment(
          entryId: "2",
          userId: "1",
          username: "Paul",
          date: DateTime.parse("2024-01-03 02:48:04"),
          photo: "https://c.stocksy.com/a/FueN00/za/5638791.jpg",
        );
      case '3':
        return Moment(
          entryId: "3",
          userId: "1",
          username: "Paul",
          date: DateTime.parse("2024-01-02 02:48:04"),
          photo: "https://c.stocksy.com/a/Cw3O00/z9/5735012.jpg",
        );
      case '4':
        return Moment(
          entryId: "4",
          userId: "1",
          username: "Paul",
          date: DateTime.parse("2024-01-01 02:48:04"),
          photo: "https://c.stocksy.com/a/hplJ00/z9/4712105.jpg",
        );
      case '5':
        return Moment(
          entryId: "5",
          userId: "1",
          username: "Paul",
          date: DateTime.parse("2024-01-01 02:27:04"),
          photo: "https://c.stocksy.com/a/q7pJ00/za/4724762.jpg",
        );
      case '6':
        return Moment(
          entryId: "6",
          userId: "1",
          username: "Paul",
          date: DateTime.parse("2024-01-01 01:22:04"),
          photo: "https://c.stocksy.com/a/qEwI00/za/4513776.jpg",
        );
      case '7':
        return Moment(
          entryId: "7",
          userId: "1",
          username: "Paul",
          date: DateTime.parse("2024-01-01 01:18:04"),
          photo: "https://c.stocksy.com/a/AIPO00/za/5817098.jpg",
        );
      case '8':
        return Moment(
          entryId: "8",
          userId: "2",
          username: "June",
          date: DateTime.parse("2023-12-31 20:18:35"),
          photo: "https://c.stocksy.com/a/lplJ00/z9/4712109.jpg",
        );
      case '9':
        return Moment(
          entryId: "9",
          userId: "1",
          username: "Paul",
          date: DateTime.parse("2023-12-31 20:19:12"),
          photo: "https://c.stocksy.com/a/mplJ00/z9/4712110.jpg",
        );
      case '10':
        return Moment(
          entryId: "10",
          userId: "1",
          username: "Paul",
          date: DateTime.parse("2023-12-25 20:18:04"),
          photo: "https://c.stocksy.com/a/2dAL00/z9/5045748.jpg",
        );
      case '11':
        return Moment(
          entryId: "11",
          userId: "2",
          username: "June",
          date: DateTime.parse("2023-12-25 20:18:35"),
          photo: "https://c.stocksy.com/a/fdAL00/z9/5045787.jpg",
        );
      case '12':
        return Moment(
          entryId: "12",
          userId: "1",
          username: "Paul",
          date: DateTime.parse("2023-12-25 20:19:12"),
          photo: "https://c.stocksy.com/a/JrQO00/z9/5823121.jpg",
        );
      default:
        return Moment(
          entryId: "null",
          userId: "1",
          username: "Paul",
          date: DateTime.parse("2023-12-25 20:19:12"),
          photo: "https://c.stocksy.com/a/JrQO00/z9/5823121.jpg",
        );
    }
  }
}
