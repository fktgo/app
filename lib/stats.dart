import 'package:app/session.dart';

class StatsCalculator {
  final List<Event> data;

  StatsCalculator(this.data);

  SessionStats calculate() {
    return SessionStats(
      duration: data.last.timestamp.difference(data.first.timestamp),
    );
  }
}

class SessionStats {
  final Duration duration;

  SessionStats({required this.duration});
}
