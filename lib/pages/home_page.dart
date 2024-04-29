import 'package:flutter/material.dart';
import 'package:minimal_social_media/components/my_drawer.dart';
import 'package:minimal_social_media/components/my_list_tile.dart';
import 'package:minimal_social_media/components/my_post_button.dart';
import 'package:minimal_social_media/components/my_textfield.dart';
import 'package:minimal_social_media/database/firestore.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // firestore access
  final FirestoreDatabase database = FirestoreDatabase();

  // text controller
  final TextEditingController newPostController = TextEditingController();

  // onTap -> post Message
  void postMessage() {
    // only post message, if there is something in the textfield
    if (newPostController.text.isNotEmpty) {
      String message = newPostController.text;
      database.addPost(message);
    }

    // clear the controller
    newPostController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("W A L L"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          // TEXTFIELD for users to write/ type
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                // textfield
                Expanded(
                  child: MyTextField(
                    hintText: "Say something!!",
                    obscureText: false,
                    controller: newPostController,
                  ),
                ),

                // post button
                PostButton(onTap: postMessage),
              ],
            ),
          ),

          // posts
          StreamBuilder(
            stream: database.getPostsStream(),
            builder: (context, snapshot) {
              // show loading circle
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // get All Posts
              final posts = snapshot.data!.docs;

              // no Data?
              if (snapshot.data == null || posts.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text('No Posts.. Post Something!'),
                  ),
                );
              }

              // return as a list -> POSTS
              return Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    // get the individual posts
                    final post = posts[index];

                    // get data from each post
                    String message = post['PostMessage'];
                    String userEmail = post['UserEmail'];
                    // Timestamp timestamp = post['TimeStamp'];

                    // return as a List Tile
                    return MyListTile(title: message, subTitle: userEmail);
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
