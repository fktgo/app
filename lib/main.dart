import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:app/session.dart';
import 'package:app/inputs.dart';

void main() {
  runApp(FKTGo());
}

class FKTGo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FKT Go',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: FKTGoHome(title: 'FKT Go'),
    );
  }
}

class FKTGoHome extends StatefulWidget {
  final String? title;

  FKTGoHome({Key? key, this.title}) : super(key: key);

  @override
  _FKTGoHomeState createState() => _FKTGoHomeState();
}

class _FKTGoHomeState extends State<FKTGoHome> {
  bool recording = false;
  Session? session;

  void _toggleRecording() {
    setState(() {
      recording = !recording;

      if (recording) {
        session = Session(Inputs(location: DeviceLocationInputs()));
        session?.start();
      } else {
        session?.stop();
        log(session.toString());
        session = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(recording ? '' : 'Ready?'),
            Container(
              child: ElevatedButton(
                onPressed: _toggleRecording,
                child: Text(recording ? 'Stop' : 'Go'),
                style: ButtonStyle(
                  shape:
                      MaterialStateProperty.all<CircleBorder>(CircleBorder()),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      recording ? Colors.deepOrange : Colors.green),
                ),
              ),
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
