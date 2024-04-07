import 'package:dartz/dartz.dart';
import 'package:quotes/core/error/failures.dart';
import 'package:quotes/core/usecases/usecase.dart';
import 'package:quotes/features/posts/domain/entities/like.dart';
import 'package:quotes/features/posts/domain/repositories/post_repository.dart';

class LikeReply implements UseCase<LikePostResponse, int> {
  final PostRepository postRepository;

  LikeReply({required this.postRepository});

  @override
  Future<Either<Failure, LikePostResponse>> call(int id) {
    return postRepository.likeReply(id);
  }
}