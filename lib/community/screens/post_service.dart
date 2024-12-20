import 'dart:convert';
import 'package:olehbali_mobile/community/models/post.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';

class PostService {
  final String activeUrl;

  PostService({required this.activeUrl});

  Future<List<Post>> fetchPosts(CookieRequest request) async {
    try {
      final response = await request.get(activeUrl);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return List<Post>.from(data.map((x) => Post.fromJson(x)));
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Post> createPost({
    required String title,
    required String content,
    required int authorId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$activeUrl/create-post-flutter/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'title': title,
          'content': content,
          'author': authorId,
        }),
      );

      if (response.statusCode == 200) {
        return Post.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}