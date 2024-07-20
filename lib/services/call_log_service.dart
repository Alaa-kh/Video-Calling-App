import 'package:hive/hive.dart';
import 'package:video_calling/main.dart';
import '../models/call_log.dart';

class CallLogService {
  Future<void> saveCallLog(
      String targetUser, DateTime timestamp, Duration duration) async {
    if (box != null) {
      final callLog = CallLog(
          targetUser: targetUser, timestamp: timestamp, duration: duration);

      await box!.put('callLogs', callLog);
    }
  }

  Future<List<CallLog>> getCallLogs() async {
    final box = await Hive.openBox<CallLog>('callLogs');
    return box.values.toList();
  }
  
}
