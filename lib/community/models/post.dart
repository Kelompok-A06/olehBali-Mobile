class Post {
  final int id;
  final String title;
  final String content;
  final String author;
  final String createdAt;
  final int commentsCount;
  final bool isAuthor;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
    required this.commentsCount,
    this.isAuthor = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json["id"] ?? 0,
      title: json["title"] ?? "No Title",
      content: json["content"] ?? "No Content",
      author: json["author"] ?? "Unknown",
      createdAt: json["created_at"] ?? "",
      commentsCount: json["comments_count"] ?? 0,
      isAuthor: json["is_author"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "content": content,
    "author": author,
    "created_at": createdAt,
    "comments_count": commentsCount,
  };
}