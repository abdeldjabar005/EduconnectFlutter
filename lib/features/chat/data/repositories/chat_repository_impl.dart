import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:educonnect/core/error/exceptions.dart';
import 'package:educonnect/core/error/failures.dart';
import 'package:educonnect/core/network/netwok_info.dart';
import 'package:educonnect/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:educonnect/features/chat/domain/entities/message.dart';
import 'package:educonnect/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> sendMessage(Message message) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.sendMessage(message);
        return Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Stream<Either<Failure, List<Message>>> getMessages(String chatRoomId) {
    if (networkInfo.isConnected) {
      try {
        final remoteMessages = remoteDataSource.getMessages(chatRoomId);
        return Right(remoteMessages);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}