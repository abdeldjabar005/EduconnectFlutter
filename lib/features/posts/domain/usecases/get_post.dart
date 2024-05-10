// get_posts.dart
import 'package:dartz/dartz.dart';
import 'package:educonnect/core/error/failures.dart';
import 'package:educonnect/core/usecases/usecase.dart';
import 'package:educonnect/features/posts/data/models/post_model.dart';
import 'package:educonnect/features/posts/domain/repositories/post_repository.dart';

class GetPost implements UseCase<PostModel, int> {
  final PostRepository postRepository;

  GetPost({required this.postRepository});

  @override
  Future<Either<Failure, PostModel>> call(int id) {
    return postRepository.getPost(id);
  }
  
}
