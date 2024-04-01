// get_posts.dart
import 'package:dartz/dartz.dart';
import 'package:quotes/core/error/failures.dart';
import 'package:quotes/core/usecases/usecase.dart';
import 'package:quotes/features/posts/data/models/post_model.dart';
import 'package:quotes/features/posts/domain/repositories/post_repository.dart';

class GetPosts implements UseCase<List<PostModel>, Params> {
  final PostRepository postRepository;

  GetPosts({required this.postRepository});

  @override
  Future<Either<Failure, List<PostModel>>> call(Params params) {
    return postRepository.getPosts(params.page);
  }
  
}
