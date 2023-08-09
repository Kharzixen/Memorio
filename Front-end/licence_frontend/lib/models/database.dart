import 'package:flutter/material.dart';
import 'package:licence_frontend/models/announcement.dart';
import 'package:licence_frontend/models/location.dart';
import 'package:licence_frontend/models/post.dart';
import 'package:licence_frontend/models/thought.dart';
import 'package:licence_frontend/models/user.dart';

class Data {
  ProfileUser profile = ProfileUser(
    username: "Nicole",
    email: "nicole.nicole@gmail.com",
    allLikesCount: 0,
    postsCount: 0,
    followersCount: 321,
    pfp: NetworkImage(
        "https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8cG9ydHJhaXR8ZW58MHx8MHx8fDA%3D&w=1000&q=80"),
  );

  final NightlifeLocation festivalProfile = NightlifeLocation(
      name: "BestFest",
      bio: "Lejobb hely",
      allLikesCount: 0,
      postsCount: 0,
      followersCount: 321,
      pfp: NetworkImage(
          "https://blog.erasmusgeneration.org/sites/default/files/articles/2022-02/576364502a3f379b77617193680e21ff.jpg"));

  late List<Announcement> announcements = [
    Announcement(
        text:
            "\"Join us for a weekend filled with music, art, and endless fun at the Grand Festival Extravaganza! Experience the magic of live performances from top artists, indulge in delicious food from local vendors, and immerse yourself in a vibrant atmosphere of creativity and joy. ",
        location: festivalProfile,
        date: "2023.07.21",
        likeCount: 10),
    Announcement(
        text:
            "\"Don your most elegant masks and join us for the Enchanted Masquerade Ball, an evening of elegance, mystery, and fantasy. Dance the night away to live music, enjoy delightful refreshments, and partake in the thrilling masked costume contest",
        location: festivalProfile,
        date: "2023.07.25",
        likeCount: 10),
    Announcement(
        text:
            "\"We're thrilled to invite you to Harmony Fest, a one-of-a-kind festival celebrating diversity and unity in our community. Experience the richness of different cultures through mesmerizing performances, cultural exhibits, and interactive workshops.",
        location: festivalProfile,
        date: "2023.08.01",
        likeCount: 10),
  ];

  List<User> users = [
    User(
      username: "Mario",
      allLikesCount: 3528,
      postsCount: 22,
      followersCount: 321,
      pfp: NetworkImage(
          "https://img.freepik.com/free-photo/portrait-white-man-isolated_53876-40306.jpg"),
    ),
    User(
        username: "Bianca",
        allLikesCount: 218,
        postsCount: 5,
        followersCount: 128,
        pfp: const NetworkImage(
            "https://images.unsplash.com/photo-1603775020644-eb8decd79994?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cG9ydHJhaXQlMjBwaG90b2dyYXBoeXxlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80")),
    User(
        allLikesCount: 218,
        postsCount: 5,
        followersCount: 128,
        username: "Emily",
        pfp: const NetworkImage(
            "https://i.pinimg.com/originals/3e/2e/8c/3e2e8c6fa626636eb4e8bdfe78edab3b.jpg")),
    User(
        allLikesCount: 218,
        postsCount: 5,
        followersCount: 128,
        username: "Josh",
        pfp: const NetworkImage(
            "https://www.format.com/wp-content/uploads/portrait_of_black_man.jpg")),
  ];

  late List<Thought> thoughts = [
    Thought(
        text:
            "“I'm selfish, impatient and a little insecure. I make mistakes, I am out of control and at times hard to handle. But if you can't handle me at my worst, then you sure as hell don't deserve me at my best.”― Marilyn Monroe ",
        user: users[1],
        date: "2023.08.01",
        likeCount: 15),
    Thought(
        text:
            "“Two things are infinite: the universe and human stupidity; and I'm not sure about the universe.” - Albert Einstein ",
        user: users[0],
        date: "2023.08.02",
        likeCount: 13),
    Thought(
        text:
            "“Be who you are and say what you feel, because those who mind don't matter, and those who matter don't mind.”― Bernard M. Baruch",
        user: users[1],
        date: "2023.08.03",
        likeCount: 35),
    Thought(
        text:
            "“I'm selfish, impatient and a little insecure. I make mistakes, I am out of control and at times hard to handle. But if you can't handle me at my worst, then you sure as hell don't deserve me at my best.”― Marilyn Monroe ",
        user: users[0],
        date: "2023.08.02",
        likeCount: 44),
  ];

  late List<Post> posts = [
    Post(
        caption: "asdasd asd as dasdas daads asdasdasdasdad",
        user: users[2],
        likeCount: 15,
        date: "2023.07.29 16:33",
        img: const NetworkImage(
            "https://images.pexels.com/photos/3379261/pexels-photo-3379261.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")),
    Post(
      caption:
          "Egy egy almafa ez egy naaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaagyoooooooooooooooooooooooooooooon hosszu cation",
      user: users[0],
      likeCount: 33,
      date: "2023.07.30",
      img: const NetworkImage(
          "https://images.pexels.com/photos/6224705/pexels-photo-6224705.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
    ),
    Post(
        caption: "Ketto ket katica harom harom kiskacsa",
        user: users[3],
        likeCount: 87,
        date: "2023.08.01",
        img: const NetworkImage(
            "https://images.pexels.com/photos/8153993/pexels-photo-8153993.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")),
    Post(
        caption: "Ketto ket katica harom harom kiskacsa",
        user: users[3],
        likeCount: 87,
        date: "2023.08.01",
        img: const NetworkImage(
            "https://images.squarespace-cdn.com/content/v1/5a3edb6249fc2b12a2c8ea49/1584908766086-SCB9O95VP9TQRFF6LWSU/Elkhart_Sweet_16_Party_DJ.JPG?format=1500w")),
    Post(
      caption:
          "Egy egy almafa ez egy naaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaagyoooooooooooooooooooooooooooooon hoooooooooooooooooooooooooooossssssssssssssssssssssssssssszuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu caption",
      user: users[0],
      likeCount: 33,
      date: "2023.07.30",
      img: const NetworkImage(
          "https://thumbs.dreamstime.com/b/party-people-dancing-disco-club-21338671.jpg"),
    ),
    Post(
        caption: "Ketto ket katica harom harom kiskacsa",
        user: users[3],
        likeCount: 87,
        date: "2023.08.01",
        img: const NetworkImage(
            "https://t3.ftcdn.net/jpg/02/87/35/70/360_F_287357045_Ib0oYOxhotdjOEHi0vkggpZTQCsz0r19.jpg")),
    Post(
        caption: "Ketto ket katica harom harom kiskacsa",
        user: users[3],
        likeCount: 87,
        date: "2023.08.01",
        img: const NetworkImage(
            "https://images.squarespace-cdn.com/content/v1/5a3edb6249fc2b12a2c8ea49/1584908766086-SCB9O95VP9TQRFF6LWSU/Elkhart_Sweet_16_Party_DJ.JPG?format=1500w")),
    Post(
      caption:
          "Egy egy almafa ez egy naaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaagyoooooooooooooooooooooooooooooon hosszu cation",
      user: users[0],
      likeCount: 33,
      date: "2023.07.30",
      img: const NetworkImage(
          "https://thumbs.dreamstime.com/b/party-people-dancing-disco-club-21338671.jpg"),
    ),
    Post(
        caption: "Ketto ket katica harom harom kiskacsa",
        user: users[3],
        likeCount: 87,
        date: "2023.08.01",
        img: const NetworkImage(
            "https://t3.ftcdn.net/jpg/02/87/35/70/360_F_287357045_Ib0oYOxhotdjOEHi0vkggpZTQCsz0r19.jpg")),
    Post(
        caption: "Ketto ket katica harom harom kiskacsa",
        user: users[3],
        likeCount: 87,
        date: "2023.08.01",
        img: const NetworkImage(
            "https://images.squarespace-cdn.com/content/v1/5a3edb6249fc2b12a2c8ea49/1584908766086-SCB9O95VP9TQRFF6LWSU/Elkhart_Sweet_16_Party_DJ.JPG?format=1500w")),
  ];

  List<NetworkImage> myPhotoes = [
    const NetworkImage(
        "https://media.istockphoto.com/id/535403859/photo/dancing-at-disco.jpg?b=1&s=612x612&w=0&k=20&c=AT5jHnpqZ55vKjeJfuArp24OrRt8R2mAHT_rVPYFv0A="),
    const NetworkImage(
        "https://images.unsplash.com/photo-1593958812614-2db6a598c71c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1yZWxhdGVkfDE0fHx8ZW58MHx8fHx8&w=1000&q=80"),
    const NetworkImage(
        "https://cdn.britannica.com/42/213242-050-CA42146E/Rally-Bharatiya-Janata-Party-BJP-Narendra-Modi-India-April-2019.jpg"),
    const NetworkImage(
        "https://thumbs.dreamstime.com/b/party-people-dancing-disco-club-21338671.jpg"),
    const NetworkImage(
        "https://plus.unsplash.com/premium_photo-1687826541778-3f2bf4c03bc3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cGFydHl8ZW58MHx8MHx8fDA%3D&w=1000&q=80"),
    const NetworkImage(
        "https://images.pexels.com/photos/3171837/pexels-photo-3171837.jpeg?cs=srgb&dl=pexels-cottonbro-studio-3171837.jpg&fm=jpg"),
    const NetworkImage(
        "https://t3.ftcdn.net/jpg/02/87/35/70/360_F_287357045_Ib0oYOxhotdjOEHi0vkggpZTQCsz0r19.jpg"),
    const NetworkImage(
        "https://images.squarespace-cdn.com/content/v1/5a3edb6249fc2b12a2c8ea49/1584908766086-SCB9O95VP9TQRFF6LWSU/Elkhart_Sweet_16_Party_DJ.JPG?format=1500w"),
  ];
}
