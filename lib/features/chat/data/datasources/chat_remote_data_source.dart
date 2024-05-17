import 'dart:async';
import 'dart:convert';

import 'package:educonnect/core/api/api_consumer.dart';
import 'package:educonnect/core/api/end_points.dart';
import 'package:educonnect/core/api/pusher_service.dart';
import 'package:educonnect/core/error/exceptions.dart';
import 'package:educonnect/features/chat/data/models/message_model.dart';
import 'package:pusher_client/pusher_client.dart';

abstract class ChatRemoteDataSource {
  Future<void> sendMessage(MessageModel message);
  Stream<List<MessageModel>> getMessages(String chatRoomId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ApiConsumer apiConsumer;
  final PusherService pusherService;

  ChatRemoteDataSourceImpl({required this.apiConsumer, required this.pusherService});

  @override
  Future<void> sendMessage(MessageModel message) async {
    final response = await apiConsumer.post(
      EndPoints.sendMessage,
      body: message.toJson(),
    );
    if (response['statusCode'] != 201) {
      throw ServerException();
    }
  }

  @override
  Stream<List<MessageModel>> getMessages(String chatRoomId) async* {
    final StreamController<List<MessageModel>> _controller = StreamController<List<MessageModel>>();
    
    pusherService.subscribe('private-chatify.$chatRoomId');
    pusherService.bind('private-chatify.$chatRoomId', 'my-event', (PusherEvent event) {
      final data = jsonDecode(event.data!);
      final message = MessageModel.fromJson(data);
      _controller.add([message]); // Emit the new message
    });
  
    final response = await apiConsumer.get(EndPoints.getMessages);
    if (response['statusCode'] != 200) {
      throw ServerException();
    }
  
    yield* _controller.stream; // Emit the messages from the StreamController
  
    yield (response['data']['data'] as List)
        .map((i) => MessageModel.fromJson(i))
        .toList();
  }
}