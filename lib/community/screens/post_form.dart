import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:olehbali_mobile/community/models/post.dart';
import 'package:olehbali_mobile/community/screens/post_service.dart';

class PostForm extends StatefulWidget {
  final Function(Post) onPostCreated;

  PostForm({required this.onPostCreated});

  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isLoading = false;
  late CookieRequest cookieRequest;

  @override
  void initState() {
    super.initState();
    cookieRequest = Provider.of<CookieRequest>(context, listen: false);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Create a New Post',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Title is required' : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _contentController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Content is required' : null,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : () async {
                if (!_formKey.currentState!.validate()) return;

                setState(() => _isLoading = true);

                try {
                  final postService = PostService(
                    //activeUrl: 'http://127.0.0.1:8000/community/',
                    activeUrl: 'https://muhammad-hibrizi-olehbali.pbp.cs.ui.ac.id/community/',
                    cookieRequest: cookieRequest,
                  );

                  final newPost = await postService.createPost(
                    title: _titleController.text,
                    content: _contentController.text,
                  );

                  widget.onPostCreated(newPost);
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Post created successfully!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error creating post: $e')),
                  );
                } finally {
                  setState(() => _isLoading = false);
                }
              },
              child: _isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}