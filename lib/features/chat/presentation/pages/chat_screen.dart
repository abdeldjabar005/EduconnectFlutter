import 'dart:convert';
import 'dart:math';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:educonnect/core/utils/logger.dart';
import 'package:educonnect/features/auth/data/repositories/token_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:educonnect/features/auth/data/models/user_model.dart';
import 'package:educonnect/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:educonnect/features/chat/data/models/contact_model.dart';
import 'package:educonnect/features/chat/data/models/message_model.dart';
import 'package:educonnect/features/chat/presentation/cubit/messages_cubit.dart';
import 'package:educonnect/features/chat/presentation/widgets/startup_container.dart';

class ChatScreen extends StatefulWidget {
  final ContactModel contact;

  ChatScreen({required this.contact, super.key});

  static const routeName = "/chat";

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late PusherChannelsFlutter pusher;
  bool isSubscribed = false;
  int userid = 0;
  @override
  void initState() {
    super.initState();
    _initializePusher();
  }

  Future<void> _initializePusher() async {
    final authCubit = context.read<AuthCubit>();

    setState(() {
      userid = authCubit.currentUser!.id;
    });

    pusher = PusherChannelsFlutter.getInstance();

    try {
      await pusher.init(
        apiKey: '302253a19878edcfab21',
        cluster: 'eu',
        onEvent: _handleEvent,
        onAuthorizer: onAuthorizer,
        // onConnectionStateChange: onConnectionStateChange,
        // onError: onError,
        // onSubscriptionSucceeded: onSubscriptionSucceeded,
        // onSubscriptionError: onSubscriptionError,
        // onDecryptionFailure: onDecryptionFailure,
        // onMemberAdded: onMemberAdded,
        // onMemberRemoved: onMemberRemoved,
        // onSubscriptionCount: onSubscriptionCount,
      );

      await pusher.connect();
      await listenChatChannel(userid);

      PusherEvent event = PusherEvent(
        channelName: "private-chatify.${widget.contact.id}",
        eventName: "client-seen",
        data: jsonEncode({
          "from_id": authCubit.currentUser!.id,
          "to_id": widget.contact.id,
          "seen": true,
        }),
      );

      // bool triggered = await triggerPusherEvent(event);
      // if (!triggered) {
      //   vLog("Failed to trigger event: channel not subscribed or null");
      // }
    } catch (e) {
      vLog("Error in initialization: $e");
    }
  }

  Future<void> listenChatChannel(int id) async {
    if (isSubscribed) {
      return;
    }

    try {
      await pusher.subscribe(
        channelName: 'private-chatify.$id',
        onEvent: _handleEvent,
      );
      await pusher.subscribe(
        channelName: 'private-chatify.$widget.contact.id',
        onEvent: _handleEvent,
      );
      setState(() {
        isSubscribed = true;
      });
      vLog(pusher.connectionState);
    } catch (e) {
      vLog("Subscription error: $e");
    }
  }

  Future<bool> triggerPusherEvent(PusherEvent event) async {
    try {
      if (pusher == null) {
        await pusher.init(
          apiKey: '302253a19878edcfab21',
          cluster: 'eu',
          onEvent: _handleEvent,
          onAuthorizer: onAuthorizer,
          // onConnectionStateChange: onConnectionStateChange,
          // onError: onError,
          // onSubscriptionSucceeded: onSubscriptionSucceeded,
          // onSubscriptionError: onSubscriptionError,
          // onDecryptionFailure: onDecryptionFailure,
          // onMemberAdded: onMemberAdded,
          // onMemberRemoved: onMemberRemoved,
          // onSubscriptionCount: onSubscriptionCount,
        );
      }

      // await pusher.connect();
      // await pusher.subscribe(channelName: event.channelName);

      await pusher.trigger(event);
      return true;
    } catch (e) {
      vLog("Error triggering event: $e");
      return false;
    }
  }

  dynamic onAuthorizer(
      String channelName, String socketId, dynamic options) async {
    final storage = FlutterSecureStorage();
    final tokenProvider = TokenProvider(secureStorage: storage);
    String? token = await tokenProvider.getToken();

    var authUrl = "http://127.0.0.1:8000/chatify/api/chat/auth";
    var result = await http.post(
      Uri.parse(authUrl),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token',
      },
      body: {'socket_id': socketId, 'channel_name': channelName},
    );
    var json = jsonDecode(result.body);
    return {
      "auth": json['auth'],
    };
  }

  Set<String> handledEvents = {};

  dynamic _handleEvent(dynamic event) {
    if (event is PusherEvent) {
      vLog("Received event: ${event.eventName} data: ${event.data} ${event}");
      if (event.data == null || event.data.isEmpty) {
        return;
      }
      String eventIdentifier = "${event.eventName}-${event.data}";
      if (handledEvents.contains(eventIdentifier)) {
        return;
      }
      handledEvents.add(eventIdentifier);

      if (event.eventName == "messaging") {
        final data = jsonDecode(event.data);
        wLog(data);
        _handleNewMessage(data);
      } else if (event.eventName == "client-seen") {
        final data = jsonDecode(event.data);
        wLog(data);
      }
    } else {
      vLog("Received event is not of type PusherEvent");
    }
  }

  Future<void> leaveChatChannel(int id) async {
    if (!isSubscribed) {
      return;
    }

    try {
      await pusher.unsubscribe(channelName: 'private-chatify.$id');
      setState(() {
        isSubscribed = false;
      });
    } catch (e) {
      vLog("Unsubscription error: $e");
    }
  }

  void _handleNewMessage(final eventdata) {
    final messagesCubit = context.read<MessagesCubit>();
    if (messagesCubit.state is MessagesLoaded) {
      final regex = RegExp(r'<div class="message">\s*(.*?)\s*<');
      final match = regex.firstMatch(eventdata['message']);
      if (match != null && match.groupCount >= 1) {
        final content = match.group(1);
        eventdata['message'] = content;
      }

      DateTime now = DateTime.now();

      final message = MessageModel(
        id: generateRandomString(10),
        fromId: eventdata['from_id'],
        toId: int.parse(eventdata['to_id']),
        body: eventdata['message'],
        seen: true,
        createdAt: now,
        updatedAt: now,
        user: ChatUser(
          id: widget.contact.id.toString(),
          firstName: widget.contact.firstName,
          lastName: widget.contact.lastName,
        ),
      );

      messagesCubit.addNewMessage(message);
    }
  }

  @override
  void dispose() {
    leaveChatChannel(userid);
    pusher.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messagesCubit = context.read<MessagesCubit>();
    final authCubit = context.read<AuthCubit>();

    return StartUpContainer(
      onInit: () {
        messagesCubit.getMessages(widget.contact.id);
        listenChatChannel(userid);
      },
      onDisposed: () {
        leaveChatChannel(userid);
        messagesCubit.resetChat();
      },
      child: Scaffold(
        appBar: AppBar(
          title: BlocConsumer<MessagesCubit, MessagesState>(
            listener: (context, state) {
              if (state is MessagesLoaded) {
                listenChatChannel(userid);
              }
            },
            builder: (context, state) {
              if (state is MessagesLoaded) {
                return Text(
                    "${widget.contact.firstName} ${widget.contact.lastName}");
              }
              return const Text("Chat");
            },
          ),
        ),
        body: BlocBuilder<MessagesCubit, MessagesState>(
          builder: (context, state) {
            if (state is MessagesLoaded) {
              return DashChat(
                currentUser: authCubit.getChatUser(),
                onSend: (ChatMessage chatMessage) async {
                  if (!isSubscribed) {
                    print("Cannot send message: not subscribed to channel");
                    return;
                  }

                  DateTime now = DateTime.now();
                  messagesCubit.sendMessage(
                    generateRandomString(10),
                    chatMessage.text,
                    authCubit.currentUser!.id,
                    widget.contact.id,
                    now,
                    now,
                    authCubit.getChatUser().firstName,
                    authCubit.getChatUser().lastName,
                  );

                  bool triggered = await triggerPusherEvent(
                    PusherEvent(
                        channelName: "private-chatify.$userid",
                        eventName: "client-contactItem",
                        data: jsonEncode({
                          "from": authCubit.currentUser!.id.toString(),
                          "to": widget.contact.id.toString(),
                          "update": true,
                        })),
                  );
                  if (!triggered) {
                    vLog(
                        "Failed to trigger event: channel not subscribed or null");
                  }
                },
                messages: state.messages.map((e) => e.toChatMessage).toList(),
                messageListOptions: MessageListOptions(
                  onLoadEarlier: () async {
                    // Load more messages logic here
                  },
                ),
              );
            } else if (state is MessagesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MessagesError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text("No messages loaded"));
            }
          },
        ),
      ),
    );
  }

  String generateRandomString(int length) {
    const _randomChars =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    const _charsLength = _randomChars.length;

    final rand = Random();
    final codeUnits = List.generate(length, (index) {
      int randIndex = rand.nextInt(_charsLength);
      return _randomChars.codeUnitAt(randIndex);
    });

    return String.fromCharCodes(codeUnits);
  }
}
