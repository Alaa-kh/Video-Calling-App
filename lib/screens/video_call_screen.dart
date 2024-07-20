// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:video_calling/services/analytics_service.dart';
// import '../services/agora_service.dart';
// import '../services/call_log_service.dart';

// class VideoCallScreen extends StatefulWidget {
//   @override
//   _VideoCallScreenState createState() => _VideoCallScreenState();
// }

// class _VideoCallScreenState extends State<VideoCallScreen> {
//   late RtcEngine _engine;
//   late int _remoteUid;
//   bool _localUserJoined = false;

//   @override
//   void initState() {
//     super.initState();
//     _initAgora();
//   }

//   Future<void> _initAgora() async {
//     final agoraService = Provider.of<AgoraService>(context, listen: false);
//     await agoraService.initialize();
//   RtcEngine? _engine;

//     _engine = await _engine
//         .eng(); // createEngine method should return RtcEngine instance

//     _engine.setEventHandler(RtcEngineEventHandler(
//       joinChannelSuccess: (String channel, int uid, int elapsed) {
//         setState(() {
//           _localUserJoined = true;
//         });
//       },
//       userOffline: (int uid, UserOfflineReason reason) {
//         setState(() {
//           _remoteUid = 0;
//         });
//       },
//       // Other event handlers as needed
//     ));

//     await agoraService.joinChannel(); // Implement your joinChannel method

//     // Optional: Setup local video view
//     _engine.enableVideo();
//     _engine.startPreview(); // Start local video preview
//   }

//   @override
//   void dispose() {
//     final agoraService = Provider.of<AgoraService>(context, listen: false);
//     agoraService.leaveChannel();
//     _engine.destroy(); // Cleanup engine resources
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final agoraService = Provider.of<AgoraService>(context);
//     final callLogService = Provider.of<CallLogService>(context);
//     final analyticsService = Provider.of<AnalyticsService>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Video Call'),
//       ),
//       body: Stack(
//         children: [
//           Center(child: _remoteVideo()),
//           Align(
//             alignment: Alignment.topLeft,
//             child: _localUserJoined
//                 ? _localVideoPreview()
//                 : CircularProgressIndicator(),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           await analyticsService.logCallEnd();
//           await callLogService.saveCallLog(
//               'Target User', DateTime.now(), Duration(seconds: 0));
//           Navigator.pop(context);
//         },
//         child: Icon(Icons.call_end),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }

//   Widget _localVideoPreview() {
//     return Container(
//       width: 150,
//       height: 200,
//       child: Center(
//         child: AspectRatio(
//           aspectRatio: 3 / 4, // Adjust aspect ratio as needed
//           child: RtcLocalView.SurfaceView(),
//         ),
//       ),
//     );
//   }

//   Widget _remoteVideo() {
//     if (_remoteUid != 0) {
//       return RtcRemoteView.SurfaceView(uid: _remoteUid);
//     } else {
//       return Text(
//         'Waiting for remote user to join...',
//         textAlign: TextAlign.center,
//       );
//     }
//   }
// }
