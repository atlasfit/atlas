/* Represents an exercise with various properties such as name, sets, reps, weight, equipment, target muscle, and description. */
class Exercise {
  String name;
  String sets;
  String reps;
  String weight;
  String equipment;
  String targetMuscle;
  String description;

  /// Constructs an Exercise object with the given [name] and optional parameters for [sets], [reps], [weight], [equipment], [targetMuscle], and [description].
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
