// get_comments.dart
import 'package:dartz/dartz.dart';
import 'package:educonnect/core/error/failures.dart';
import 'package:educonnect/core/usecases/usecase.dart';
import 'package:educonnect/features/posts/data/models/comment_model.dart';
import 'package:educonnect/features/posts/domain/repositories/post_repository.dart';

class GetComment implements UseCase<CommentModel, int> {
  final PostRepository commentRepository;

  GetComment({required this.commentRepository});

  @override
  Future<Either<Failure, CommentModel>> call(int id) {
    return commentRepository.getComment(id);
  }
}
