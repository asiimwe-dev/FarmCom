/// Community/Forum repository contract
/// Implemented by features/community/data/repositories/community_repository.dart
abstract class ICommunityRepository {
  /// Fetch all posts in a topic
  Future<List<Post>> fetchPosts({
    required String topicId,
    int page = 1,
    int pageSize = 20,
  });

  /// Watch posts stream for real-time updates
  Stream<List<Post>> watchPosts(String topicId);

  /// Create a new post (queued for sync if offline)
  Future<Post> createPost({
    required String topicId,
    required String title,
    required String content,
    List<String>? imageUrls,
  });

  /// Update existing post
  Future<Post> updatePost({
    required String postId,
    String? title,
    String? content,
    List<String>? imageUrls,
  });

  /// Delete post
  Future<void> deletePost(String postId);

  /// Like/unlike post
  Future<void> toggleLike(String postId);

  /// Get comments on a post
  Future<List<Comment>> fetchComments(String postId);

  /// Add comment (queued for sync if offline)
  Future<Comment> addComment({
    required String postId,
    required String content,
  });

  /// Fetch all topics/communities
  Future<List<Topic>> fetchTopics();

  /// Watch topics stream
  Stream<List<Topic>> watchTopics();

  /// Get pending posts (not yet synced)
  Future<List<Post>> getPendingPosts();

  /// Sync pending posts to server
  Future<void> syncPendingPosts();
}

/// Forum post entity
class Post {
  final String id;
  final String topicId;
  final String userId;
  final String? userName;
  final String title;
  final String content;
  final List<String> imageUrls;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int likes;
  final int commentCount;
  final bool isPending; // Not yet synced
  final bool isLiked;

  Post({
    required this.id,
    required this.topicId,
    required this.userId,
    this.userName,
    required this.title,
    required this.content,
    this.imageUrls = const [],
    required this.createdAt,
    this.updatedAt,
    this.likes = 0,
    this.commentCount = 0,
    this.isPending = false,
    this.isLiked = false,
  });
}

/// Forum comment entity
class Comment {
  final String id;
  final String postId;
  final String userId;
  final String? userName;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int likes;
  final bool isPending; // Not yet synced

  Comment({
    required this.id,
    required this.postId,
    required this.userId,
    this.userName,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.likes = 0,
    this.isPending = false,
  });
}

/// Forum topic/community entity
class Topic {
  final String id;
  final String name; // e.g., "Coffee Growers", "Maize Farmers"
  final String description;
  final String? imageUrl;
  final int memberCount;
  final int postCount;
  final bool isMember;

  Topic({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    this.memberCount = 0,
    this.postCount = 0,
    this.isMember = false,
  });
}
