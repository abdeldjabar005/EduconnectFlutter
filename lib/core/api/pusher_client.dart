// import 'dart:async';
// import 'package:dart_pusher_channels/dart_pusher_channels.dart';
// import 'package:educonnect/core/utils/logger.dart';

// class WebSocketService {
//   final String scheme;
//   final String host;
//   final String key;
//   final int port;

//   late PusherChannelsClient _client;
//   PrivateChannel? _channel;

//   StreamSubscription<PusherChannelsReadEvent>? _allEventsSubscription;
//   StreamSubscription<ChannelReadEvent>? _eventSubscription;

//   WebSocketService({
//     required this.scheme,
//     required this.host,
//     required this.key,
//     this.port = 6001,
//   }) {
//     final options = PusherChannelsOptions.fromHost(
//       scheme: 'ws',
//       host: '10.0.2.2',
//       key: 'eduKey',
//       shouldSupplyMetadataQueries: true,
//       metadata: PusherChannelsOptionsMetadata.byDefault(),
//       port: 6001,
//     );

//     _client = PusherChannelsClient.websocket(
//       options: options,
//       connectionErrorHandler: (exception, trace, refresh) {
//         vLog('Connection error: $exception');
//         refresh();
//       },
//       minimumReconnectDelayDuration: const Duration(seconds: 1),
//       defaultActivityDuration: const Duration(seconds: 120),
//       activityDurationOverride: const Duration(seconds: 120),
//       waitForPongDuration: const Duration(seconds: 30),
//     );

//     _client.onConnectionEstablished.listen((_) {
//       vLog('CONNECTION ESTABLISTED');
//       _channel?.subscribeIfNotUnsubscribed();
//     });
//   }

//   void connect() async {
//     await _client.connect().then((value) {
//       vLog('connection value... ');
//     }).catchError((e) {
//       vLog('caught connection error--');
//       vLog(e);
//     });
//   }

//   void disconnect() {
//     _allEventsSubscription?.cancel();
//     _eventSubscription?.cancel();
//     _client.disconnect();
//   }

//   void subscribeToChannel(String channelName, String token,
//       {bool isPrivate = false, Uri? authorizationEndpoint}) {
//     PrivateChannel channel;
//     channel = _client.privateChannel(
//       channelName,
//       authorizationDelegate:
//           EndpointAuthorizableChannelTokenAuthorizationDelegate
//               .forPrivateChannel(
//         authorizationEndpoint:
//             Uri.parse('http://10.0.2.2/chatify/api/chat/auth'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': "application/json",
//           "Authorization": "Bearer $token",
//         },
//         onAuthFailed: (exception, trace) {
//           dLog(exception);
//         },
//       ),
//     );

//     _channel = channel;
//     channel.subscribeIfNotUnsubscribed();
//   }

//   StreamSubscription<ChannelReadEvent> bindEvent(
//       String eventName, void Function(ChannelReadEvent) onData) {
//     if (_channel == null) throw Exception('No channel subscribed');
//     final subscription = _channel!.bind(eventName).listen(onData);
//     _eventSubscription = subscription;
//     return subscription;
//   }

//   void unbindEvent() {
//     _eventSubscription?.cancel();
//     _eventSubscription = null;
//   }

//   void triggerEvent(String eventName, Map<String, dynamic> data) {
//     if (_channel == null) throw Exception('No channel subscribed');

//     _channel!.trigger(eventName: eventName, data: data);
//     // vLog('Event $eventName triggered with data: $data');
//   }

//   void subscribeToAllEvents(void Function(PusherChannelsReadEvent) onData) {
//     _allEventsSubscription = _client.eventStream.listen(onData);
//   }

//   void unsubscribeFromAllEvents() {
//     _allEventsSubscription?.cancel();
//     _allEventsSubscription = null;
//   }
// }
