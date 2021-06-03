import 'package:app/session.dart';
import 'package:app/stats.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var now = DateTime.now().toUtc();

  group('StatsCalculator', () {
    test('StatsCalculator with empty data', () {
      final calculator = StatsCalculator([]);
      final stats = calculator.calculate();

      expect(stats.duration, Duration());
      expect(stats.distance, 0);
      expect(stats.avgPace, 0);
    });

    test('StatsCalculator with single event', () {
      final calculator = StatsCalculator([
        Event(lat: 0.1, lon: 0, timestamp: now),
      ]);
      final stats = calculator.calculate();

      expect(stats.duration, Duration());
      expect(stats.distance, 0);
      expect(stats.avgPace, 0);
    });

    test('StatsCalculator with 2 events, 10 min/km', () {
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

    test('StatsCalculator with multiple events, 10 min/km', () {
      final List<Event> events = [
        Event(lat: 0, lon: 0, timestamp: now),
        Event(lat: 0.001, lon: 0, timestamp: now.add(Duration(minutes: 1))),
        Event(lat: 0.007, lon: 0, timestamp: now.add(Duration(minutes: 8))),
        Event(lat: 0.008, lon: 0, timestamp: now.add(Duration(seconds: 8 * 60 + 90))),
        Event(lat: 0.00899, lon: 0, timestamp: now.add(Duration(seconds: 8 * 60 + 120))),
      ];
      final stats = StatsCalculator(events).calculate();

      expect(stats.duration, Duration(minutes: 10));
      expect(stats.distance, inClosedOpenRange(1000, 1001));
      expect(stats.avgPace, inClosedOpenRange(9.9, 10));
    });

    test('StatsCalculator with events going back and forth', () {
      final List<Event> events = [
        Event(lat: 0, lon: 0, timestamp: now),
        Event(lat: 0.00899, lon: 0, timestamp: now.add(Duration(minutes: 1))),
        Event(lat: 0, lon: 0, timestamp: now.add(Duration(minutes: 2))),
        Event(lat: 0.00899, lon: 0, timestamp: now.add(Duration(minutes: 3))),
        Event(lat: 0, lon: 0, timestamp: now.add(Duration(minutes: 4))),
      ];
      final stats = StatsCalculator(events).calculate();

      expect(stats.duration, Duration(minutes: 4));
      expect(stats.distance, inClosedOpenRange(4000, 4004));
      expect(stats.avgPace, inClosedOpenRange(0.9, 1));
    });

    test('StatsCalculator skips invalid events', () {
      Event invalid1 = Event(lat: 42, lon: null, timestamp: now.add(Duration(minutes: 5)));
      Event invalid2 = Event(lat: null, lon: 1, timestamp: now.add(Duration(minutes: 9)));
      Event invalid3 = Event(lat: null, lon: null, timestamp: now.add(Duration(minutes: 10)));

      final List<Event> events = [
        Event(lat: 0, lon: 0, timestamp: now),
        Event(lat: 0.001, lon: 0, timestamp: now.add(Duration(minutes: 1))),
        invalid1,
        Event(lat: 0.007, lon: 0, timestamp: now.add(Duration(minutes: 8))),
        invalid2,
        invalid3,
        Event(lat: 0.008, lon: 0, timestamp: now.add(Duration(seconds: 8 * 60 + 90))),
        Event(lat: 0.00899, lon: 0, timestamp: now.add(Duration(seconds: 8 * 60 + 120))),
      ];
      final stats = StatsCalculator(events).calculate();

      expect(invalid1.isValid(), false);
      expect(invalid2.isValid(), false);
      expect(invalid3.isValid(), false);

      expect(stats.duration, Duration(minutes: 10));
      expect(stats.distance, inClosedOpenRange(1000, 1001));
      expect(stats.avgPace, inClosedOpenRange(9.9, 10));
    });

    test('StatsCalculator only invalid events', () {
      final List<Event> events = [
        Event(lat: 42, lon: null, timestamp: now.add(Duration(minutes: 1))),
        Event(lat: null, lon: 1, timestamp: now.add(Duration(minutes: 2))),
        Event(lat: null, lon: null, timestamp: now.add(Duration(minutes: 3))),
      ];
      final stats = StatsCalculator(events).calculate();

      expect(stats.duration, Duration());
      expect(stats.distance, 0);
      expect(stats.avgPace, 0);
    });
  });
}
