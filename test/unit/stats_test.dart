import 'package:app/session.dart';
import 'package:app/stats.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var now = DateTime.now().toUtc();

  test('StatsCalculator with empty data calculates trivial stats', () {
    final calculator = StatsCalculator([]);
    final stats = calculator.calculate();

    expect(stats.duration, Duration());
    expect(stats.distance, 0);
    expect(stats.avgPace, 0);
  });

  test('StatsCalculator with 2 events, 10 min / km', () {
    final List<Event> events = [
      Event(lat: 0, lon: 0, timestamp: now),
      Event(lat: 0.00899, lon: 0, timestamp: now.add(Duration(minutes: 10))),
    ];
    final stats = StatsCalculator(events).calculate();

    expect(stats.duration, Duration(minutes: 10));
    // Conversion from geographical coordinates is non-trivial, and not relevant.
    // We just need to to be close enough.
    expect(stats.distance, inClosedOpenRange(1000, 1001));
    expect(stats.avgPace, inClosedOpenRange(9.9, 10));
  });
}
