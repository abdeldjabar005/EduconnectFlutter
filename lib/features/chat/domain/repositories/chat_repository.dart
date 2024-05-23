import 'package:dartz/dartz.dart';
import 'package:educonnect/core/error/failures.dart';
import 'package:educonnect/features/chat/data/models/contact_model.dart';
import 'package:educonnect/features/chat/data/models/message_model.dart';
import 'package:educonnect/features/chat/domain/entities/contact.dart';
import 'package:educonnect/features/chat/domain/entities/message.dart';

abstract class ChatRepository {
  Future<Either<Failure,List<ContactModel>>> getContacts();
    Future<Either<Failure, void>> sendMessage(int id, String message);
    Future<Either<Failure, List<MessageModel>>> getMessages(int id);

}