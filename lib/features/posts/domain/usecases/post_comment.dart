import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quotes/core/error/failures.dart';
import 'package:quotes/core/usecases/usecase.dart';
import 'package:quotes/features/posts/domain/repositories/post_repository.dart';

class PostComment extends UseCase<void, Params> {
  final PostRepository repository;

  PostComment(this.repository);

  @override
  Future<Either<Failure, void>> call(Params params) {
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