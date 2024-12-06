import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gen_z_calendar/event.dart';
import 'package:kalender/kalender.dart';

class PersonalScheduleAdd extends StatefulWidget {
  final Function(CalendarEvent<Event>) onAddEvent;

  const PersonalScheduleAdd({Key? key, required this.onAddEvent})
      : super(key: key);

  @override
  _PersonalScheduleAddState createState() => _PersonalScheduleAddState();
}

class _PersonalScheduleAddState extends State<PersonalScheduleAdd> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일정 추가'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목 입력
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '제목',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // 날짜 선택
            GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: '날짜',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  _selectedDate == null
                      ? '날짜를 선택해주세요'
                      : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 시작 시간 & 종료 시간
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          _startTime = picked;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: '시작 시간',
                        prefixIcon: Icon(Icons.access_time),
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        _startTime == null
                            ? '선택되지 않음'
                            : _startTime!.format(context),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          _endTime = picked;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: '종료 시간',
                        prefixIcon: Icon(Icons.access_time),
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        _endTime == null
                            ? '선택되지 않음'
                            : _endTime!.format(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 설명 입력
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: '설명',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty &&
                _selectedDate != null &&
                _startTime != null &&
                _endTime != null) {
              final event = CalendarEvent<Event>(
                dateTimeRange: DateTimeRange(
                  start: DateTime(
                    _selectedDate!.year,
                    _selectedDate!.month,
                    _selectedDate!.day,
                    _startTime!.hour,
                    _startTime!.minute,
                  ),
                  end: DateTime(
                    _selectedDate!.year,
                    _selectedDate!.month,
                    _selectedDate!.day,
                    _endTime!.hour,
                    _endTime!.minute,
                  ),
                ),
                eventData: Event(
                  title: _titleController.text,
                  description: _descriptionController.text, dateTimeRange: null,
                ),
              );
              widget.onAddEvent(event);
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('필수 항목을 모두 입력해주세요.')),
              );
            }
          },
          child: const Text('완료'),
        ),
      ),
    );
  }
}
