// post_repository.dart
import 'package:dartz/dartz.dart';
import 'package:quotes/core/error/failures.dart';
import 'package:quotes/features/posts/data/models/post_model.dart';
import 'package:quotes/features/posts/domain/entities/comment.dart';
import 'package:quotes/features/posts/domain/entities/post.dart';

abstract class PostRepository {
  Future<Either<Failure, List<PostModel>>> getPosts(int page);
  Future<Either<Failure, List<Comment>>> getComments(int postId);
  Future<Either<Failure, void>> postComment(int postId, String comment);
  Future<Either<Failure, PostModel>> getPost(int id);
}
