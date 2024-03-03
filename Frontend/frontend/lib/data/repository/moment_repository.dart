import 'package:frontend/model/album_model.dart';

class MomentRepository {
  Future<DetailedMoment> getMomentById(String albumId, String momentId) async {
    await Future.delayed(Duration(seconds: 1)); // Simulating some delay

    switch (momentId) {
      case '1':
        return DetailedMoment(
          entryId: "1",
          likeCount: 5,
          userId: "1",
          caption: "asdasdasd caption",
          username: "paul_brnx",
          date: DateTime.parse("2024-01-03 14:48:04"),
          photo:
              "https://images.pexels.com/photos/10402280/pexels-photo-10402280.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
          likes: [
            LikeModel(
                userId: "1",
                username: "june_june",
                userpfp:
                    "https://images.pexels.com/photos/762020/pexels-photo-762020.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
            LikeModel(
                userId: "2",
                username: "paul_Xasd12",
                userpfp:
                    "https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
            LikeModel(
                userId: "3",
                username: "lily_zaasd12",
                userpfp:
                    "https://images.pexels.com/photos/20264870/pexels-photo-20264870/free-photo-of-young-woman-in-a-white-dress-and-white-sneakers-sitting-on-a-chair-between-plants.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
            LikeModel(
                userId: "1",
                username: "june_june",
                userpfp:
                    "https://images.pexels.com/photos/762020/pexels-photo-762020.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
            LikeModel(
                userId: "2",
                username: "paul_Xasd12",
                userpfp:
                    "https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
            LikeModel(
                userId: "3",
                username: "lily_zaasd12",
                userpfp:
                    "https://images.pexels.com/photos/20264870/pexels-photo-20264870/free-photo-of-young-woman-in-a-white-dress-and-white-sneakers-sitting-on-a-chair-between-plants.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
            LikeModel(
                userId: "1",
                username: "june_june",
                userpfp:
                    "https://images.pexels.com/photos/762020/pexels-photo-762020.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
            LikeModel(
                userId: "2",
                username: "paul_Xasd12",
                userpfp:
                    "https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
            LikeModel(
                userId: "3",
                username: "lily_zaasd12",
                userpfp:
                    "https://images.pexels.com/photos/20264870/pexels-photo-20264870/free-photo-of-young-woman-in-a-white-dress-and-white-sneakers-sitting-on-a-chair-between-plants.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
            LikeModel(
                userId: "1",
                username: "june_june",
                userpfp:
                    "https://images.pexels.com/photos/762020/pexels-photo-762020.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
            LikeModel(
                userId: "2",
                username: "paul_Xasd12",
                userpfp:
                    "https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
            LikeModel(
                userId: "3",
                username: "lily_zaasd12",
                userpfp:
                    "https://images.pexels.com/photos/20264870/pexels-photo-20264870/free-photo-of-young-woman-in-a-white-dress-and-white-sneakers-sitting-on-a-chair-between-plants.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
            LikeModel(
                userId: "1",
                username: "june_june",
                userpfp:
                    "https://images.pexels.com/photos/762020/pexels-photo-762020.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
            LikeModel(
                userId: "2",
                username: "paul_Xasd12",
                userpfp:
                    "https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
            LikeModel(
                userId: "3",
                username: "lily_zaasd12",
                userpfp:
                    "https://images.pexels.com/photos/20264870/pexels-photo-20264870/free-photo-of-young-woman-in-a-white-dress-and-white-sneakers-sitting-on-a-chair-between-plants.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
            LikeModel(
                userId: "1",
                username: "june_june",
                userpfp:
                    "https://images.pexels.com/photos/762020/pexels-photo-762020.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
            LikeModel(
                userId: "2",
                username: "paul_Xasd12",
                userpfp:
                    "https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
            LikeModel(
                userId: "3",
                username: "lily_zaasd12",
                userpfp:
                    "https://images.pexels.com/photos/20264870/pexels-photo-20264870/free-photo-of-young-woman-in-a-white-dress-and-white-sneakers-sitting-on-a-chair-between-plants.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")
          ],
          commentsCount: 0,
          comments: [
            Comment(
                userpfp:
                    "https://images.pexels.com/photos/762020/pexels-photo-762020.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
                commentId: "1",
                userId: "1",
                username: "june_june",
                date: DateTime.parse("2024-01-03 14:49:15"),
                text:
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
            Comment(
                userpfp:
                    "https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
                commentId: "2",
                userId: "2",
                username: "paul_Xasd12",
                date: DateTime.parse("2024-01-03 14:49:15"),
                text:
                    'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.'),
            Comment(
                userpfp:
                    "https://images.pexels.com/photos/762020/pexels-photo-762020.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
                commentId: "1",
                userId: "1",
                username: "june_june",
                date: DateTime.parse("2024-01-03 14:49:15"),
                text:
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
            Comment(
                userpfp:
                    "https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
                commentId: "2",
                userId: "2",
                username: "paul_Xasd12",
                date: DateTime.parse("2024-01-03 14:49:15"),
                text:
                    'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.'),
            Comment(
                userpfp:
                    "https://images.pexels.com/photos/762020/pexels-photo-762020.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
                commentId: "1",
                userId: "1",
                username: "june_june",
                date: DateTime.parse("2024-01-03 14:49:15"),
                text:
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
            Comment(
                userpfp:
                    "https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
                commentId: "2",
                userId: "2",
                username: "paul_Xasd12",
                date: DateTime.parse("2024-01-03 14:49:15"),
                text:
                    'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.'),
            Comment(
                userpfp:
                    "https://images.pexels.com/photos/762020/pexels-photo-762020.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
                commentId: "1",
                userId: "1",
                username: "june_june",
                date: DateTime.parse("2024-01-03 14:49:15"),
                text:
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
            Comment(
                userpfp:
                    "https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
                commentId: "2",
                userId: "2",
                username: "paul_Xasd12",
                date: DateTime.parse("2024-01-03 14:49:15"),
                text:
                    'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.'),
          ],
        );
      case '2':
        return DetailedMoment(
          entryId: "2",
          caption: "asdasdasd caption",
          userId: "1",
          likeCount: 2,
          username: "Paul",
          date: DateTime.parse("2024-01-03 14:48:04"),
          photo: "https://c.stocksy.com/a/FueN00/za/5638791.jpg",
          likes: [
            // LikeModel(
            //     userId: "1",
            //     username: "june_june",
            //     userpfp:
            //         "https://images.pexels.com/photos/762020/pexels-photo-762020.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
            // LikeModel(
            //     userId: "2",
            //     username: "paul_Xasd12",
            //     userpfp:
            //         "https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
            // LikeModel(
            //     userId: "3",
            //     username: "lily_zaasd12",
            //     userpfp:
            //         "https://images.pexels.com/photos/20264870/pexels-photo-20264870/free-photo-of-young-woman-in-a-white-dress-and-white-sneakers-sitting-on-a-chair-between-plants.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
          ],
          commentsCount: 0,
          comments: [
            // Comment(
            //     userpfp:
            //         "https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
            //     commentId: "2",
            //     userId: "2",
            //     username: "paul_Xasd12",
            //     date: DateTime.parse("2024-01-03 14:49:15"),
            //     text:
            //         'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.'),
          ],
        );
      case '3':
        return DetailedMoment(
          entryId: "3",
          userId: "1",
          likeCount: 4,
          caption: "asdasdasd caption",
          username: "Paul",
          date: DateTime.parse("2024-01-02 02:48:04"),
          photo: "https://c.stocksy.com/a/Cw3O00/z9/5735012.jpg",
          likes: [],
          commentsCount: 0,
          comments: [],
        );
      case '4':
        return DetailedMoment(
          entryId: "4",
          userId: "1",
          likeCount: 3,
          username: "Paul",
          caption: "asdasdasd caption",
          date: DateTime.parse("2024-01-01 02:48:04"),
          photo: "https://c.stocksy.com/a/hplJ00/z9/4712105.jpg",
          likes: [],
          commentsCount: 0,
          comments: [],
        );
      case '5':
        return DetailedMoment(
          entryId: "5",
          userId: "1",
          likeCount: 7,
          caption: "asdasdasd caption",
          username: "Paul",
          date: DateTime.parse("2024-01-01 02:27:04"),
          photo: "https://c.stocksy.com/a/q7pJ00/za/4724762.jpg",
          likes: [],
          commentsCount: 0,
          comments: [],
        );
      case '6':
        return DetailedMoment(
          entryId: "6",
          userId: "1",
          likeCount: 10,
          username: "Paul",
          caption: "asdasdasd caption",
          date: DateTime.parse("2024-01-01 01:22:04"),
          photo: "https://c.stocksy.com/a/qEwI00/za/4513776.jpg",
          likes: [],
          commentsCount: 0,
          comments: [],
        );
      case '7':
        return DetailedMoment(
          entryId: "7",
          likeCount: 3,
          userId: "1",
          username: "Paul",
          caption: "asdasdasd caption",
          date: DateTime.parse("2024-01-01 01:18:04"),
          photo: "https://c.stocksy.com/a/AIPO00/za/5817098.jpg",
          likes: [],
          commentsCount: 0,
          comments: [],
        );
      case '8':
        return DetailedMoment(
          entryId: "8",
          likeCount: 4,
          userId: "2",
          caption: "asdasdasd caption",
          username: "June",
          date: DateTime.parse("2023-12-31 20:18:35"),
          photo: "https://c.stocksy.com/a/lplJ00/z9/4712109.jpg",
          likes: [],
          commentsCount: 0,
          comments: [],
        );
      case '9':
        return DetailedMoment(
          entryId: "9",
          userId: "1",
          likeCount: 1,
          caption: "asdasdasd caption",
          username: "Paul",
          date: DateTime.parse("2023-12-31 20:19:12"),
          photo: "https://c.stocksy.com/a/mplJ00/z9/4712110.jpg",
          likes: [],
          commentsCount: 0,
          comments: [],
        );
      case '10':
        return DetailedMoment(
          entryId: "10",
          caption: "asdasdasd caption",
          userId: "1",
          likeCount: 0,
          username: "Paul",
          date: DateTime.parse("2023-12-25 20:18:04"),
          photo: "https://c.stocksy.com/a/2dAL00/z9/5045748.jpg",
          likes: [],
          commentsCount: 0,
          comments: [],
        );
      case '11':
        return DetailedMoment(
          entryId: "11",
          userId: "2",
          username: "June",
          likeCount: 12,
          caption: "asdasdasd caption",
          date: DateTime.parse("2023-12-25 20:18:35"),
          photo: "https://c.stocksy.com/a/fdAL00/z9/5045787.jpg",
          likes: [],
          commentsCount: 0,
          comments: [],
        );
      case '12':
        return DetailedMoment(
          entryId: "12",
          userId: "1",
          likeCount: 1555,
          caption: "asdasdasd caption",
          username: "Paul",
          date: DateTime.parse("2023-12-25 20:19:12"),
          photo: "https://c.stocksy.com/a/JrQO00/z9/5823121.jpg",
          likes: [],
          commentsCount: 0,
          comments: [],
        );
      default:
        return DetailedMoment(
          entryId: "null",
          userId: "1",
          likeCount: 8,
          caption: "asdasdasd caption",
          username: "Paul",
          date: DateTime.parse("2023-12-25 20:19:12"),
          photo: "https://c.stocksy.com/a/JrQO00/z9/5823121.jpg",
          likes: [],
          commentsCount: 0,
          comments: [],
        );
    }
  }
}
