import 'package:dartz/dartz.dart';
import 'package:educonnect/core/error/failures.dart';
import 'package:educonnect/core/usecases/usecase.dart';
import 'package:educonnect/features/posts/domain/entities/like.dart';
import 'package:educonnect/features/posts/domain/repositories/post_repository.dart';

class LikePost implements UseCase<LikePostResponse, int> {
  final PostRepository postRepository;

  LikePost({required this.postRepository});

  @override
  Future<Either<Failure, LikePostResponse>> call(int id) {
    return postRepository.likePost(id);
  }
}
