import 'package:farmlink_ug/core/domain/repositories/icommunity_repository.dart';

class FetchPostsUseCase {
  final ICommunityRepository repository;
  
  FetchPostsUseCase(this.repository);
  
  Future<List<Post>> call(String topicId) => repository.fetchPosts(topicId: topicId);
}
