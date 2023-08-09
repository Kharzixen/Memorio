import 'package:flutter/material.dart';
import 'package:licence_frontend/components/page%20components/postCard.dart';

import '../../models/database.dart';

class StoriessPage extends StatefulWidget {
  const StoriessPage({super.key});

  @override
  State<StoriessPage> createState() => _StoriessPage();
}

class _StoriessPage extends State<StoriessPage> {
  bool isGrid = true;
  String dropDownValue = "Latest";

  @override
  Widget build(BuildContext context) {
    Data data = Data();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.send_rounded),
          ),
        ],
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
        child: Container(
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Stories!",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isGrid = !isGrid;
                        });
                      },
                      child: Icon(
                        isGrid ? Icons.view_list : Icons.grid_view,
                        color: Colors.white,
                      )),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              DropdownButton(
                  value: dropDownValue,
                  dropdownColor: Colors.grey.shade900,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  items: const [
                    DropdownMenuItem(
                      value: "Latest",
                      child: Text(
                        "Latest",
                      ),
                    ),
                    DropdownMenuItem(
                      value: "Most popular",
                      child: Text("Most popular"),
                    ),
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      dropDownValue = value!;
                    });
                  }),
              const SizedBox(
                height: 20,
              ),
              isGrid
                  ? GridView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: data.posts.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 10),
                      itemBuilder: (context, index) {
                        return Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    width: 2, color: Colors.grey.shade800),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: data.posts[index].img)));
                      })
                  : ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.posts.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 50),
                      itemBuilder: (context, index) => PostCard(
                            index: index,
                          )),
            ]),
          ),
        ),
      ),
    );
  }
}
