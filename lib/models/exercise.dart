class Exercise {
  String name;
  String sets;
  String reps;
  String weight;
  String equipment;
  String targetMuscle;
  String description;

  Exercise({
    required this.name,
    this.sets = "0",
    this.reps = "0",
    this.weight = "0",
    this.equipment = "",
    this.targetMuscle = "",
    this.description = "",
  });
}
