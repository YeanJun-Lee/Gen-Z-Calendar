import 'package:flutter/material.dart';
import 'add_schedule_screen.dart'; // 일정 추가 화면 import
import 'notification_screen.dart'; // 알림 화면 import
import 'mypage_screen.dart'; // 마이페이지 화면 import
import 'group_creation_screen.dart'; // 그룹 관리 화면 import
import 'friend_management_screen.dart'; // 친구 관리 화면 import

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '2025 3월',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Color(0xFF1D3557)), // 진한 파란색
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Drawer 열기
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Color(0xFF1D3557)), // 진한 파란색
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              ); // 알림 화면으로 이동
            },
          ),
          IconButton(
            icon: CircleAvatar(
              radius: 15,
              backgroundColor: Color(0xFF1D3557), // 진한 파란색
              child: Icon(Icons.person, size: 20.0, color: Colors.white),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyPageScreen()),
              ); // 마이페이지 화면으로 이동
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white, // Drawer의 전체 배경을 흰색으로 설정
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Drawer 상단 헤더
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFF1D3557), // 진한 파란색 배경
                ),
                child: Text(
                  'Gen-Z Calendar\nmenu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // 메뉴 항목들
              ListTile(
                leading: Icon(Icons.group, color: Colors.black),
                title: Text('공유 그룹 관리'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GroupCreationScreen()),
                  ); // 공유 그룹 관리 화면으로 이동
                },
              ),
              ListTile(
                leading: Icon(Icons.star, color: Colors.black),
                title: Text('공유 일정 생성'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddScheduleScreen()),
                  ); // 일정 추가 화면으로 이동
                },
              ),
              ListTile(
                leading: Icon(Icons.person_add, color: Colors.black),
                title: Text('친구 관리'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FriendManagementScreen()),
                  ); // 친구 관리 화면으로 이동
                },
              ),
              ListTile(
                leading: Icon(Icons.calendar_today, color: Colors.black),
                title: Text('캘린더 확인'),
                onTap: () {
                  // 캘린더 확인 화면 이동 로직
                },
              ),
              ListTile(
                leading: Icon(Icons.sync, color: Colors.black),
                title: Text('캘린더 연동'),
                trailing: Icon(Icons.account_circle,
                    color: Colors.blue), // Google 아이콘
                onTap: () {
                  // 캘린더 연동 화면 이동 로직
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white, // 전체 화면 배경을 흰색으로 설정
      body: Stack(
        children: [
          Column(
            children: [
              // 캘린더 부분
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  color: Colors.white, // 캘린더 배경을 흰색으로 설정
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7, // 한 줄에 7개의 날짜
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                    ),
                    itemCount: 31, // 예시: 3월의 날짜 개수
                    itemBuilder: (context, index) {
                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey[300]!), // 회색 테두리
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          '${index + 1}', // 날짜 표시
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // 하단 일정 상세 정보 부분
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // 하단 배경을 흰색으로 설정
                    border: Border(
                      top: BorderSide(color: Colors.grey[300]!), // 상단 회색 테두리
                    ),
                  ),
                  child: Column(
                    children: [
                      // 상단 드래그 핸들
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        width: 50,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          children: [
                            Row(
                              children: [
                                Text(
                                  '내 일정',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 16.0),
                                Text('그룹 일정'),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Center(
                                      child: Text('일정 1'),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.0),
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Center(
                                      child: Text('일정 2'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 일정 추가 버튼
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddScheduleScreen()),
                ); // 일정 추가 화면으로 이동
              },
              child: Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black, // 외곽선 색상
                    width: 2.0, // 외곽선 두께
                  ),
                  color: Colors.white, // 내부 배경색을 흰색으로 설정
                ),
                child: Center(
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
