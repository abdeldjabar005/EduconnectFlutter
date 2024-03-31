// post_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:quotes/core/error/exceptions.dart';
import 'package:quotes/core/error/failures.dart';
import 'package:quotes/core/network/netwok_info.dart';
import 'package:quotes/features/posts/data/datasources/post_local_data_source.dart';
import 'package:quotes/features/posts/data/datasources/post_remote_data_source.dart';
import 'package:quotes/features/posts/data/models/post_model.dart';
import 'package:quotes/features/posts/domain/entities/comment.dart';
import 'package:quotes/features/posts/domain/entities/post.dart';
import 'package:quotes/features/posts/domain/repositories/post_repository.dart';

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
}
