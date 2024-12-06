import 'package:flutter/material.dart';
import 'package:gen_z_calendar/daywidget.dart';
import 'package:gen_z_calendar/personal_schedule_add.dart';
import 'package:intl/intl.dart';
import 'package:kalender/kalender.dart';
import 'package:gen_z_calendar/add_schedule_screen.dart';

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

    final myFilteredSchedules = selectedDate != null
        ? mySchedules
            .where((schedule) =>
                DateFormat('yyyy-MM-dd').format(schedule['date']) ==
                DateFormat('yyyy-MM-dd').format(selectedDate))
            .toList()
        : [];

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
          // Expanded(
          //   child: ListView(
          //     children: [
          //       const Text(
          //         '내 일정',
          //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          //       ),
          //       const SizedBox(height: 8),
          //       ...myFilteredSchedules.map((schedule) {
          //         return ListTile(
          //           leading: const Icon(Icons.person),
          //           title: Text(schedule['title']),
          //         );
          //       }).toList(),
          //       if (myFilteredSchedules.isEmpty) const Text('내 일정이 없습니다.'),
          //       const SizedBox(height: 16),
          //       const Text(
          //         '공유 일정',
          //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          //       ),
          //       const SizedBox(height: 8),
          //       ...sharedFilteredSchedules.map((schedule) {
          //         return ListTile(
          //           leading: const Icon(Icons.group),
          //           title: Text(schedule['title']),
          //         );
          //       }).toList(),
          //       if (sharedFilteredSchedules.isEmpty) const Text('공유 일정이 없습니다.'),
          //     ],
          //   ),
          // ),
          Expanded(
            child: Daywidget(selectedDate: widget.selectedDate ?? DateTime.now(),),
          ),
          // 일정 추가 버튼
          Align(
            alignment: Alignment.bottomRight, // 오른쪽 아래로 배치
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: PersonalScheduleAdd(
                        onAddEvent: (newEvent) {
                          setState(() {
                            // 이벤트 데이터를 리스트에 추가
                            mySchedules.add({
                              'date': newEvent.dateTimeRange.start,
                              'title': newEvent.eventData?.title ?? 'New Event',
                            });
                          });
                        },
                      ),
                    );
                  },
                );
              },
              child: Container(
                width: 40.0,
                height: 40.0,
                margin: const EdgeInsets.only(bottom: 16), // 버튼과 위 요소 사이 간격
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black, // 외곽선 색상
                    width: 2.0, // 외곽선 두께
                  ),
                  color: Colors.white, // 내부 배경색을 흰색으로 설정
                ),
                child: const Center(
                  child: Icon(Icons.add,
                      size: 30.0, color: Colors.black), // 아이콘 크기 및 색상
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
