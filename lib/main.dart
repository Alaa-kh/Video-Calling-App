import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:video_calling/models/call_log.dart';
import 'package:video_calling/screens/call_logs_screen.dart';
import 'package:video_calling/screens/splash_screen.dart';
import 'package:video_calling/services/analytics_service.dart';
import 'package:video_calling/services/auth_service.dart';
import 'package:video_calling/services/call_log_service.dart';
import 'package:video_calling/services/shared_preferences_service.dart';

const appId = "00327421ed534dcfb114f157d2cbf941";
const token =
    '007eJxTYLDkK1m55WJf4dXyK0WPxeKmJ+y6UjzzQX3CjaDdt5f0Nt5SYDAwMDYyNzEyTE0xNTZJSU5LMjQ0STM0NU8xSk5KszQxnHNjVlpDICPDodrHrIwMEAjiczMk5iQmxmdnJOakpjAwAAA0LCXS';
const channel = "alaa_khaled";
Box<CallLog>? box;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPref.init(); // Initialize shared preferences

  await Firebase.initializeApp();
  // Initialize Hive
  await Hive.initFlutter();

  // Register the adapter
  Hive.registerAdapter(CallLogAdapter());

  // Open a box
  box = await Hive.openBox('callLogs');

  // Open a box

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<AnalyticsService>(create: (_) => AnalyticsService()),
        Provider<CallLogService>(create: (_) => CallLogService()),
      ],
      child: MaterialApp(
        theme: ThemeData(scaffoldBackgroundColor: Colors.amber[600]),
        debugShowCheckedModeBanner: false,
        home: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    try {
      await _engine.initialize(const RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ));
    } catch (_) {}

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    try {
      await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      await _engine.enableVideo();
      await _engine.startPreview();

      await _engine.joinChannel(
        token: token,
        channelId: channel,
        uid: int.parse(SharedPref.getString('uid') ?? '1'),
        options: const ChannelMediaOptions(),
      );
      // await analyticsService.logCallStart();
    } catch (_) {}
  }

  @override
  void dispose() {
    super.dispose();

    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    final callLogService = Provider.of<CallLogService>(context);
    final analyticsService = Provider.of<AnalyticsService>(context);
    return Scaffold(
      floatingActionButton: _localUserJoined
          ? FloatingActionButton(
              onPressed: () async {
                await analyticsService.logCallEnd();

                SharedPref.setString(
                  'saveCallLog',
                  '${DateTime.now().toString()}+',
                );

                exit(0);
              },
              child: Icon(Icons.call_end),
              backgroundColor: Colors.red,
            )
          : null,
      appBar: AppBar(
        title: const Text('Agora Video Call'),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CallLogsScreen())),
              icon: Icon(Icons.toc_outlined))
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: _remoteVideo(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: Center(
                child: _localUserJoined
                    ? AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: _engine,
                          canvas: VideoCanvas(
                            uid: int.parse(SharedPref.getString('uid') ?? '1'),
                          ),
                        ),
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: channel),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}
