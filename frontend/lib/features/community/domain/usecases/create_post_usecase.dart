import 'package:farmcom/core/domain/repositories/icommunity_repository.dart';

class CreatePostUseCase {
  final ICommunityRepository repository;
  
  CreatePostUseCase(this.repository);
  
  Future<Post> call({
    required String topicId,
    required String title,
    required String content,
  }) => repository.createPost(
    topicId: topicId,
    title: title,
    content: content,
  );
}
