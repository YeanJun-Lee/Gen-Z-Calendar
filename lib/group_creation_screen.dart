import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupCreationScreen extends StatefulWidget {
  const GroupCreationScreen({super.key, required String userId});

  @override
  _GroupCreationScreenState createState() => _GroupCreationScreenState();
}

class _GroupCreationScreenState extends State<GroupCreationScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _groupCodeController = TextEditingController();
  final TextEditingController _memberController = TextEditingController();
  final List<String> _members = [];
  final TextEditingController _groupDescriptionController =
      TextEditingController();

  List<String> _friendEmails = []; // 친구 이메일 목록

  @override
  void initState() {
    super.initState();
    _fetchFriends(); // 친구 목록 가져오기

    // 현재 로그인된 사용자 이메일을 기본 멤버로 추가
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !_members.contains(user.email)) {
      _members.add(user.email!);
    }
  }

  // Firestore에서 친구 이메일 목록 가져오기
  Future<void> _fetchFriends() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('friends')
          .get();

      setState(() {
        _friendEmails =
            snapshot.docs.map((doc) => doc['email'] as String).toList();
      });
    } catch (e) {
      print('친구 목록 가져오기 오류: $e');
    }
  }

  // 그룹 생성 함수
  Future<void> _createGroupInFirestore(String groupName, String groupCode,
      String groupDescription, List<String> members) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('사용자가 로그인되어 있지 않습니다.');
      }

      if (!members.contains(user.email)) {
        members.add(user.email!); // 현재 로그인된 사용자를 멤버에 추가
      }

      // 새로운 그룹을 Firestore의 groups 컬렉션에 저장
      final groupRef = FirebaseFirestore.instance.collection('groups').doc();
      await groupRef.set({
        'name': groupName,
        'code': groupCode,
        'description': groupDescription,
        'members': members,
        'createdAt': FieldValue.serverTimestamp(),
        'owner': user.email, // 그룹 생성자
      });

      // 그룹 생성 성공 메시지
      _showGroupCreatedDialog(groupName, groupDescription);
    } catch (e) {
      print('Error creating group: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('그룹 생성 중 오류 발생: $e')),
      );
    }
  }

  // 그룹 생성 성공 다이얼로그
  void _showGroupCreatedDialog(String groupName, String groupDescription) {
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

  // 친구만 멤버로 추가
  void _addMember() {
    final String newMember = _memberController.text.trim();

    if (newMember.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('멤버 이메일을 입력해주세요.')),
      );
      return;
    }

    // 입력된 이메일이 친구 목록에 포함되어 있는지 확인
    if (!_friendEmails.contains(newMember)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('입력한 이메일은 친구 목록에 없습니다.')),
      );
      return;
    }

    // 이미 추가된 멤버인지 확인
    if (_members.contains(newMember)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미 추가된 멤버입니다.')),
      );
      return;
    }

    setState(() {
      _members.add(newMember); // 멤버 추가
      _memberController.clear(); // 입력 필드 초기화
    });
  }

  Widget _buildRow(String label, Widget inputWidget) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            decoration: BoxDecoration(
              color: const Color(0xFF1D3557),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
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
        titleSpacing: 0.0,
        title: const Text(
          '공유 그룹 생성',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
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
                  controller: _groupNameController,
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
                  controller: _groupCodeController,
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
                      icon: const Icon(Icons.add_circle,
                          color: Color(0xFF1D3557)),
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
                  controller: _groupDescriptionController,
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
                onPressed: () {
                  final groupName = _groupNameController.text.trim();
                  final groupCode = _groupCodeController.text.trim();
                  final groupDescription =
                      _groupDescriptionController.text.trim();
                  if (groupName.isNotEmpty &&
                      groupCode.isNotEmpty &&
                      groupDescription.isNotEmpty) {
                    _createGroupInFirestore(
                        groupName, groupCode, groupDescription, _members);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('모든 항목을 입력해주세요.')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D3557),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child:
                    const Text('생성하기', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
