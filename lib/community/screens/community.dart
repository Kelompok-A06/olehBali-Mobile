import 'package:flutter/material.dart';
import 'package:olehbali_mobile/community/models/post.dart';
import 'package:olehbali_mobile/community/screens/see_details.dart';
import 'package:olehbali_mobile/community/screens/post_service.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class Community extends StatefulWidget {
  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  List<Post> posts = [];
  bool _isLoading = false;
  final String baseUrl = 'https://muhammad-hibrizi-olehbali.pbp.cs.ui.ac.id/product/api-flutter/';

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final request = context.read<CookieRequest>();
      final postService = PostService(activeUrl: baseUrl);
      final fetchedPosts = await postService.fetchPosts(request);

      setState(() {
        posts = fetchedPosts;
      });
    } catch (e) {
      print('Error fetching posts: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return PostCard(post: posts[index]);
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _showCreatePostModal(context);
              },
              child: Text('Post to Community'),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreatePostModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        String title = '';
        String content = '';

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Create a New Post',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    title = value;
                  },
                ),
                SizedBox(height: 16),
                TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    content = value;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final postService = PostService(activeUrl: baseUrl);
                    try {
                      final newPost = await postService.createPost(
                        title: title,
                        content: content,
                        authorId: 1, // Ganti dengan ID author yang sesuai
                      );
                      setState(() {
                        posts.insert(0, newPost);
                      });
                      Navigator.pop(context);
                    } catch (e) {
                      print('Error creating post: $e');
                    }
                  },
                  child: Text('Post'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;

  PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SeeDetails(post: post),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.fields.title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'By User${post.fields.author} on ${post.fields.createdAt}',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(post.fields.content),
            ],
          ),
        ),
      ),
    );
  }
}