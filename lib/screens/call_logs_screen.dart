import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_calling/services/shared_preferences_service.dart';
import '../services/call_log_service.dart';

class CallLogsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Call Logs'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: SharedPref.getString('saveCallLog') != null
              ? SharedPref.getString('saveCallLog')!
                  .split('+')
                  .map((e) => Text(e))
                  .toList()
              : [],
        ),
      ),
    );
  }
}
