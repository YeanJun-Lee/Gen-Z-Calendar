import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PersonalScheduleAdd extends StatefulWidget {
  final Function(dynamic) onAddEvent; // 매개변수 추가
  const PersonalScheduleAdd({Key? key, required this.onAddEvent})
      : super(key: key);

  @override
  _PersonalScheduleAddState createState() => _PersonalScheduleAddState();
}

class _PersonalScheduleAddState extends State<PersonalScheduleAdd> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _saveSchedule() async {
    if (_titleController.text.isEmpty ||
        _selectedDate == null ||
        _startTime == null ||
        _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 필드를 올바르게 입력해주세요.')),
      );
      return;
    }

    try {
      final scheduleData = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'date': DateFormat('yyyy-MM-dd').format(_selectedDate!),
        'startTime': _startTime!.format(context),
        'endTime': _endTime!.format(context),
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('schedules').add(scheduleData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('일정이 성공적으로 저장되었습니다.')),
      );

      Navigator.pop(context);
    } catch (e) {
      print('Firestore 저장 오류: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('일정 저장 중 오류가 발생했습니다. 다시 시도해주세요.')),
      );
    }
  }

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: '제목',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
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
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _selectedDate == null
                        ? '날짜를 선택하세요'
                        : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            _startTime = pickedTime;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: '시작 시간',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _startTime == null
                              ? '시작 시간을 선택하세요'
                              : _startTime!.format(context),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            _endTime = pickedTime;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: '종료 시간',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _endTime == null
                              ? '종료 시간을 선택하세요'
                              : _endTime!.format(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: '설명',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveSchedule,
                child: const Text('일정 저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
