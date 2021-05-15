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
    timer = Timer.periodic(delay, collect);
  }

  Future<void> stop() async {
    timer?.cancel();
    await inputs.stop();
  }

  void collect(Timer t) {
    events.add(Event.fromInputs(inputs));
  }

  @override
  String toString() {
    return events.map((e) => e.toString()).join("\n");
  }
}

class Event {
  DateTime? timestamp;
  double? lat;
  double? lon;

  static Event fromInputs(Inputs inputs) {
    Event e = Event();
    e.lat = inputs.location?.lat;
    e.lon = inputs.location?.lon;
    e.timestamp = DateTime.now().toUtc();
    return e;
  }

  @override
  String toString() {
    return '{$timestamp}: {$lat} / {$lon}';
  }
}
