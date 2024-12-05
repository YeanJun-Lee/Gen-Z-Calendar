import 'package:flutter/material.dart';

class Event {
  final String title;
  final Color color;
  final DateTime dateTime;
  final bool allDay;
  final bool eventType;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;

  Event(
    this.title, 
    this.color,
    this.dateTime, 
    this.allDay, 
    this.eventType, 
    this.startTime,
    this.endTime,
  );
  
}