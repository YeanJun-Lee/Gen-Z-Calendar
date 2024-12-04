import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kalender/kalender.dart';

class BottomSection extends StatefulWidget {
  final DateTime? selectedDate;

  const BottomSection({super.key, required this.selectedDate});

  @override
  State<BottomSection> createState() => _BottomSectionState();
}

class _BottomSectionState extends State<BottomSection> {
  final CalendarController controller = CalendarController(
    calendarDateTimeRange: DateTimeRange(
      start: DateTime(DateTime.now().year - 1),
      end: DateTime(DateTime.now().year + 1),
    ),
  );

  // 샘플 개인 일정과 공유 일정 데이터
  final List<Map<String, dynamic>> mySchedules = [
    {'date': DateTime(2024, 12, 25), 'title': '크리스마스 준비'},
    {'date': DateTime(2024, 12, 31), 'title': '연말 모임'},
  ];

  final List<Map<String, dynamic>> sharedSchedules = [
    {'date': DateTime(2024, 12, 25), 'title': '회사 송년회'},
    {'date': DateTime(2024, 12, 30), 'title': '프로젝트 회의'},
  ];

  @override
  Widget build(BuildContext context) {
    final DateTime? selectedDate = widget.selectedDate;

    // 선택된 날짜와 관련된 개인 일정 필터링
    final myFilteredSchedules = selectedDate != null
        ? mySchedules
            .where((schedule) =>
                DateFormat('yyyy-MM-dd').format(schedule['date']) ==
                DateFormat('yyyy-MM-dd').format(selectedDate))
            .toList()
        : [];

    // 선택된 날짜와 관련된 공유 일정 필터링
    final sharedFilteredSchedules = selectedDate != null
        ? sharedSchedules
            .where((schedule) =>
                DateFormat('yyyy-MM-dd').format(schedule['date']) ==
                DateFormat('yyyy-MM-dd').format(selectedDate))
            .toList()
        : [];

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            selectedDate != null
                ? "선택된 날짜: ${DateFormat('yyyy-MM-dd').format(selectedDate)}"
                : "날짜를 선택해주세요",
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                const Text(
                  '내 일정',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...myFilteredSchedules.map((schedule) {
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(schedule['title']),
                  );
                }).toList(),
                if (myFilteredSchedules.isEmpty) const Text('내 일정이 없습니다.'),
                const SizedBox(height: 16),
                const Text(
                  '공유 일정',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...sharedFilteredSchedules.map((schedule) {
                  return ListTile(
                    leading: const Icon(Icons.group),
                    title: Text(schedule['title']),
                  );
                }).toList(),
                if (sharedFilteredSchedules.isEmpty) const Text('공유 일정이 없습니다.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
