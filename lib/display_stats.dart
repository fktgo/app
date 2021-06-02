import 'package:app/stats.dart';
import 'package:flutter/material.dart';

class DisplayStats extends StatelessWidget {
  final SessionStats stats;

  DisplayStats(this.stats);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Center(
          child: Column(
        children: [
          Expanded(
              child: Column(children: [
            Text('Duration: ${stats.duration}'),
            Text('Distance: ${displayDecimal(stats.distance)}m'),
            Text('Average pace: ${displayDecimal(stats.avg_pace)} min/km'),
          ])),
          Container(
            child: ElevatedButton(child: Text("Ok"), onPressed: () => Navigator.pop(context)),
            width: 200,
          ),
        ],
      )),
      padding: EdgeInsets.only(top: 100, bottom: 20, left: 10, right: 10),
    ));
  }

  String displayDecimal(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }
}
