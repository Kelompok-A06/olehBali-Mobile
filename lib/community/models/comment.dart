// comment.dart
class Comment {
    final int id;
    final String content;
    final String author;
    final String createdAt;
    final bool isAuthor;

    Comment({
        required this.id,
        required this.content,
        required this.author,
        required this.createdAt,
        required this.isAuthor,
    });

    factory Comment.fromJson(Map<String, dynamic> json) {
        return Comment(
            id: json['id'] ?? 0,
            content: json['content'] ?? 'No Content',
            author: json['author']?.toString() ?? 'Unknown',
            createdAt: json['created_at'] ?? '',
            isAuthor: json['is_author'] ?? false,
        );
    }

    Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'author': author,
        'created_at': createdAt,
        'is_author': isAuthor,
    };
}