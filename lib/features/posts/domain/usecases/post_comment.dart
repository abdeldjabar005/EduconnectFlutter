import 'package:dartz/dartz.dart';
import 'package:educonnect/features/posts/data/models/comment_model.dart';
import 'package:equatable/equatable.dart';
import 'package:educonnect/core/error/failures.dart';
import 'package:educonnect/core/usecases/usecase.dart';
import 'package:educonnect/features/posts/domain/repositories/post_repository.dart';

class PostComment extends UseCase<CommentModel, Params> {
  final PostRepository repository;

  PostComment(this.repository);

  @override
  Future<Either<Failure, CommentModel>> call(Params params) {
    return repository.postComment(params.postId, params.comment);
  }
}

class Params extends Equatable {
  final int postId;
  final String comment;

  const Params({required this.postId, required this.comment});

  @override
  List<Object> get props => [postId, comment];
}