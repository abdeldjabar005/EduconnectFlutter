import 'package:dartz/dartz.dart';
import 'package:quotes/core/error/failures.dart';
import 'package:quotes/core/usecases/usecase.dart';
import 'package:quotes/features/posts/domain/entities/like.dart';
import 'package:quotes/features/posts/domain/repositories/post_repository.dart';

class LikePost implements UseCase<LikePostResponse, int> {
  final PostRepository postRepository;

  LikePost({required this.postRepository});

  @override
  Future<Either<Failure, LikePostResponse>> call(int id) {
    return postRepository.likePost(id);
  }
}
