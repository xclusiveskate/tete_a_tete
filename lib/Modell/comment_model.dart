// import 'dart:convert';

// import 'package:flutter/foundation.dart';
//collection
class Comment {
  final String commentId;
  final String userId;
  final List likes;
  Comment({
    required this.commentId,
    required this.userId,
    required this.likes,
  });

  Map<String, Object?> toJson() {
    return {
      'commentId': commentId,
      'userId': userId,
      'likes': likes,
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['commentId'] as String,
      userId: json['userId'] as String,
      likes: List.from(json['likes']),
    );
  }
}
