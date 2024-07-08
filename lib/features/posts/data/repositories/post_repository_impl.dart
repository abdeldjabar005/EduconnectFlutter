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
import 'package:educonnect/features/posts/data/models/search_model.dart';
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
  Future<Either<Failure, List<PostModel>>> getPosts(
      int page, String type) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePosts = await remoteDataSource.getPosts(page, type);
        return Right(remotePosts);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, PostModel>> newPost(
    PostM post,
    List<File>? images,
    String? schoolClass,
    String? pollQuestion,
    List<String>? pollOptions,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePost = await remoteDataSource.newPost(
            post, images, schoolClass, pollQuestion, pollOptions);
        return Right(remotePost);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removePost(int id) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(remoteDataSource.removePost(id));
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
  Future<Either<Failure, CommentModel>> postComment(
      int postId, String comment) async {
    if (await networkInfo.isConnected) {
      try {
        final commentModel =
            await remoteDataSource.postComment(postId, comment);
        return Right(commentModel);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, CommentModel>> postReply(int id, String reply) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteComment = await remoteDataSource.postReply(id, reply);
        return Right(remoteComment);
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
  Future<Either<Failure, void>> removeComment(int id, int postId) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(remoteDataSource.removeComment(id, postId));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeReply(int id) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(remoteDataSource.removeReply(id));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, LikePostResponse>> checkIfPostIsLiked(
      int postId) async {
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

  @override
  Future<Either<Failure, PostModel>> voteOnPoll(
      int postId, String option) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePost = await remoteDataSource.voteOnPoll(postId, option);
        return Right(remotePost);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<SearchModel>>> search(String query) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteSearch = await remoteDataSource.search(query);
        return Right(remoteSearch);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  Future<Either<Failure, void>> joinSchoolRequest(int id) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(remoteDataSource.joinSchoolRequest(id));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
  Future<Either<Failure, void>> savePost(int id) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(remoteDataSource.savePost(id));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
