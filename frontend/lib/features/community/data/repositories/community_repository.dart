import 'package:farmlink_ug/core/domain/repositories/icommunity_repository.dart';
import 'package:farmlink_ug/core/utils/logger.dart';

class CommunityRepository implements ICommunityRepository {
  @override
  Future<List<Post>> fetchPosts({required String topicId, int page = 1, int pageSize = 20}) async {
    Logger.warning('Community feature not yet implemented: fetchPosts');
    // TODO: Implement - connect to Supabase and Isar
    return [];
  }
  
  @override
  Stream<List<Post>> watchPosts(String topicId) async* {
    Logger.warning('Community feature not yet implemented: watchPosts');
    // TODO: Implement - watch Isar for local changes
    yield [];
  }
  
  @override
  Future<Post> createPost({required String topicId, required String title, required String content, List<String>? imageUrls}) async {
    Logger.warning('Community feature not yet implemented: createPost');
    // TODO: Implement - queue to sync and save locally
    throw UnimplementedError('Community posting not yet implemented');
  }
  
  @override
  Future<Post> updatePost({required String postId, String? title, String? content, List<String>? imageUrls}) async {
    Logger.warning('Community feature not yet implemented: updatePost');
    throw UnimplementedError('Community post updates not yet implemented');
  }
  
  @override
  Future<void> deletePost(String postId) async {
    Logger.warning('Community feature not yet implemented: deletePost');
    // TODO: Implement - mark for deletion and sync
  }
  
  @override
  Future<void> toggleLike(String postId) async {
    Logger.warning('Community feature not yet implemented: toggleLike');
    // TODO: Implement
  }
  
  @override
  Future<List<Comment>> fetchComments(String postId) async {
    Logger.warning('Community feature not yet implemented: fetchComments');
    return [];
  }
  
  @override
  Future<Comment> addComment({required String postId, required String content}) async {
    Logger.warning('Community feature not yet implemented: addComment');
    throw UnimplementedError('Adding comments not yet implemented');
  }
  
  @override
  Future<List<Topic>> fetchTopics() async {
    Logger.warning('Community feature not yet implemented: fetchTopics');
    return [];
  }
  
  @override
  Stream<List<Topic>> watchTopics() async* {
    Logger.warning('Community feature not yet implemented: watchTopics');
    yield [];
  }
  
  @override
  Future<List<Post>> getPendingPosts() async {
    Logger.warning('Community feature not yet implemented: getPendingPosts');
    return [];
  }
  
  @override
  Future<void> syncPendingPosts() async {
    Logger.warning('Community feature not yet implemented: syncPendingPosts');
    // TODO: Implement - call sync worker for community posts
  }
}
