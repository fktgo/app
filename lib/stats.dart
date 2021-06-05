import 'package:app/session.dart';
import 'package:geolocator/geolocator.dart';

class StatsCalculator {
  final List<Event> _data;

  StatsCalculator(this._data);

  SessionStats calculate() {
    var events = _data.where((e) => e.isValid());
    return SessionStats(
      duration: events.isNotEmpty ? events.last.timestamp.difference(events.first.timestamp) : Duration(),
      distance: distance(events.toList(growable: false)),
    );
  }

  double distance(List<Event> events) {
    double d = 0;
    int i = 0, j = 1;
    while (j < events.length) {
      d = d +
          Geolocator.distanceBetween(events[i].lat ?? 0, events[i].lon ?? 0, events[j].lat ?? 0, events[j].lon ?? 0);
      i = j;
      j++;
    }
    return d;
  }
}

class SessionStats {
  final Duration duration;
  final double distance;
  // Minutes per km
  double get avgPace => distance < 1 ? 0 : duration.inMinutes / (distance / 1000);

  SessionStats({required this.duration, required this.distance});
}
