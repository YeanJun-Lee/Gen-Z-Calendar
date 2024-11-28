import 'package:flutter/material.dart';

class AddScheduleScreen extends StatefulWidget {
  @override
  _AddScheduleScreenState createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  void _selectTime(BuildContext context, bool isStartTime) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          _startTime = pickedTime;
        } else {
          _endTime = pickedTime;
        }
      });
    }
  }

  void _showSuccessDialog(BuildContext context) {
    // 알림창 표시
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('일정 추가'),
          content: Text('일정이 추가되었습니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 팝업 닫기
                Navigator.pop(context); // 일정 추가 화면 닫고 홈 화면으로 이동
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '일정 추가',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // 이전 화면으로 이동
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0, // 그림자 제거
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 제목 입력
              TextField(
                decoration: InputDecoration(
                  labelText: '제목',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),

              // 시간 및 날짜 설정
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: '시작 시간',
                        prefixIcon: Icon(Icons.access_time),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      controller: TextEditingController(
                        text: _startTime != null
                            ? _startTime!.format(context)
                            : '',
                      ),
                      onTap: () => _selectTime(context, true),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Icon(Icons.arrow_forward, color: Colors.grey),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: '종료 시간',
                        prefixIcon: Icon(Icons.access_time),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      controller: TextEditingController(
                        text: _endTime != null ? _endTime!.format(context) : '',
                      ),
                      onTap: () => _selectTime(context, false),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),

              // 참가자 추가
              TextField(
                decoration: InputDecoration(
                  labelText: '참가자',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),

              // 회의 도구 입력
              TextField(
                decoration: InputDecoration(
                  labelText: '회의 도구',
                  prefixIcon: Icon(Icons.videocam),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),

              // 위치 입력
              TextField(
                decoration: InputDecoration(
                  labelText: '위치',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),

              // 설명 입력
              TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: '설명',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 24.0),

              // 완료 버튼
              ElevatedButton(
                onPressed: () {
                  _showSuccessDialog(context); // 팝업창 띄우기
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1D3557),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text('완료', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
