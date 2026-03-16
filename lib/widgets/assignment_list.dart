import 'package:flutter/material.dart';
import '../assignment.dart';
import 'assignment_card.dart';

class AssignmentList extends StatelessWidget {
  const AssignmentList({
    super.key,
    required this.assignments,
    required this.onOpenSubmission,
    this.emptyMessage = 'Không có bài tập.',
  });

  final List<Assignment> assignments;
  final void Function(Assignment assignment) onOpenSubmission;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (assignments.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: assignments.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final assignment = assignments[index];
        return AssignmentCard(
          assignment: assignment,
          onOpenSubmission: onOpenSubmission,
        );
      },
    );
  }
}
