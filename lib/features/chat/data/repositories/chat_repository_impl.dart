import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:educonnect/core/error/exceptions.dart';
import 'package:educonnect/core/error/failures.dart';
import 'package:educonnect/core/network/netwok_info.dart';
import 'package:educonnect/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:educonnect/features/chat/data/models/contact_model.dart';
import 'package:educonnect/features/chat/data/models/message_model.dart';
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
  Future<Either<Failure, List<MessageModel>>> getMessages(
      int chatRoomId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteMessages = await remoteDataSource.getMessages(chatRoomId);
        return Right(remoteMessages);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage(int id, String message) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.sendMessage(id, message);
        return Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<ContactModel>>> getContacts() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteContacts = await remoteDataSource.getContacts();
        return Right(remoteContacts);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
