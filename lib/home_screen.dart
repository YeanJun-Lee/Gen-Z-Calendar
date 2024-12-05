import 'package:flutter/material.dart';
import 'package:cell_calendar/cell_calendar.dart';
import 'package:intl/intl.dart';

import 'add_schedule_screen.dart';
import 'notification_screen.dart';
import 'mypage_screen.dart';
import 'group_management_screen.dart';
import 'friend_management_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final cellCalendarPageController = CellCalendarPageController();
  double _bottomSheetHeight = 200.0; // 초기 BottomSection 높이
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
            icon: const Icon(Icons.menu, color: Color(0xFF1D3557)),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Color(0xFF1D3557)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationScreen()),
              );
            },
          ),
          IconButton(
            icon: const CircleAvatar(
              radius: 15,
              backgroundColor: Color(0xFF1D3557),
              child: Icon(Icons.person, size: 20.0, color: Colors.white),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyPageScreen()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF1D3557)),
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
                      builder: (context) => const GroupManagementScreen()),
                );
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
                );
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
                );
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // 상단 캘린더
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 700,
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
                setState(() {
                  _selectedDate = date;
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
                  _bottomSheetHeight -= details.delta.dy;
                  _bottomSheetHeight = _bottomSheetHeight.clamp(
                    150.0,
                    MediaQuery.of(context).size.height * 0.8,
                  );
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
          // 오른쪽 아래의 추가 버튼
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              backgroundColor: const Color(0xFF1D3557),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddScheduleScreen()),
                );
              },
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
