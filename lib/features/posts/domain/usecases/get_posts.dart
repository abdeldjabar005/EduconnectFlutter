// get_posts.dart
import 'package:dartz/dartz.dart';
import 'package:quotes/core/error/failures.dart';
import 'package:quotes/core/usecases/usecase.dart';
import 'package:quotes/features/posts/domain/entities/post.dart';
import 'package:quotes/features/posts/domain/repositories/post_repository.dart';

class GetPosts implements UseCase<List<Post>, Params> {
  final PostRepository postRepository;

  GetPosts({required this.postRepository});

  @override
  Future<Either<Failure, List<Post>>> call(Params params) {
    return postRepository.getPosts(params.page);
  }
}
