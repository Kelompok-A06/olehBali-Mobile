import 'dart:convert';
import 'package:olehbali_mobile/community/models/post.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';

class PostService {
  final String activeUrl;

  PostService({required this.activeUrl});

  Future<List<Post>> fetchPosts(CookieRequest request) async {
    final response = await request.get(activeUrl);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return List<Post>.from(data.map((x) => Post.fromJson(x)));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Post> createPost(String title, String content, int authorId) async {
    final response = await http.post(
      Uri.parse('$activeUrl/create-post-flutter/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'content': content,
        'author': authorId,
      }),
    );

    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create post');
    }
  }
}