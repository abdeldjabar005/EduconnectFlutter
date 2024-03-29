// get_comments.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quotes/core/error/failures.dart';
import 'package:quotes/core/usecases/usecase.dart';
import 'package:quotes/features/posts/domain/entities/comment.dart';
import 'package:quotes/features/posts/domain/repositories/post_repository.dart';

class GetComments implements UseCase<List<Comment>, Params> {
  final PostRepository commentRepository;

  GetComments({required this.commentRepository});

  @override
  Future<Either<Failure, List<Comment>>> call(Params params) {
    return commentRepository.getComments(params.postId);
  }
}

class Params extends Equatable {
  final int postId;

  Params({required this.postId});

  @override
  List<Object> get props => [postId];
}