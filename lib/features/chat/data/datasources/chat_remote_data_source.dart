import 'package:educonnect/core/api/api_consumer.dart';
import 'package:educonnect/core/api/end_points.dart';
import 'package:educonnect/core/error/exceptions.dart';
import 'package:educonnect/features/chat/data/models/contact_model.dart';
import 'package:educonnect/features/chat/data/models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<void> sendMessage(int id, String message);
  Future<List<MessageModel>> getMessages(int chatRoomId);
  Future<List<ContactModel>> getContacts();
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ApiConsumer apiConsumer;

  ChatRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<void> sendMessage(int id, String message) async {
    final response = await apiConsumer.post(
      EndPoints.sendMessage,
      body: {'id': id, 'message': message},
    );
    if (response['statusCode'] != 200) {
      throw ServerException();
    }
  }

  @override
  Future<List<MessageModel>> getMessages(int chatRoomId) async {
    final response =
        await apiConsumer.post(EndPoints.getMessages, body: {'id': chatRoomId});
    if (response['statusCode'] != 200) {
      throw ServerException();
    }
    return (response['data']['messages'] as List)
        .map((i) => MessageModel.fromJson(i))
        .toList();
  }

  @override
  Future<List<ContactModel>> getContacts() async {
    final response = await apiConsumer.get(EndPoints.getContacts);
    if (response['statusCode'] != 200) {
      throw ServerException();
    }
    return (response['data']['contacts'] as List)
        .map((i) => ContactModel.fromJson(i))
        .toList();
  }
}
