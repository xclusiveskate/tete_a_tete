import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:side_sheet_material3/side_sheet_material3.dart';
import 'package:tete_a_tete/Modell/post_model.dart';
import 'package:tete_a_tete/Modell/user_model.dart';
import 'package:tete_a_tete/UI/bottom/home/add_comment.dart';
import 'package:tete_a_tete/controllers/service.dart';
import 'package:tete_a_tete/UI/util/utils.dart';

class PostView extends StatefulWidget {
  final PostModel post;
  final UserModel user;
  final bool isLiked;
  final String docRef;
  final String currentUser;
  const PostView(
      {super.key,
      required this.post,
      required this.user,
      required this.isLiked,
      required this.docRef,
      required this.currentUser});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text(widget.user.userName.toString()),
          ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue,
                      backgroundImage:
                          NetworkImage(widget.user.profileImageUrl!),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          textAlign: TextAlign.left,
                          '${widget.user.lastName!} ${widget.user.firstName!}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                            textAlign: TextAlign.left,
                            '@${widget.user.userName}')
                      ],
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: ReadMoreText(
                  widget.post.content,
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(fontSize: 16),
                  callback: (val) {
                    print(val);
                  },
                  trimLines: 6,
                  colorClickableText: Colors.pink,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'Read more',
                  trimExpandedText: '   Show less',
                  moreStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.blue),
                  lessStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.blue),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Date: ${widget.post.datePublished.toString()}')),
              SizedBox(
                height: 3,
              ),
              divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {},
                      child: Text('${widget.post.comments.length} Comments')),
                  TextButton(
                      onPressed: () {
                        sideSheet(
                            content: Container(),
                            header: "People that liked",
                            complete: () => null);
                      },
                      child: Text('${widget.post.likes!.length} Likes')),
                ],
              ),
              divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () {
                        push(context, AddComment());
                      },
                      icon: Icon(
                        Icons.comment,
                        color: Colors.lightGreenAccent,
                      )),
                  IconButton(
                      onPressed: () {
                        ServiceCall.likePost(
                            userId: widget.currentUser,
                            postId: widget.docRef,
                            currenUserLike: widget.isLiked);
                        setState(() {});
                      },
                      icon: widget.isLiked == true
                          ? Icon(
                              Icons.favorite,
                              color: Colors.lightGreenAccent,
                            )
                          : Icon(Icons.favorite_border_outlined)),
                  IconButton(
                      onPressed: () async {
                        await showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container();
                            });
                      },
                      icon: Icon(
                        Icons.share,
                        color: Colors.lightGreenAccent,
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Divider divider() {
    return Divider(
      height: 1,
      color: Colors.green.withOpacity(0.5),
      endIndent: 0,
      indent: 0,
    );
  }

  sideSheet(
      {required Widget content,
      required String header,
      required VoidCallback complete}) async {
    await showModalSideSheet(
      context,
      header: header,
      body: content, // Put your content widget here
      addBackIconButton: true,
      addActions: true,
      addDivider: true,
      confirmActionTitle: 'Save',
      cancelActionTitle: 'Cancel',
      confirmActionOnPressed: complete,

      // If null, Navigator.pop(context) will used
      cancelActionOnPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
