import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'group_creation_screen.dart';

class GroupManagementScreen extends StatefulWidget {
  const GroupManagementScreen({super.key});

  @override
  _GroupManagementScreenState createState() => _GroupManagementScreenState();
}

class _GroupManagementScreenState extends State<GroupManagementScreen> {
  final List<Map<String, String>> _groups = [];
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredGroups = [];

  User? _user; // 로그인된 사용자 정보
  late String _userId; // Firebase 사용자 ID

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  // Firebase에서 로그인된 사용자 정보를 가져오기
  Future<void> _initializeUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
        _userId = user.uid;
      });
      _loadGroups(); // 로그인된 사용자에 해당하는 그룹 불러오기
    }
  }

  // 그룹 추가 함수
  void _addGroup(String groupName, String groupDescription) {
    setState(() {
      final newGroup = {'name': groupName, 'description': groupDescription};
      _groups.add(newGroup);
      _filteredGroups = _groups;
    });
    _saveGroups(); // 그룹 저장
  }

  // 그룹 삭제 함수
  void _deleteGroup(int index) {
    setState(() {
      _groups.removeAt(index);
      _filteredGroups = _groups;
    });
    _saveGroups(); // 그룹 저장
  }

  // 그룹 저장 함수 (Firestore에 저장)
  Future<void> _saveGroups() async {
    if (_user != null) {
      final groupsData = _groups.map((group) => group).toList();
      await FirebaseFirestore.instance.collection('users').doc(_userId).set(
          {'groups': groupsData},
          SetOptions(merge: true)); // Firestore에 그룹 정보 저장
    }
  }

  // 그룹 로드 함수 (Firestore에서 로드)
  Future<void> _loadGroups() async {
    if (_user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .get();

      if (snapshot.exists) {
        final userGroups = snapshot.data()?['groups'] as List<dynamic>? ?? [];
        setState(() {
          _groups.clear();
          _filteredGroups.clear();
          for (var group in userGroups) {
            _groups.add(Map<String, String>.from(group));
          }
          _filteredGroups = _groups;
        });
      }
    }
  }

  // 검색 필터링 함수
  void _filterGroups(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredGroups = _groups;
      } else {
        _filteredGroups = _groups
            .where((group) =>
                group['name']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('그룹 관리'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signInAnonymously(); // 예시: 익명 로그인
              _initializeUser(); // 사용자 정보 초기화
            },
            child: const Text('로그인'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0.0,
        title: const Text(
          '그룹 관리',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // 이전 화면으로 이동
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 그룹 수 표시
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '그룹 ${_filteredGroups.length}개',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          // 검색창 + 그룹 생성 버튼
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                // 검색창
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterGroups,
                    decoration: InputDecoration(
                      hintText: '그룹 검색',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                // 그룹 생성 버튼
                ElevatedButton(
                  onPressed: () async {
                    // 그룹 생성 화면으로 이동 후 결과 받기
                    final result = await Navigator.push<Map<String, String>>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GroupCreationScreen(),
                      ),
                    );

                    // 결과가 있다면 그룹 추가
                    if (result != null) {
                      _addGroup(result['name']!, result['description']!);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D3557),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child:
                      const Text('생성', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          // 그룹 목록
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _filteredGroups.length,
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.grey[300]),
              itemBuilder: (context, index) {
                final group = _filteredGroups[index];
                return ListTile(
                  title: Text(
                    group['name']!,
                    style: const TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(group['description']!,
                      style: const TextStyle(color: Colors.grey)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.grey),
                    onPressed: () {
                      _deleteGroup(index); // 그룹 삭제
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
