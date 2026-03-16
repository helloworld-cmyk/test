import 'package:flutter/material.dart';
import '../assignment.dart';
import '../widgets/assignment_list.dart';
import 'submission_page.dart';

class AssignmentListPage extends StatefulWidget {
  const AssignmentListPage({super.key});

  @override
  State<AssignmentListPage> createState() => _AssignmentListPageState();
}

class _AssignmentListPageState extends State<AssignmentListPage> {
  late final List<Assignment> _assignments;

  @override
  void initState() {
    super.initState();
    _assignments = [
      Assignment(
        id: 'hw-01',
        title: 'Bài tập 1: UI đăng nhập',
        subject: 'Lập trình di động',
        dueDate: DateTime(2026, 3, 14, 23, 59),
        points: 10,
        description:
            'Thiết kế giao diện đăng nhập gồm email, mật khẩu, nút đăng nhập và liên kết quên mật khẩu.',
      ),
      Assignment(
        id: 'hw-02',
        title: 'Bài tập 2: Danh sách sản phẩm',
        subject: 'UI/UX',
        dueDate: DateTime(2026, 3, 20, 23, 59),
        points: 15,
        description:
            'Tạo màn hình danh sách sản phẩm có ảnh, giá, đánh giá sao và nút thêm vào giỏ.',
        submitted: true,
        submittedAt: DateTime(2026, 3, 15, 21, 30),
        submittedFileNames: ['bai-tap-2-ux.pdf', 'wireframe.png'],
      ),
      Assignment(
        id: 'hw-03',
        title: 'Bài tập 3: Quản lý công việc',
        subject: 'Flutter nâng cao',
        dueDate: DateTime(2026, 3, 28, 17, 0),
        points: 20,
        description:
            'Xây dựng màn hình quản lý công việc với trạng thái và bộ lọc.',
      ),
    ];
  }

  Future<void> _openSubmission(Assignment assignment) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => SubmissionPage(assignment: assignment),
      ),
    );

    if (changed == true && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bài tập'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Tất cả'),
              Tab(text: 'Chưa nộp'),
              Tab(text: 'Đã nộp'),
              Tab(text: 'Quá hạn'),
              Tab(text: 'Nộp trễ'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AssignmentList(
              assignments: _assignments,
              onOpenSubmission: _openSubmission,
            ),
            AssignmentList(
              assignments:
                  _assignments.where((item) => item.isPending).toList(),
              onOpenSubmission: _openSubmission,
              emptyMessage: 'Không có bài nào chưa nộp.',
            ),
            AssignmentList(
              assignments:
                  _assignments.where((item) => item.isSubmitted).toList(),
              onOpenSubmission: _openSubmission,
              emptyMessage: 'Chưa có bài đã nộp.',
            ),
            AssignmentList(
              assignments:
                  _assignments.where((item) => item.isOverdue).toList(),
              onOpenSubmission: _openSubmission,
              emptyMessage: 'Không có bài quá hạn.',
            ),
            AssignmentList(
              assignments:
                  _assignments.where((item) => item.isLateSubmission).toList(),
              onOpenSubmission: _openSubmission,
              emptyMessage: 'Chưa có bài nộp trễ.',
            ),
          ],
        ),
      ),
    );
  }
}
