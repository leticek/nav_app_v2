import 'package:flutter/material.dart';
import 'package:map_elevation/map_elevation.dart';

class ElevationGraph extends StatelessWidget {
  const ElevationGraph({
    Key key,
    @required this.onNotification,
    @required this.points,
  }) : super(key: key);

  final bool Function(ElevationHoverNotification) onNotification;
  final List<ElevationPoint> points;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ElevationHoverNotification>(
      onNotification: onNotification,
      child: Elevation(
        points,
        color: Colors.blue.withOpacity(0.85),
        elevationGradientColors: ElevationGradientColors(
          gt10: Colors.green,
          gt20: Colors.orangeAccent,
          gt30: Colors.redAccent,
        ),
      ),
    );
  }
}
