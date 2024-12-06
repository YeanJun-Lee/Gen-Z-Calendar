import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cell_calendar/cell_calendar.dart';
import 'package:intl/intl.dart';

import 'add_schedule_screen.dart';
import 'bottom_section.dart';
import 'friend_management_screen.dart';
import 'group_managment_screen.dart';
import 'mypage_screen.dart';
import 'notification_screen.dart';

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
              Scaffold.of(context).openDrawer(); // Drawer 열기
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
                    fontWeight: FontWeight.bold),
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
                final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
                if (userId.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FriendManagementScreen(userId: userId),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('로그인이 필요합니다.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
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
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('schedules')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final events = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return CalendarEvent(
                    eventName: data['title'] ?? 'No Title',
                    eventDate: (data['date'] is Timestamp)
                        ? data['date'].toDate()
                        : DateTime.parse(data['date']),
                    eventBackgroundColor: Colors.blue, // 기본 배경색
                    eventTextStyle:
                        const TextStyle(fontSize: 10, color: Colors.white),
                  );
                }).toList();

                return CellCalendar(
                  cellCalendarPageController: cellCalendarPageController,
                  events: events,
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
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () {
                              cellCalendarPageController.animateToDate(
                                DateTime.now(),
                                curve: Curves.linear,
                                duration: const Duration(milliseconds: 300),
                              );
                            },
                          )
                        ],
                      ),
                    );
                  },
                  onCellTapped: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                setState(() {
                  _bottomSheetHeight -= details.delta.dy;
                  _bottomSheetHeight = _bottomSheetHeight.clamp(
                    212.0,
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
                child: BottomSection(
                  selectedDate: _selectedDate,
                  events: [],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
