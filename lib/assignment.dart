class Assignment {
  Assignment({
    required this.id,
    required this.title,
    required this.subject,
    required this.dueDate,
    required this.points,
    required this.description,
    this.submitted = false,
    this.submittedAt,
    List<String>? submittedFileNames,
  }) : submittedFileNames = submittedFileNames ?? <String>[];

  final String id;
  final String title;
  final String subject;
  final DateTime dueDate;
  final int points;
  final String description;
  bool submitted;
  DateTime? submittedAt;
  List<String> submittedFileNames;

  bool get isOverdue => !submitted && DateTime.now().isAfter(dueDate);
  bool get isSubmitted => submitted;
  bool get isPending => !submitted && !isOverdue;
  bool get isLateSubmission =>
      submittedAt != null && submittedAt!.isAfter(dueDate);

  String get statusLabel {
    if (submitted) {
      return isLateSubmission ? 'Nộp trễ' : 'Đã nộp';
    }
    if (isOverdue) {
      return 'Quá hạn';
    }
    return 'Chưa nộp';
  }
}
