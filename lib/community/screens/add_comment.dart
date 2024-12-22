import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:olehbali_mobile/community/models/comment.dart';
import 'package:olehbali_mobile/community/screens/post_service.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class AddComment {
  final String activeUrl;
  final CookieRequest cookieRequest;

  AddComment({
    required this.activeUrl,
    required this.cookieRequest,
  });

  Future<Comment> createComment(int postId, String content) async {
    try {
      final response = await cookieRequest.post(
        '${activeUrl}post/$postId/comments/create/',
        jsonEncode({
          'content': content,
        }),
      );

      if (response['status'] == true) {
        return Comment.fromJson(response['data']);
      } else {
        throw Exception('Failed to create comment: ${response['message']}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}