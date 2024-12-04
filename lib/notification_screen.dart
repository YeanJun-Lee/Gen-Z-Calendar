import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // 더미 데이터
  final List<Map<String, String>> invitations = [
    {'type': 'friend', 'content': 'xxx님으로부터 친구 요청이 왔습니다.'},
    {'type': 'group', 'content': 'xxx님으로부터 그룹 초대 요청이 왔습니다.'},
  ];

  final List<Map<String, String>> scheduleNotifications = [
    {'time': '10:00 AM', 'content': '회의 일정 알림: 팀 회의가 시작됩니다.'},
    {'time': '3:00 PM', 'content': '일정 알림: 프로젝트 마감일이 다가옵니다.'},
  ];

  // 현재 선택된 탭 (초대 수락 및 확인: 0, 일정 알림: 1)
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0, // 제목 왼쪽 정렬
        title: const Text(
          '알림',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.0, // 제목 글씨 크기 조정
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // 이전 화면으로 이동
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0, // 그림자 제거
      ),
      backgroundColor: Colors.white, // 전체 화면 배경을 흰색으로 설정
      body: Column(
        children: [
          // 탭 메뉴 (초대 수락 및 확인 / 일정 알림)
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!), // 하단 테두리
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedTab = 0; // 초대 수락 및 확인 선택
                    });
                  },
                  child: Text(
                    '초대 수락 및 확인',
                    style: TextStyle(
                      color: selectedTab == 0 ? Colors.blue : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0, // 탭 메뉴 글씨 크기 조정
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedTab = 1; // 일정 알림 선택
                    });
                  },
                  child: Text(
                    '일정 알림',
                    style: TextStyle(
                      color: selectedTab == 1 ? Colors.blue : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0, // 탭 메뉴 글씨 크기 조정
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 선택된 탭에 따라 다른 데이터 표시
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: selectedTab == 0
                  ? invitations.length
                  : scheduleNotifications.length,
              itemBuilder: (context, index) {
                if (selectedTab == 0) {
                  // 초대 수락 및 확인
                  final invitation = invitations[index];
                  return ListTile(
                    leading: Icon(
                      invitation['type'] == 'friend'
                          ? Icons.person
                          : Icons.group,
                      color: invitation['type'] == 'friend'
                          ? Colors.blue
                          : Colors.green,
                    ),
                    title: Text(
                      invitation['content']!,
                      style: const TextStyle(fontSize: 14.0), // 목록 글씨 크기 조정
                    ),
                  );
                } else {
                  // 일정 알림
                  final notification = scheduleNotifications[index];
                  return ListTile(
                    leading: const Icon(Icons.notifications, color: Colors.orange),
                    title: Text(
                      notification['content']!,
                      style: const TextStyle(fontSize: 14.0), // 목록 글씨 크기 조정
                    ),
                    subtitle: Text(
                      notification['time']!,
                      style: const TextStyle(
                          fontSize: 12.0, color: Colors.grey), // 부제목 크기 조정
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
