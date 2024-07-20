import 'package:hive/hive.dart';

part 'call_log.g.dart';

@HiveType(typeId: 0)
class CallLog {
  @HiveField(0)
  final String? targetUser;
  @HiveField(1)
  final DateTime? timestamp;
  @HiveField(2)
  final Duration? duration;

  CallLog(
      { this.targetUser,
       this.timestamp,
       this.duration});
}
