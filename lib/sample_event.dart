
import 'package:cell_calendar/cell_calendar.dart';
import 'package:flutter/material.dart';
import 'package:gen_z_calendar/event.dart';

Future<List<CalendarEvent>> sampleEvents(List<Event> events) async {
  const eventTextStyle = TextStyle(fontSize: 10, color: Colors.white);

  return events.map((event) {
    try {
      final DateTime start = DateTime.parse(event.date).add(
        Duration(
          hours: int.parse(event.startTime.split(':')[0]),
          minutes: int.parse(event.startTime.split(':')[1].split(' ')[0]),
        ),
      );

      return CalendarEvent(
        eventName: event.title,
        eventDate: start, // 캘린더는 단일 날짜만 필요
        eventBackgroundColor: Colors.indigoAccent,
        eventTextStyle: eventTextStyle,
      );
    } catch (e) {
      print('Event 데이터 변환 실패: $e');
      return CalendarEvent(
        eventName: 'Invalid Event',
        eventDate: DateTime.now(), // 기본값 설정
        eventBackgroundColor: Colors.redAccent,
        eventTextStyle: eventTextStyle,
      );
    }
  }).toList();
}
