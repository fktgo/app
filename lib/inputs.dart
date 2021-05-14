import 'dart:async';
import 'dart:developer';

import 'package:geolocator/geolocator.dart';


class Inputs {
  LocationInputs? location;

  Inputs({this.location});

  Future<void> start() async {
    await location?.start();
  }

  Future<void> stop() async {
    await location?.stop();
  }
}

class LocationInputs {
  double? _lat;
  double? _lon;

  double? get lat {
    return _lat;
  }

  double? get lon {
    return _lon;
  }

  Future<void> start() async {}
  Future<void> stop() async {}
}

class DeviceLocationInputs extends LocationInputs {
  StreamSubscription? stream;

  Future<bool> _hasLocationPermissions() async {
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
    if (await _hasLocationPermissions()) {
      stream = Geolocator.getPositionStream().listen((Position position) {
        _lat = position.latitude;
        _lon = position.longitude;
      });
    }
  }

  Future<void> stop() async {
    stream?.cancel();
  }
}
