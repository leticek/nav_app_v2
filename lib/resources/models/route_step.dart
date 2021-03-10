class RouteStep {
  final String instruction;
  final int type;
  final int distance;

  RouteStep(
    this.instruction,
    this.type,
    this.distance,
  );

  Map toMap() => {
        "instruction": instruction,
        "type": type,
        "distance": distance,
      };

  @override
  String toString() {
    return 'RouteStep{instruction: $instruction, type: $type, distance: $distance}';
  }
}
