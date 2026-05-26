import 'package:flutter/material.dart';

class ExperienceFeedPage extends StatefulWidget {
  const ExperienceFeedPage({super.key});

  @override
  State<ExperienceFeedPage> createState() => _ExperienceFeedPageState();
}

class _ExperienceFeedPageState extends State<ExperienceFeedPage> {
  final Color primaryBlue = const Color(0xFF003366);

  List<Map<String, dynamic>> posts = [
    {
      "name": "Rahim Ahmed",
      "department": "CSE",
      "text": "Room is clean but food is average.",
      "image": "https://images.unsplash.com/photo-1590490360182-c33d57733427",
      "likes": 24,
      "comments": 5,
      "isLiked": false,
    },
    {
      "name": "Sadia Islam",
      "department": "BBA",
      "text": "Hostel environment is peaceful and friendly.",
      "image":
          "https://images.unsplash.com/photo-1555854877-bab0e564b8d5?auto=format&fit=crop&w=800",
      "likes": 18,
      "comments": 3,
      "isLiked": false,
    },
    {
      "name": "Tanvir Hasan",
      "department": "EEE",
      "text": "Food is good but WiFi is slow sometimes.",
      "image": "https://images.unsplash.com/photo-1556911220-bff31c812dba",
      "likes": 31,
      "comments": 7,
      "isLiked": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FF),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "Student Experiences",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: primaryBlue),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// USER INFO
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: primaryBlue,
                      child: Text(
                        post["name"][0],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post["name"],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          post["department"],
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// TEXT
                Text(post["text"], style: const TextStyle(fontSize: 15)),

                const SizedBox(height: 10),

                /// IMAGE
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    post["image"],
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 10),

                /// LIKE & COMMENT
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        post["isLiked"]
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: post["isLiked"] ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          post["isLiked"] = !post["isLiked"];

                          if (post["isLiked"]) {
                            post["likes"]++;
                          } else {
                            post["likes"]--;
                          }
                        });
                      },
                    ),
                    Text("${post["likes"]}"),

                    const SizedBox(width: 20),

                    const Icon(Icons.comment, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text("${post["comments"]}"),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
