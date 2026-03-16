import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../assignment.dart';
import '../utils/assignment_ui.dart';
import '../utils/formatters.dart';

class SubmissionPage extends StatefulWidget {
  const SubmissionPage({super.key, required this.assignment});

  final Assignment assignment;

  @override
  State<SubmissionPage> createState() => _SubmissionPageState();
}

class _SubmissionPageState extends State<SubmissionPage> {
  List<PlatformFile> _selectedFiles = [];
  bool _isSubmitting = false;

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type:FileType.image,
      allowMultiple: true
    );
    if (result == null) {
      return;
    }

    setState(() {
      _selectedFiles = result.files;
    });
  }

  Future<void> _submit() async {
    if (_selectedFiles.isEmpty) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 900));

    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = false;
      widget.assignment.submitted = true;
      widget.assignment.submittedAt = DateTime.now();
      widget.assignment.submittedFileNames =
          _selectedFiles.map((file) => file.name).toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Đã nộp ${_selectedFiles.length} tệp cho "${widget.assignment.title}".',
        ),
      ),
    );

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final assignment = widget.assignment;
    final colorScheme = Theme.of(context).colorScheme;
    final statusColors = resolveStatusColors(colorScheme, assignment);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nộp bài tập'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColors.container,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  assignment.statusLabel,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: statusColors.content,
                      ),
                ),
              ),
              const Spacer(),
              Text(
                '${assignment.points} điểm',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            assignment.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            assignment.subject,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 18, color: colorScheme.primary),
              const SizedBox(width: 6),
              Text('Hạn nộp: ${formatDateTime(assignment.dueDate)}'),
            ],
          ),
          if (assignment.submitted && assignment.submittedAt != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Icon(Icons.check_circle, size: 18, color: colorScheme.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Đã nộp lúc ${formatDateTime(assignment.submittedAt!)}',
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              assignment.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Tệp nộp bài',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          _buildFileList(context, assignment),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _pickFiles,
            icon: const Icon(Icons.upload_file),
            label: const Text('Chọn nhiều file'),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _selectedFiles.isEmpty || _isSubmitting ? null : _submit,
            child: _isSubmitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(assignment.submitted ? 'Nộp lại' : 'Gửi bài'),
          ),
          const SizedBox(height: 12),
          Text(
            'Lưu ý: Bạn có thể nộp lại trước hạn nếu cần cập nhật.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileList(BuildContext context, Assignment assignment) {
    final hasPicked = _selectedFiles.isNotEmpty;
    final existingFiles = assignment.submittedFileNames;
    final items = <_FileDisplayItem>[];

    if (hasPicked) {
      for (final file in _selectedFiles) {
        items.add(
          _FileDisplayItem(
            name: file.name,
            sizeLabel: formatBytes(file.size),
          ),
        );
      }
    } else {
      for (final name in existingFiles) {
        items.add(_FileDisplayItem(name: name));
      }
    }

    if (items.isEmpty) {
      return _buildFileRow(
        context,
        name: 'Chưa chọn tệp',
        sizeLabel: null,
      );
    }

    final rows = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      rows.add(
        _buildFileRow(
          context,
          name: item.name,
          sizeLabel: item.sizeLabel,
        ),
      );
      if (i != items.length - 1) {
        rows.add(const SizedBox(height: 8));
      }
    }

    return Column(children: rows);
  }

  Widget _buildFileRow(
    BuildContext context, {
    required String name,
    required String? sizeLabel,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Icons.insert_drive_file, color: colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (sizeLabel != null)
            Text(
              sizeLabel,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
        ],
      ),
    );
  }
}

class _FileDisplayItem {
  const _FileDisplayItem({required this.name, this.sizeLabel});

  final String name;
  final String? sizeLabel;
}
