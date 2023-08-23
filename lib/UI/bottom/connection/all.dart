import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tete_a_tete/Modell/user_model.dart';
// import 'package:tete_a_tete/Modell/user_model.dart';
import 'package:tete_a_tete/UI/bottom/connection/user_profile.dart';
import 'package:tete_a_tete/UI/util/utils.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  ScrollController scrollControl = ScrollController();
  String currentUserId = '';
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    currentUserId = user!.uid;
    super.initState();
  }

  final userCollection = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> userStream = userCollection.snapshots();

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: userStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error while loading data"),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (!snapshot.hasData) {
                    return Text("No data");
                  }
                  List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
                  List<UserModel> users = documents
                      .map((document) => UserModel.fromFirestore(document))
                      .toList();

                  return ListView.builder(
                      controller: scrollControl,
                      shrinkWrap: true,
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0.0, vertical: 0.0),
                          child: ListTile(
                            onTap: () {
                              push(context, const UserProfile());
                            },
                            contentPadding: const EdgeInsets.all(8.0),
                            leading: SizedBox(
                              width: 70,
                              height: 70,
                              child: user.profileImageUrl == null
                                  ? CircleAvatar(
                                      backgroundColor: Colors.greenAccent,
                                      child: Image.asset(
                                        'asset/images/avatar.jpg',
                                        fit: BoxFit.cover,
                                      ))
                                  : CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        user.profileImageUrl!,
                                        // scale: 20.0,
                                      ),
                                    ),
                            ),
                            title: Text(
                              '${user.firstName}  ${user.lastName}',
                              style: GoogleFonts.acme(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            trailing: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: index % 2 == 1
                                        ? Colors.greenAccent
                                        : null),
                                child: index % 2 == 0
                                    ? Text(
                                        "Follow",
                                        style: GoogleFonts.acme(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Text(
                                        "Following",
                                        style: GoogleFonts.acme(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold),
                                      )),
                          ),
                        );
                      });
                }),
          ],
        ),
      ),
    );
  }
}
