// post_repository_impl.dart
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:educonnect/core/error/exceptions.dart';
import 'package:educonnect/core/error/failures.dart';
import 'package:educonnect/core/network/netwok_info.dart';
import 'package:educonnect/features/posts/data/datasources/post_local_data_source.dart';
import 'package:educonnect/features/posts/data/datasources/post_remote_data_source.dart';
import 'package:educonnect/features/posts/data/models/comment_model.dart';
import 'package:educonnect/features/posts/data/models/post_m.dart';
import 'package:educonnect/features/posts/data/models/post_model.dart';
import 'package:educonnect/features/posts/domain/entities/comment.dart';
import 'package:educonnect/features/posts/domain/entities/like.dart';
import 'package:educonnect/features/posts/domain/entities/post.dart';
import 'package:educonnect/features/posts/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final PostLocalDataSource localDataSource;

  PostRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<PostModel>>> getPosts(int page) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePosts = await remoteDataSource.getPosts(page);
        return Right(remotePosts);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, PostModel>> newPost(PostM post, List<File>? images, String? schoolClass) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePost = await remoteDataSource.newPost(post, images, schoolClass);
        return Right(remotePost);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Comment>>> getComments(int postId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteComments = await remoteDataSource.getComments(postId);
        return Right(remoteComments);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
  @override
  Future<Either<Failure, CommentModel>> getComment(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteComment = await remoteDataSource.getComment(id);
        return Right(remoteComment);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> postComment(int postId, String comment) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(remoteDataSource.postComment(postId, comment));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
  @override
  Future<Either<Failure, void>> postReply(int id, String reply) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(remoteDataSource.postReply(id, reply));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
  @override
  Future<Either<Failure, PostModel>> getPost(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePost = await remoteDataSource.getPost(id);
        return Right(remotePost);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
  @override
  Future<Either<Failure, LikePostResponse>> likePost(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteLike = await remoteDataSource.likePost(id);
        return Right(remoteLike);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
  @override
  Future<Either<Failure, LikePostResponse>> likeComment(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteLike = await remoteDataSource.likeComment(id);
        return Right(remoteLike);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
  @override 
  Future<Either<Failure, LikePostResponse>> likeReply(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteLike = await remoteDataSource.likeReply(id);
        return Right(remoteLike);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
  @override
  Future<Either<Failure, LikePostResponse>> checkIfPostIsLiked(int postId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteLike = await remoteDataSource.checkIfPostIsLiked(postId);
        return Right(remoteLike);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
