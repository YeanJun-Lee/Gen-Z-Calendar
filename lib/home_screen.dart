import 'package:flutter/material.dart';
import 'package:gen_z_calendar/cell_calendar/cell_calendar.dart';
import 'package:gen_z_calendar/sample_event.dart';
import 'package:intl/intl.dart';
import 'add_schedule_screen.dart'; // 일정 추가 화면 import
import 'notification_screen.dart'; // 알림 화면 import
import 'mypage_screen.dart'; // 마이페이지 화면 import
import 'group_creation_screen.dart'; // 그룹 관리 화면 import
import 'friend_management_screen.dart'; // 친구 관리 화면 import

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final events = sampleEvents();
    final cellCalendarPageController = CellCalendarPageController();

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
            icon: const Icon(Icons.notifications, color: Color(0xFF1D3557)), // 진한 파란색
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationScreen()),
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
              // Drawer 상단 헤더
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

              // 메뉴 항목들
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
            body: CellCalendar(
        cellCalendarPageController: cellCalendarPageController,
        events: events,
        daysOfTheWeekBuilder: (dayIndex) {
          final labels = ["S", "M", "T", "W", "T", "F", "S"];
          return Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              labels[dayIndex],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          );
        },
        monthYearLabelBuilder: (datetime) {
          final year = datetime!.year.toString();
          final month = datetime.month.monthName;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Text(
                  "$month  $year",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
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
          final eventsOnTheDate = events.where((event) {
            final eventDate = event.eventDate;
            return eventDate.year == date.year &&
                eventDate.month == date.month &&
                eventDate.day == date.day;
          }).toList();
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text("${date.month.monthName} ${date.day}"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: eventsOnTheDate
                          .map(
                            (event) => Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(4),
                              margin: const EdgeInsets.only(bottom: 12),
                              color: event.eventBackgroundColor,
                              child: Text(
                                event.eventName,
                                style: event.eventTextStyle,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ));
        },
        onPageChanged: (firstDate, lastDate) {
          /// Called when the page was changed
          /// Fetch additional events by using the range between [firstDate] and [lastDate] if you want
        },
      ),
    
    );
  }
}