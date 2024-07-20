import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logCallStart() async {
    await _analytics.logEvent(name: 'call_start');
  }

  Future<void> logCallEnd() async {
    await _analytics.logEvent(name: 'call_end');
  }
}
