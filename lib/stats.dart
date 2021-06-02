import 'package:app/session.dart';
import 'package:geolocator/geolocator.dart';

class StatsCalculator {
  final List<Event> data;

  StatsCalculator(this.data);

  SessionStats calculate() {
    return SessionStats(
      duration: data.last.timestamp.difference(data.first.timestamp),
      distance: distance(),
    );
  }

  double distance() {
    double d = 0.0;
    int i = 0, j;
    do {
      while (i < data.length - 1 && data[i].lat == null) {
        i++;
      }
      j = i + 1;
      while (j < data.length && data[j].lat == null) {
        j++;
      }
      if (j < data.length) {
        d = d + Geolocator.distanceBetween(data[i].lat ?? 0, data[i].lon ?? 0, data[j].lat ?? 0, data[j].lon ?? 0);
        i = j;
      }
    } while (j < data.length);
    return d;
  }
}

class SessionStats {
  final Duration duration;
  final double distance;

  SessionStats({required this.duration, required this.distance});
}
