// import 'package:educonnect/core/api/end_points.dart';
// import 'package:pusher_client/pusher_client.dart';

// class PusherService {
//   late PusherClient _pusherClient;

//   PusherService(String token) {
//      _pusherClient = PusherClient(
//       '123456', 
//       PusherOptions(
//       host: 'http://localhost:8000',
//       wsPort: 6001,
//       encrypted: false,
//       auth: PusherAuth(
//         EndPoints.auth,
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//           'Accept': '*/*',
//         },
//       ),
//       ),
//       enableLogging: true,
//     );


//     _pusherClient.connect();

//     _pusherClient.onConnectionStateChange((state) {
//       print("previousState: ${state!.previousState}, currentState: ${state.currentState}");
//     });

//     _pusherClient.onConnectionError((error) {
//       print("error: ${error!.message}");
//     });
//   }

//   Channel subscribe(String channelName) {
//     return _pusherClient.subscribe(channelName);
//   } 

//   void bind(String channelName, String eventName, Function callback) {
//     final channel = _pusherClient.subscribe(channelName);
//     channel.bind(eventName, callback);
//   }
// }