class RouteStep {
  String instruction;
  int type;
  int distance;

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

  RouteStep.fromMap(Map map) {
    instruction = map['instruction'] as String;
    type = map['type'] as int;
    distance = map['distance'] as int;
  }

  @override
  String toString() {
    return 'RouteStep{instruction: $instruction, type: $type, distance: $distance}';
  }
}
