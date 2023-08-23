import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tete_a_tete/Modell/post_model.dart';
import 'package:tete_a_tete/Modell/user_model.dart';
import 'package:tete_a_tete/UI/bottom/connection/user_profile.dart';
import 'package:tete_a_tete/UI/bottom/home/add_post.dart';
import 'package:tete_a_tete/UI/bottom/home/drawer.dart';
import 'package:tete_a_tete/UI/bottom/home/post_view.dart';
import 'package:tete_a_tete/controllers/service.dart';
import 'package:tete_a_tete/UI/util/utils.dart';

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
                    return ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final docRef = gottenPosts[index].reference.id;
                          final post = posts[index];
                          final posterDetails = users.firstWhere(
                              (element) => element.id == post.userId);

                          final hasTheCurrentUserLiked =
                              (post.likes as List).contains(currentUserId);

                          return InkWell(
                            onTap: () {
                              push(
                                  context,
                                  PostView(
                                    docRef: docRef,
                                    currentUser: currentUserId!,
                                    post: post,
                                    user: posterDetails,
                                    isLiked: hasTheCurrentUserLiked,
                                  ));
                              print(docRef);
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                        color:
                                            Color.fromARGB(255, 201, 201, 201),
                                        width: 0.5,
                                      ),
                                      bottom: BorderSide(
                                        color:
                                            Color.fromARGB(255, 193, 193, 193),
                                        width: 0.5,
                                      ))),
                              child: ListTile(
                                leading: InkWell(
                                  onTap: () {
                                    push(context, const UserProfile());
                                  },
                                  child: posterDetails.profileImageUrl == null
                                      ? CircleAvatar(
                                          backgroundColor: Colors.greenAccent,
                                          child: Image.asset(
                                            'asset/images/avatar.jpg',
                                            fit: BoxFit.cover,
                                          ))
                                      : CircleAvatar(
                                          backgroundColor: Colors.greenAccent,
                                          backgroundImage: NetworkImage(
                                              posterDetails.profileImageUrl!),
                                        ),
                                ),
                                title: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            '${posterDetails.firstName!} ${posterDetails.lastName!}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                          '@${posterDetails.userName!}',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        const Text("11 Oct"),
                                        IconButton(
                                            onPressed: () async {},
                                            icon: const Icon(Icons.more_vert))
                                      ],
                                    ),
                                    Text(post.content),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                      Icons.comment)),
                                              Text(
                                                  '${post.comments.length.toString()} ')
                                            ],
                                          ),
                                        ),
                                        // Container(
                                        //   child: Row(
                                        //     children: [
                                        //       IconButton(
                                        //           onPressed: () {},
                                        //           icon: const Icon(
                                        //               Icons.roller_shades)),
                                        //       Text(post['comments']
                                        //           .length
                                        //           .toString())
                                        //     ],
                                        //   ),
                                        // ),
                                        Container(
                                          child: Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    ServiceCall.likePost(
                                                        userId: currentUserId!,
                                                        postId: docRef,
                                                        currentUserLike:
                                                            hasTheCurrentUserLiked);
                                                  },
                                                  icon: hasTheCurrentUserLiked
                                                      ? Icon(Icons
                                                          .favorite_rounded)
                                                      : Icon(Icons
                                                          .favorite_outline)),
                                              Text(
                                                  '${post.likes!.length.toString()}')
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {},
                                                  icon:
                                                      const Icon(Icons.share)),
                                              const Text('')
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
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
