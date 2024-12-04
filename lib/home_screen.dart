import 'package:flutter/material.dart';
import 'package:cell_calendar/cell_calendar.dart';
import 'package:gen_z_calendar/add_schedule_screen.dart';
import 'package:gen_z_calendar/bottom_section.dart';
import 'package:gen_z_calendar/friend_management_screen.dart';
import 'package:gen_z_calendar/group_creation_screen.dart';
import 'package:gen_z_calendar/mypage_screen.dart';
import 'package:gen_z_calendar/notification_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final cellCalendarPageController = CellCalendarPageController();

  // 초기 BottomSection 높이
  double _bottomSheetHeight = 200.0;

  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'Gen Z Calendar',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF1D3557)), // 진한 파란색
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Drawer 열기
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications,
                color: Color(0xFF1D3557)), // 진한 파란색
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationScreen()),
              ); // 알림 화면으로 이동
            },
          ),
          IconButton(
            icon: const CircleAvatar(
              radius: 15,
              backgroundColor: Color(0xFF1D3557), // 진한 파란색
              child: Icon(Icons.person, size: 20.0, color: Colors.white),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyPageScreen()),
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
              const DrawerHeader(
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
              ListTile(
                leading: const Icon(Icons.group, color: Colors.black),
                title: const Text('공유 그룹 관리'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GroupCreationScreen()),
                  ); // 공유 그룹 관리 화면으로 이동
                },
              ),
              ListTile(
                leading: const Icon(Icons.star, color: Colors.black),
                title: const Text('공유 일정 생성'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddScheduleScreen()),
                  ); // 일정 추가 화면으로 이동
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_add, color: Colors.black),
                title: const Text('친구 관리'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FriendManagementScreen()),
                  ); // 친구 관리 화면으로 이동
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today, color: Colors.black),
                title: const Text('캘린더 확인'),
                onTap: () {
                  // 캘린더 확인 화면 이동 로직
                },
              ),
              ListTile(
                leading: const Icon(Icons.sync, color: Colors.black),
                title: const Text('캘린더 연동'),
                trailing: const Icon(Icons.account_circle,
                    color: Colors.blue), // Google 아이콘
                onTap: () {
                  // 캘린더 연동 화면 이동 로직
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 상단 캘린더
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 700, // 캘린더 고정 높이
            child: CellCalendar(
              cellCalendarPageController: cellCalendarPageController,
              daysOfTheWeekBuilder: (dayIndex) {
                const days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
                return Center(
                  child: Text(
                    days[dayIndex],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
              monthYearLabelBuilder: (datetime) {
                final year = datetime?.year.toString();
                final month = DateFormat.MMMM().format(datetime!);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Text(
                        "$month $year",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
              onCellTapped: (date) {
                final tappedDate = date;
                setState(() {
                  _selectedDate = tappedDate;
                });
              },
            ),
          ),
          // 드래그 가능한 BottomSection
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                setState(() {
                  _bottomSheetHeight -= details.delta.dy; // 드래그에 따라 높이 변경
                  if (_bottomSheetHeight < 200)
                    _bottomSheetHeight = 150; // 최소 높이
                  if (_bottomSheetHeight >
                      MediaQuery.of(context).size.height * 0.8) {
                    _bottomSheetHeight =
                        MediaQuery.of(context).size.height * 0.8; // 최대 높이
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                height: _bottomSheetHeight,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      width: 50,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          _selectedDate != null
                              ? "선택된 날짜: ${DateFormat('MM-dd').format(_selectedDate!)}"
                              : "날짜를 선택해주세요",
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}