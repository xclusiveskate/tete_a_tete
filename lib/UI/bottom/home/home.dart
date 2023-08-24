import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tete_a_tete/Modell/post_model.dart';
import 'package:tete_a_tete/Modell/user_model.dart';
import 'package:tete_a_tete/UI/bottom/home/add_post.dart';
import 'package:tete_a_tete/UI/bottom/home/drawer.dart';
import 'package:tete_a_tete/UI/util/utils.dart';
import 'package:tete_a_tete/widgets/post_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  getUsers() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference<Map<String, dynamic>> collectionReference =
        firestore.collection('users');
    await collectionReference.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final user = doc;
        setState(() {
          users.add(UserModel.fromFirestore(user));
        });
      });
    }).catchError((error) {
      print('Error getting documents: $error');
    });
  }

  @override
  void initState() {
    getUsers();
    currentUserId = user!.uid;
    super.initState();
  }

  Stream<QuerySnapshot> postStream =
      FirebaseFirestore.instance.collection('posts').snapshots();

  User? user = FirebaseAuth.instance.currentUser;
  String? currentUserId;

  // likePost(
  //     {required String userId,
  //     required String postId,
  //     required bool currenUserLike}) {
  //   print(postId);
  //   final db = FirebaseFirestore.instance;
  //   var postToLike = db.collection('posts').doc(postId);
  //   if (currenUserLike) {
  //     postToLike.update({
  //       'likes': FieldValue.arrayRemove([userId])
  //     });
  //   } else {
  //     postToLike.update({
  //       'likes': FieldValue.arrayUnion([userId])
  //     });
  //   }
  // }

  int initialValue = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Icon(Icons.logo_dev),
        centerTitle: true,
        elevation: 0,
        actions: [
          // isSearching
          //     ? SizedBox(
          //         width: MediaQuery.of(context).size.width / 1.5,
          //         child: const TextField())
          //     : const SizedBox.shrink(),
          // IconButton(
          //     onPressed: () {
          //       setState(() {
          //         isSearching = !isSearching;
          //       });
          //     },
          // icon: const Icon(Icons.search)),
          // IconButton(onPressed: () {}, icon: const Icon(Icons.star_rate))

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: PopupMenuButton(
                initialValue: initialValue,
                onSelected: (value) {
                  print(value);
                  setState(() {
                    initialValue = value;
                  });
                },
                child: Row(
                  children: [
                    initialValue == 3
                        ? Icon(Icons.star)
                        : Icon(Icons.star_border_outlined),
                    Text("mode")
                  ],
                ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                        onTap: () {}, value: 1, child: Text("System Mode")),
                    PopupMenuItem(
                        onTap: () {}, value: 2, child: Text("Light Mode")),
                    PopupMenuItem(
                        onTap: () {}, value: 3, child: Text("Dark Mode")),
                  ];
                }),
          )
        ],
      ),
      drawer: const MyDrawer(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: postStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Unable to load data'));
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            heightFactor: 25,
                            child: Text(
                                '.....................................loading')),
                      ],
                    );
                  } else {
                    final List<QueryDocumentSnapshot> gottenPosts =
                        snapshot.data.docs;
                    List<PostModel> posts = gottenPosts
                        .map((document) => PostModel.fromFirestore(document))
                        .toList();
                    // List<PostModel> myModel = posts.map((e) => ).toList();
                    return PostWidget(
                        posts: posts,
                        gottenPosts: gottenPosts,
                        currentUserId: currentUserId);
                  }
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: () {
          push(context, const AddPosts());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
