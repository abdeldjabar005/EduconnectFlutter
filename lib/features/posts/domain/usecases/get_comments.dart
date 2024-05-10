// get_comments.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:educonnect/core/error/failures.dart';
import 'package:educonnect/core/usecases/usecase.dart';
import 'package:educonnect/features/posts/domain/entities/comment.dart';
import 'package:educonnect/features/posts/domain/repositories/post_repository.dart';

class GetComments implements UseCase<List<Comment>, Params1> {
  final PostRepository commentRepository;

  GetComments({required this.commentRepository});

  @override
  Future<Either<Failure, List<Comment>>> call(Params1 params) {
    return commentRepository.getComments(params.postId);
  }
}

class Params1 extends Equatable {
  final int postId;

  const Params1({required this.postId});

  @override
  List<Object> get props => [postId];
}