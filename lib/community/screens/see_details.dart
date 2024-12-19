import 'package:flutter/material.dart';
import 'package:olehbali_mobile/community/models/comment.dart';
import 'package:olehbali_mobile/community/models/post.dart';
import 'package:olehbali_mobile/community/screens/add_comment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SeeDetails extends StatefulWidget {
  final Post post;

  SeeDetails({required this.post});

  @override
  _SeeDetailsState createState() => _SeeDetailsState();
}

class _SeeDetailsState extends State<SeeDetails> {
  List<Comment> comments = [];

  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  Future<void> fetchComments() async {
    final response = await http.get(
      Uri.parse('https://muhammad-hibrizi-olehbali.pbp.cs.ui.ac.id/product/api-flutter/post/${widget.post.pk}/comments/json/'), // Sesuaikan dengan URL Django
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        comments = List<Comment>.from(data.map((x) => Comment.fromJson(x)));
      });
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<void> createComment(String content) async {
    final addComment = AddComment(activeUrl: 'https://muhammad-hibrizi-olehbali.pbp.cs.ui.ac.id/product/api-flutter/');
    try {
      final newComment = await addComment.createComment(widget.post.pk, content, 1); // Ganti 1 dengan ID author yang sesuai
      setState(() {
        comments.insert(0, newComment);
      });
    } catch (e) {
      print('Error creating comment: $e');
    }
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
            child: ListView(
              children: [
                // Post Detail
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.fields.title,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'By User${widget.post.fields.author} on ${widget.post.fields.createdAt}',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 16),
                      Text(
                        widget.post.fields.content,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),

                // Comments Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Comments',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          return CommentCard(comment: comment);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Add Comment Form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Add a comment',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
                    createComment(value);
                  },
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    final textController = TextEditingController();
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Add Comment'),
                          content: TextField(
                            controller: textController,
                            decoration: InputDecoration(
                              hintText: 'Write your comment here...',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                createComment(textController.text);
                                Navigator.pop(context);
                              },
                              child: Text('Submit'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Add Comment'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CommentCard extends StatelessWidget {
  final Comment comment;

  CommentCard({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'By User${comment.fields.author} on ${comment.fields.createdAt}',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(comment.fields.content),
          ],
        ),
      ),
    );
  }
}