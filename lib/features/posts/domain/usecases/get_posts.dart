// get_posts.dart
import 'package:dartz/dartz.dart';
import 'package:educonnect/core/error/failures.dart';
import 'package:educonnect/core/usecases/usecase.dart';
import 'package:educonnect/features/posts/data/models/post_model.dart';
import 'package:educonnect/features/posts/domain/repositories/post_repository.dart';

class GetPosts implements UseCase<List<PostModel>, Params> {
  final PostRepository postRepository;

  GetPosts({required this.postRepository});

  @override
  Future<Either<Failure, List<PostModel>>> call(Params params) {
    return postRepository.getPosts(params.page, params.type);
  }
  
}
