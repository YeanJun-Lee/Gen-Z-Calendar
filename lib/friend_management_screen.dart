import 'package:flutter/material.dart';

class FriendManagementScreen extends StatefulWidget {
  @override
  _FriendManagementScreenState createState() => _FriendManagementScreenState();
}

class _FriendManagementScreenState extends State<FriendManagementScreen> {
  // 더미 친구 데이터
  List<Map<String, String>> friends = [
    {'name': '친구1', 'email': 'friend1@gmail.com', 'image': 'assets/user1.png'},
    {'name': '친구2', 'email': 'friend2@gmail.com', 'image': 'assets/user2.png'},
    {'name': '친구3', 'email': 'friend3@gmail.com', 'image': 'assets/user3.png'},
    {'name': '친구4', 'email': 'friend4@gmail.com', 'image': 'assets/user4.png'},
  ];

  // 친구 삭제 함수
  void _deleteFriend(int index) {
    setState(() {
      friends.removeAt(index); // 해당 인덱스의 친구 삭제
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // 그림자 제거
        titleSpacing: 0.0, // 제목 위치 왼쪽으로 이동
        title: Text(
          '친구 관리',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.0, // 제목 크기 조정
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // 이전 화면으로 이동
          },
        ),
      ),
      backgroundColor: Colors.white, // 배경 흰색 설정
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 친구 수 표시
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '친구 ${friends.length}명',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          // 검색창
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '검색',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          // 친구 목록
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(
                popupMenuTheme: PopupMenuThemeData(
                  color: Colors.white, // 팝업 메뉴 배경색을 흰색으로 설정
                  textStyle: TextStyle(color: Colors.black), // 텍스트 색상 설정
                ),
              ),
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: friends.length,
                separatorBuilder: (context, index) =>
                    Divider(color: Colors.grey[300]),
                itemBuilder: (context, index) {
                  final friend = friends[index];
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: AssetImage(friend['image']!), // 프로필 이미지
                    ),
                    title: Text(
                      friend['name']!,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(friend['email']!,
                        style: TextStyle(color: Colors.grey)),
                    trailing: PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: Colors.grey),
                      onSelected: (value) {
                        if (value == 'delete') {
                          _deleteFriend(index); // 친구 삭제
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('친구 삭제'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
