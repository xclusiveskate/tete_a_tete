import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tete_a_tete/UI/bottom/connection/user_profile.dart';
import 'package:tete_a_tete/UI/util/utils.dart';

class MyConnections extends StatefulWidget {
  const MyConnections({super.key});

  @override
  State<MyConnections> createState() => _MyConnectionsState();
}

class _MyConnectionsState extends State<MyConnections> {
  ScrollController scrollControl = ScrollController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            ListView.builder(
                controller: scrollControl,
                shrinkWrap: true,
                itemCount: 20,
                itemBuilder: (context, index) {
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
                        child: CircleAvatar(
                          backgroundColor: Colors.greenAccent,
                          child: Image.network(
                            'asset/images/avatar.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        "Stephen Kendrick Smith",
                        style: GoogleFonts.acme(fontWeight: FontWeight.bold),
                      ),
                      trailing: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent),
                          child: Text(
                            "Following",
                            style:
                                GoogleFonts.acme(fontWeight: FontWeight.bold),
                          )),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
