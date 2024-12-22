// post_service.dart
import 'dart:convert';
import 'package:olehbali_mobile/community/models/post.dart';
import 'package:olehbali_mobile/community/models/comment.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';

class PostService {
  final String activeUrl;
  final CookieRequest cookieRequest;

  PostService({
    required this.activeUrl,
    required this.cookieRequest,
  });

  // Fetch semua post
  Future<List<Post>> fetchPosts() async {
    try {
      final response = await cookieRequest.get('${activeUrl}json/');
      
      if (response != null) {
        if (response['status'] == true && response['data'] != null) {
          return List<Post>.from(
            response['data'].map((x) => Post.fromJson(x))
          );
        } else {
          throw Exception('Data format error: ${response['message']}');
        }
      } else {
        throw Exception('Failed to load posts: No response');
      }
    } catch (e) {
      print('Detailed error in fetchPosts: $e');
      throw Exception('Network error: $e');
    }
  }

  // Create post baru
  Future<Post> createPost({
    required String title,
    required String content,
  }) async {
    try {
      final response = await cookieRequest.post(
        '${activeUrl}create-post-flutter/',
        {
          'title': title,
          'content': content,
        },
      );

      if (response['status'] == true && response['data'] != null) {
        return Post.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Failed to create post');
      }
    } catch (e) {
      print('Error in createPost: $e');
      throw Exception('Failed to create post: $e');
    }
  }

  // Delete post
  Future<bool> deletePost(int postId) async {
    try {
      final response = await cookieRequest.post(
        '${activeUrl}post/$postId/delete-flutter/',
        {},
      );

      if (response['status'] == true) {
        return true;
      } else {
        throw Exception(response['message'] ?? 'Failed to delete post');
      }
    } catch (e) {
      print('Error in deletePost: $e');
      throw Exception('Failed to delete post: $e');
    }
  }

  // Fetch comments untuk post tertentu
  Future<List<Comment>> fetchComments(int postId) async {
    try {
      final response = await cookieRequest.get(
        '${activeUrl}post/$postId/comments/json/',
      );

      if (response['status'] == true && response['data'] != null) {
        return List<Comment>.from(
          response['data'].map((x) => Comment.fromJson(x))
        );
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch comments');
      }
    } catch (e) {
      print('Error in fetchComments: $e');
      throw Exception('Failed to fetch comments: $e');
    }
  }

  // Create comment baru
  Future<Comment> createComment({
    required int postId,
    required String content,
  }) async {
    try {
      final response = await cookieRequest.post(
        '${activeUrl}post/$postId/comment-flutter/',
        {
          'content': content,
        },
      );

      if (response['status'] == true && response['data'] != null) {
        return Comment.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Failed to create comment');
      }
    } catch (e) {
      print('Error in createComment: $e');
      throw Exception('Failed to create comment: $e');
    }
  }

  // Delete comment
  Future<bool> deleteComment(int commentId) async {
    try {
      final response = await cookieRequest.post(
        '${activeUrl}comment/$commentId/delete-flutter/',
        {},
      );

      if (response['status'] == true) {
        return true;
      } else {
        throw Exception(response['message'] ?? 'Failed to delete comment');
      }
    } catch (e) {
      print('Error in deleteComment: $e');
      throw Exception('Failed to delete comment: $e');
    }
  }
}