import 'dart:async';
import 'dart:developer';

import 'package:geolocator/geolocator.dart';


class Inputs {
  double? _lat;
  double? _lon;

  Future<void> start() async {}
  Future<void> stop() async {}

  double? get lat {
    return _lat;
  }

  double? get lon {
    return _lon;
  }
}

class DeviceInputs extends Inputs {
  StreamSubscription? stream;

  Future<bool> _haveLocationPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      log('Location services are disabled.');
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log('Location permissions are denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      log('Location permissions are permanently denied, we cannot request permissions.');
    }

    return true;
  }

  Future<void> start() async {
    if (await _haveLocationPermissions()) {
      stream = Geolocator.getPositionStream().listen((Position position) {
        if (position == null) {
          _lat = null;
          _lon = null;
        } else {
          _lat = position.latitude;
          _lon = position.longitude;
        }
      });
    }
  }

  Future<void> stop() async {
    stream?.cancel();
  }
}

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
    e.lat = inputs.lat;
    e.lon = inputs.lon;
    e.timestamp = DateTime.now().toUtc();
    return e;
  }

  @override
  String toString() {
    return '{$timestamp}: {$lat} / {$lon}';
  }
}