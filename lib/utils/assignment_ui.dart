import 'package:flutter/material.dart';
import '../assignment.dart';

class StatusColors {
  const StatusColors({required this.container, required this.content});

  final Color container;
  final Color content;
}

StatusColors resolveStatusColors(ColorScheme scheme, Assignment assignment) {
  if (assignment.isSubmitted) {
    if (assignment.isLateSubmission) {
      return StatusColors(
        container: scheme.tertiaryContainer,
        content: scheme.onTertiaryContainer,
      );
    }
    return StatusColors(
      container: scheme.primaryContainer,
      content: scheme.onPrimaryContainer,
    );
  }
  if (assignment.isOverdue) {
    return StatusColors(
      container: scheme.errorContainer,
      content: scheme.onErrorContainer,
    );
  }
  return StatusColors(
    container: scheme.secondaryContainer,
    content: scheme.onSecondaryContainer,
  );
}
