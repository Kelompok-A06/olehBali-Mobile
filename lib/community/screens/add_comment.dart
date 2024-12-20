import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:olehbali_mobile/community/models/comment.dart';

class AddComment {
  final String activeUrl;

  AddComment({required this.activeUrl});

  /// Membuat komentar baru untuk postingan tertentu.
  /// [postId] adalah ID postingan yang akan dikomentari.
  /// [content] adalah isi komentar.
  /// [authorId] adalah ID pengguna yang membuat komentar.
  Future<Comment> createComment(int postId, String content, int authorId) async {
    try {
      final response = await http.post(
        Uri.parse('$activeUrl/create-comment-flutter/'), // Pastikan URL sesuai dengan backend Django
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'post': postId,
          'content': content,
          'author': authorId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse respons JSON menjadi objek Comment
        return Comment.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create comment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}