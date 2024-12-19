import 'dart:convert';
import 'package:olehbali_mobile/community/models/comment.dart';
import 'package:http/http.dart' as http;

class AddComment {
  final String activeUrl;

  AddComment({required this.activeUrl});

  Future<Comment> createComment(int postId, String content, int authorId) async {
    final response = await http.post(
      Uri.parse('$activeUrl/post/$postId/comments/create/'), // Sesuaikan dengan URL Django
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'post': postId,
        'content': content,
        'author': authorId, // Ganti dengan ID author yang sesuai
      }),
    );

    if (response.statusCode == 201) {
      return Comment.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create comment');
    }
  }
}