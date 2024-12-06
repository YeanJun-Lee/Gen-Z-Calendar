import 'package:flutter/material.dart';
import 'package:gen_z_calendar/daywidget.dart';
import 'package:gen_z_calendar/event.dart';
import 'package:gen_z_calendar/personal_schedule_add.dart';
import 'package:intl/intl.dart';

class BottomSection extends StatefulWidget {
  final DateTime? selectedDate;
  final List<dynamic> events;

  const BottomSection({super.key, required this.selectedDate, required this.events});

  @override
  State<BottomSection> createState() => _BottomSectionState();
}

class _BottomSectionState extends State<BottomSection> {
  final List<Map<String, dynamic>> mySchedules = [
    {'date': DateTime(2024, 12, 25), 'title': '크리스마스 준비'},
    {'date': DateTime(2024, 12, 31), 'title': '연말 모임'},
  ];

  @override
  Widget build(BuildContext context) {
    final DateTime? selectedDate = widget.selectedDate;

    // 선택된 날짜에 해당하는 일정 필터링
    final myFilteredSchedules = selectedDate != null
        ? mySchedules
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
          Expanded(
            child: Daywidget(
              selectedDate: widget.selectedDate ?? DateTime.now(),
            ),
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
                            // 새로운 이벤트 추가
                            mySchedules.add({
                              'date': DateTime.parse(newEvent.date),
                              'title': newEvent.title,
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
