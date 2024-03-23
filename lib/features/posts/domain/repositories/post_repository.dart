// post_repository.dart
import 'package:dartz/dartz.dart';
import 'package:quotes/core/error/failures.dart';
import 'package:quotes/features/posts/domain/entities/post.dart';

abstract class PostRepository {
  Future<Either<Failure, List<Post>>> getPosts();
}