import 'package:atlas/models/workout.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkoutCard extends StatelessWidget {
  final CompletedWorkout workout;

  const WorkoutCard({
    super.key,
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateTime timestampDate = workout.completedTime.toDate();
    final Duration timeDifference = now.difference(timestampDate);

    String formattedTimestamp;
    if (timeDifference.inDays > 1) {
      formattedTimestamp = DateFormat('h:mm a MMMM d, y').format(timestampDate);
    } else if (timeDifference.inDays == 1) {
      formattedTimestamp =
          'Yesterday at ${DateFormat('h:mm a').format(timestampDate)}';
    } else if (timeDifference.inHours >= 1) {
      formattedTimestamp =
          'Today at ${DateFormat('h:mm a').format(timestampDate)}';
    } else {
      formattedTimestamp = '${timeDifference.inMinutes} minutes ago';
    }

    return Card(
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Completed by: ${workout.completedBy.firstName} ${workout.completedBy.lastName}',
            ),
            const SizedBox(height: 4),
            Text('Completed: $formattedTimestamp'),
            const SizedBox(height: 8),
            Text(workout.workoutName),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(workout.description),
            const SizedBox(height: 8),
            Text(
              'Created by: ${workout.createdBy.firstName} ${workout.createdBy.lastName}',
            ),
          ],
        ),
      ),
    );
  }
}
