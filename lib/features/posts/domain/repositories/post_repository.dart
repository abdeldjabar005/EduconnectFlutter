// post_repository.dart
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:educonnect/core/error/failures.dart';
import 'package:educonnect/features/posts/data/models/comment_model.dart';
import 'package:educonnect/features/posts/data/models/post_m.dart';
import 'package:educonnect/features/posts/data/models/post_model.dart';
import 'package:educonnect/features/posts/domain/entities/comment.dart';
import 'package:educonnect/features/posts/domain/entities/like.dart';

abstract class PostRepository {
  Future<Either<Failure, List<PostModel>>> getPosts(int page, String type);
  Future<Either<Failure, List<Comment>>> getComments(int postId);
  Future<Either<Failure, CommentModel>> getComment(int id);
  Future<Either<Failure, void>> postComment(int postId, String comment);
  Future<Either<Failure, void>> postReply(int id, String reply);
  Future<Either<Failure, PostModel>> getPost(int id);
  Future<Either<Failure, PostModel>> newPost(
    PostM post,
    List<File>? images,
    String? schoolClass,
    String? pollQuestion,
    List<String>? pollOptions,
  );
  Future<Either<Failure, LikePostResponse>> likePost(int id);
  Future<Either<Failure, LikePostResponse>> likeComment(int id);
  Future<Either<Failure, LikePostResponse>> likeReply(int id);
  Future<Either<Failure, LikePostResponse>> checkIfPostIsLiked(int postId);
  Future<Either<Failure, PostModel>> voteOnPoll(int postId, String option);
  Future<Either<Failure, void>> removePost(int id);
  Future<Either<Failure, void>> removeComment(int id, int postId);
  Future<Either<Failure, void>> removeReply(int id);
}
