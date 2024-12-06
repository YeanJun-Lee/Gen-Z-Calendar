class Event {
  final String title;
  final String startTime;
  final String endTime;
  final String description;
  final String date;

  Event({
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.date,
  });

  get color => null;

  get dateTimeRange => null;

  get eventData => null;

  // JSON 변환 추가 (optional)
  Map<String, dynamic> toJson() => {
        'title': title,
        'startTime': startTime,
        'endTime': endTime,
        'description': description,
        'date': date,
      };
}
