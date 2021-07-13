import 'package:app/session.dart';
import 'package:geolocator/geolocator.dart';

class StatsCalculator {
  final List<Event> _data;

  StatsCalculator(this._data);

  SessionStats calculate() {
    var events = _data.where((e) => e.isValid());
    return SessionStats(
      firstEvent: events.first,
      lastEvent: events.last,
      numEvents: events.length,
      numInvalidEvents: _data.length - events.length,
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
  // DEBUG
  final int numEvents;
  final int numInvalidEvents;
  final Event firstEvent;
  final Event lastEvent;
  final Duration duration;
  // In meters
  final double distance;
  // Minutes per km
  double get avgPace {
    var durationMinutes = duration.inSeconds / Duration.secondsPerMinute;
    return distance < 1 ? 0 : durationMinutes / (distance / 1000);
  }

  SessionStats(
      {required this.firstEvent,
      required this.lastEvent,
      required this.numEvents,
      required this.numInvalidEvents,
      required this.duration,
      required this.distance});
}
