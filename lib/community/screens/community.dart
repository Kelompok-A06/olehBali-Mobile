import 'package:flutter/material.dart';
import 'package:olehbali_mobile/community/models/post.dart';
import 'package:olehbali_mobile/community/screens/see_details.dart';
import 'package:olehbali_mobile/community/screens/post_service.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:olehbali_mobile/widgets/left_drawer.dart';
import 'package:google_fonts/google_fonts.dart';

class Community extends StatefulWidget {
  const Community({super.key});

  @override
  State<StatefulWidget> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  List<Post> posts = [];
  bool _isLoading = false;
  //final String baseUrl = 'http://127.0.0.1:8000/community/';
  final String baseUrl = 'https://muhammad-hibrizi-olehbali.pbp.cs.ui.ac.id/community/';
  late final CookieRequest cookieRequest;

  @override
  void initState() {
    super.initState();
    cookieRequest = Provider.of<CookieRequest>(context, listen: false);
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final postService = PostService(activeUrl: baseUrl, cookieRequest: cookieRequest);

      final fetchedPosts = await postService.fetchPosts();
      
      setState(() {
        posts = fetchedPosts;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching posts: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo_olehBali.png',
              fit: BoxFit.contain,
              height: 42,
            ),
            const SizedBox(width: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Oleh",
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        color: Color.fromARGB(255, 3, 164, 193),
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    )
                  ),
                  TextSpan(
                    text: "Bali",
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        color: Color.fromARGB(255, 254, 150, 66),
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 254, 150, 66)),
      ),
      drawer: const LeftDrawer(),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: fetchPosts,
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.network(
                      'https://media.suara.com/pictures/653x366/2023/03/05/47265-iustrasi-prosesi-hari-raya-nyepi.webp',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 200,
                          color: Colors.grey[200],
                          child: Center(
                            child: Text(
                              'Image Unavailable',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Community',
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Jelajahi rekomendasi oleh-oleh khas Bali dari wisatawan dan penduduk lokal. '
                        'Temukan inspirasi terbaik untuk kenangan dari Pulau Dewata.',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : posts.isEmpty 
                        ? const Center(child: Text('No posts available'))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              final post = posts[index];
                              return PostCard(post: post, onDelete: () => _deletePost(post));
                            },
                          ),
                const SizedBox(height: 80), // Add some space at the bottom
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                _showCreatePostModal(context);
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreatePostModal(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,  // Akan menampilkan 70% dari layar
          minChildSize: 0.5,      // Minimum 50% dari layar
          maxChildSize: 0.95,     // Maximum 95% dari layar
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
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
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const Text(
                    'Create a New Post',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: contentController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Content',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (titleController.text.isEmpty || contentController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill in all fields')),
                        );
                        return;
                      }

                      try {
                        final postService = PostService(
                          activeUrl: baseUrl,
                          cookieRequest: cookieRequest,
                        );
                        final newPost = await postService.createPost(
                          title: titleController.text,
                          content: contentController.text,
                        );

                        setState(() {
                          posts.insert(0, newPost);
                        });

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Post created successfully!')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error creating post: $e')),
                        );
                      }
                    },
                    child: const Text('Create Post'),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  Future<void> _deletePost(Post post) async {
    if (!post.isAuthor) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You are not authorized to delete this post')),
      );
      return;
    }

    try {
      final postService = PostService(activeUrl: baseUrl, cookieRequest: cookieRequest);
      final success = await postService.deletePost(post.id);

      if (success) {
        setState(() {
          posts.removeWhere((p) => p.id == post.id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post deleted successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting post: $e')),
      );
    }
  }
}

class PostCard extends StatelessWidget {
  final Post post;
  final Function() onDelete;

  const PostCard({super.key, 
    required this.post,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 1,
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
          child: Row(
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
              const SizedBox(width: 12),
              // Content Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.author,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                post.createdAt,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (post.isAuthor)
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Post'),
                                  content: const Text('Are you sure you want to delete this post?'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    TextButton(
                                      child: const Text('Delete'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        onDelete();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      post.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      post.content,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}