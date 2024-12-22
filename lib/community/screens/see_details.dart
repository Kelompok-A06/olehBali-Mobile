import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:olehbali_mobile/community/models/comment.dart';
import 'package:olehbali_mobile/community/models/post.dart';
import 'package:provider/provider.dart';
import 'package:olehbali_mobile/community/screens/post_service.dart';

class SeeDetails extends StatefulWidget {
  final Post post;

  SeeDetails({required this.post});

  @override
  _SeeDetailsState createState() => _SeeDetailsState();
}

class _SeeDetailsState extends State<SeeDetails> {
  List<Comment> comments = [];
  bool _isLoading = false;
  bool _isSubmitting = false;
  final TextEditingController _commentController = TextEditingController();
  late final PostService _postService;
  late final CookieRequest cookieRequest;

  @override
  void initState() {
    super.initState();
    cookieRequest = Provider.of<CookieRequest>(context, listen: false);
    _postService = PostService(
      //activeUrl: 'http://127.0.0.1:8000/community/',
      activeUrl: 'https://muhammad-hibrizi-olehbali.pbp.cs.ui.ac.id/community/',
      cookieRequest: cookieRequest,
    );
    fetchComments();
  }

  Future<void> fetchComments() async {
    if (_isLoading) return;
    
    setState(() => _isLoading = true);
    try {
      final fetchedComments = await _postService.fetchComments(widget.post.id);
      setState(() => comments = fetchedComments);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load comments: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> createComment(String content) async {
    if (_isSubmitting || content.isEmpty) return;

    setState(() => _isSubmitting = true);
    try {
      final response = await _postService.createComment(
        postId: widget.post.id,
        content: content,
      );
      
      if (response != null) {
        setState(() {
          comments.insert(0, Comment(
            id: response.id,
            content: response.content,
            author: response.author,
            createdAt: response.createdAt,
            isAuthor: true,
          ));
          _commentController.clear();
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Comment added successfully!')),
        );
      } else {
        throw Exception('Failed to create comment: Invalid response');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create comment: $e')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  Future<void> deleteComment(int commentId) async {
    setState(() => _isLoading = true);
    try {
      final success = await _postService.deleteComment(commentId);
      if (success) {
        setState(() {
          comments.removeWhere((comment) => comment.id == commentId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Comment deleted successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting comment: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget buildCommentInput() {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () => _showCommentModal(context),
        child: Text('Add Comment'),
      ),
    );
  }

  void _showCommentModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
              ),
              child: ListView(
                controller: controller,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(
                    'Add a Comment',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _commentController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'Write your comment',
                      border: OutlineInputBorder(),
                      enabled: !_isSubmitting,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isSubmitting
                        ? null
                        : () {
                            if (_commentController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Comment cannot be empty')),
                              );
                              return;
                            }
                            createComment(_commentController.text.trim());
                            Navigator.pop(context);
                          },
                    child: _isSubmitting
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text('Post Comment'),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  Widget buildCommentCard(Comment comment) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${comment.author}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      comment.createdAt,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                if (comment.isAuthor)
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red, size: 20),
                    onPressed: () => showDeleteDialog(comment),
                  ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              comment.content,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void showDeleteDialog(Comment comment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Comment'),
        content: Text('Are you sure you want to delete this comment?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () {
              Navigator.pop(context);
              deleteComment(comment.id);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Detail'),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: fetchComments,
              child: ListView(
                children: [
                  // Post Details
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile Picture Circle
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.lightBlue[200],
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.post.title,
                                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${widget.post.author} • ${widget.post.createdAt}',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      if (widget.post.isAuthor)
                                        ElevatedButton.icon(
                                          icon: Icon(Icons.delete, color: Colors.white),
                                          label: Text('Delete Post', style: TextStyle(color: Colors.white)),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          onPressed: () => showDeletePostDialog(),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          widget.post.content,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  
                  // Comments Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Comments',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  
                  if (_isLoading)
                    Center(child: CircularProgressIndicator())
                  else if (comments.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'No comments yet. Be the first to comment!',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  else
                    ...comments.map(buildCommentCard).toList(),
                  
                  // Bottom padding for last comment
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
          buildCommentInput(),
        ],
      ),
    );
  }

  void showDeletePostDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Post'),
        content: Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () async {
              Navigator.pop(context);
              final success = await _postService.deletePost(widget.post.id);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Post deleted successfully')),
                );
                Navigator.pop(context); // Return to posts list
              }
            },
          ),
        ],
      ),
    );
  }
}