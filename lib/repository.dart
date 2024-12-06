class ScheduleRepository {
  final List<Map<String, dynamic>> _localSchedules = []; // 로컬 일정 데이터

  // 서버에서 일정 가져오기 (Mock 데이터)
  Future<List<Map<String, dynamic>>> fetchSchedulesFromServer() async {
    try {
      print('Fetching schedules from server...');
      // 예제 데이터 반환
      return [
        {
          'title': '회의',
          'startTime': '10:00 AM',
          'endTime': '11:00 AM',
          'description': '월간 회의',
        },
        {
          'title': '운동',
          'startTime': '6:00 PM',
          'endTime': '7:00 PM',
          'description': '헬스장에서 운동하기',
        },
      ];
    } catch (e) {
      print('Error fetching schedules: $e');
      throw Exception('Failed to fetch schedules from server.');
    }
  }

  // 로컬 일정 데이터 추가
  Future<void> saveScheduleLocally(Map<String, dynamic> scheduleData) async {
    _localSchedules.add(scheduleData);
    print('Saved locally: ${scheduleData['title']}');
  }

  // 로컬 일정 데이터 가져오기
  Future<List<Map<String, dynamic>>> fetchLocalSchedules() async {
    return _localSchedules; // 저장된 로컬 데이터를 반환
  }
}
