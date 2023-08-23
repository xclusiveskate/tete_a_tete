import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tete_a_tete/Modell/comment_model.dart';
import 'package:tete_a_tete/Modell/post_model.dart';

class ServiceCall {
  static createPost(
      {required String content,
      required DateTime datePublished,
      required String userId,
      String? imageUrl,
      List? likes,
      List<Comment>? comments}) async {
    try {
      final FirebaseFirestore _db = FirebaseFirestore.instance;
      final postRef = _db.collection('posts');

      final postId = postRef.doc().id;
      PostModel post = PostModel(
          uid: postId,
          datePublished: datePublished,
          userId: userId,
          imageUrl: imageUrl ?? '',
          content: content,
          likes: [],
          comments: []);

      await postRef.add(post.toJson());
    } catch (e) {
      print(e);
    }
  }

  static likePost(
      {required String userId,
      required String postId,
      required bool currenUserLike}) {
    print(postId);
    final db = FirebaseFirestore.instance;
    var postToLike = db.collection('posts').doc(postId);
    if (currenUserLike) {
      postToLike.update({
        'likes': FieldValue.arrayRemove([userId])
      });
    } else {
      postToLike.update({
        'likes': FieldValue.arrayUnion([userId])
      });
    }
  }

  static addComment() {}
}
