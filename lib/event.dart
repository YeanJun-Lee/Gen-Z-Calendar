import 'package:flutter/material.dart';

class Event {
  final String title; // 일정 제목
  final String? description; // 일정 설명 (선택 사항)
  final DateTimeRange? dateTimeRange; // 일정의 시작/종료 시간
  final Color color; // 일정 표시 색상 (기본값 제공)

  Event({
    required this.title,
    required this.dateTimeRange,
    this.description,
    this.color = Colors.blue, // 기본 색상 설정
  });
}