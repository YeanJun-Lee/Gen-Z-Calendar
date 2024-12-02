import 'package:flutter/material.dart';

class GroupCreationScreen extends StatefulWidget {
  const GroupCreationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GroupCreationScreenState createState() => _GroupCreationScreenState();
}

class _GroupCreationScreenState extends State<GroupCreationScreen> {
  final TextEditingController _memberController = TextEditingController();
  final List<String> _members = [];

  // 그룹 생성 함수
  void _showGroupCreatedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: const Text('공유 그룹이 생성되었습니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 팝업 닫기
                Navigator.pop(context); // 이전 화면으로 이동
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _addMember() {
    final String newMember = _memberController.text.trim();
    if (newMember.isNotEmpty) {
      setState(() {
        _members.add(newMember);
        _memberController.clear(); // 입력 필드 초기화
      });
    }
  }

  Widget _buildRow(String label, Widget inputWidget) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            decoration: BoxDecoration(
              color: Color(0xFF1D3557), // 진한 파란색 배경
              borderRadius: BorderRadius.circular(16.0), // 둥근 모서리
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white, // 흰색 텍스트
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(child: inputWidget),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0, // 제목을 왼쪽 정렬
        title: const Text(
          '공유 그룹 생성',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.0, // 글씨 크기 조정
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
      backgroundColor: Colors.white, // 바디 배경색 흰색으로 설정
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 그룹명
              _buildRow(
                '그룹명',
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),

              // 그룹 코드
              _buildRow(
                '그룹 코드',
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),

              // 그룹 멤버
              _buildRow(
                '그룹 멤버',
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _memberController,
                        decoration: InputDecoration(
                          hintText: '아이디/이메일로 추가',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    IconButton(
                      onPressed: _addMember,
                      icon: const Icon(Icons.add_circle, color: Color(0xFF1D3557)),
                    ),
                  ],
                ),
              ),

              // 참여자 목록
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _members
                    .map(
                      (member) => Chip(
                        label: Text(member),
                        backgroundColor: const Color(0xFF1D3557),
                        labelStyle: const TextStyle(color: Colors.white),
                        deleteIconColor: Colors.white,
                        onDeleted: () {
                          setState(() {
                            _members.remove(member);
                          });
                        },
                      ),
                    )
                    .toList(),
              ),

              // 그룹 소개
              _buildRow(
                '그룹 소개',
                TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24.0),

              // 생성하기 버튼
              ElevatedButton(
                onPressed: _showGroupCreatedDialog, // 팝업창 표시
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D3557),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text('생성하기', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
