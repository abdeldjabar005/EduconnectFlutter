import 'package:educonnect/core/api/end_points.dart';
import 'package:pusher_client_fixed/pusher_client_fixed.dart';

class LaravelPusher {
  static LaravelPusher? _singleton;
  static late PusherClient _pusher;
  final String token;
  final _subscribedChannels = <String>{};

  LaravelPusher._({
    required this.token,
  }) {
    _pusher = createPusherClient(token);
  }

  factory LaravelPusher.init({
    required String? token,
  }) {
    if (_singleton == null || token != _singleton?.token) {
      _singleton = LaravelPusher._(token: token!);
    }

    return _singleton!;
  }

  static PusherClient get instance => _pusher;

  void subscribe(String channelName) {
    if (!_subscribedChannels.contains(channelName)) {
      _pusher.subscribe(channelName);
      _subscribedChannels.add(channelName);
    }
  }

  void unsubscribe(String channelName) {
    _pusher.unsubscribe(channelName);
    _subscribedChannels.remove(channelName);
  }
}

PusherClient createPusherClient(String token) {
  PusherOptions options = PusherOptions(
    host: '127.0.0.1',
    wsPort: 6001,
    wssPort: 6001,
    encrypted: false,
    auth: PusherAuth(
      EndPoints.auth,
      headers: {
        'Authorization': "Bearer $token",
        'Content-Type': "application/json",
        'Accept': 'application/json' 
      },
    ),
  );

  PusherClient pusherClient = PusherClient(
    'localKey',
    options,
    autoConnect: true,
    enableLogging: true,
  );

  return pusherClient;
}
