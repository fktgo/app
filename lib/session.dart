import 'dart:async';

import 'package:app/inputs.dart';

class Session {
  final List<Event> events = [];
  final Inputs inputs;
  Timer? timer;
  Duration delay = Duration(seconds: 1);

  Session(this.inputs);

  Future<void> start() async {
    await inputs.start();
    await collect();
    if (timer == null) {
      timer = Timer.periodic(delay, timedCollect);
    }
  }

  Future<void> stop() async {
    timer?.cancel();
    await inputs.stop();
  }

  Future<void> collect() async {
    events.add(Event.fromInputs(inputs));
  }

  void timedCollect(Timer t) {
    collect();
  }

  bool isActive() {
    return this.timer?.isActive ?? false;
  }

  @override
  String toString() {
    return events.map((e) => e.toString()).join("\n");
  }
}

class Event {
  DateTime timestamp;
  double? lat;
  double? lon;

  Event({required this.timestamp, this.lat, this.lon});

  static Event fromInputs(Inputs inputs) {
    return Event(
      lat: inputs.location?.lat,
      lon: inputs.location?.lon,
      timestamp: DateTime.now().toUtc(),
    );
  }

  bool isValid() {
    return lat != null && lon != null;
  }

  @override
  String toString() {
    return '{$timestamp}: {$lat} / {$lon}';
  }
}
