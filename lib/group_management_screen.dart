import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'group_creation_screen.dart';
import 'group_detail_screen.dart';

class GroupManagementScreen extends StatefulWidget {
  const GroupManagementScreen({super.key});

  @override
  _GroupManagementScreenState createState() => _GroupManagementScreenState();
}

class _GroupManagementScreenState extends State<GroupManagementScreen> {
  final List<Map<String, dynamic>> _groups = [];
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredGroups = [];
  List<String> _friends = []; // 친구 목록

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
      await _loadFriends(); // 친구 목록 불러오기
      _loadGroups(); // 로그인된 사용자에 해당하는 그룹 불러오기
    }
  }

  // 친구 목록 불러오기
  Future<void> _loadFriends() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('friends')
          .get();

      setState(() {
        _friends = snapshot.docs.map((doc) => doc.id).toList();
      });
    } catch (e) {
      print('Error loading friends: $e');
    }
  }

  // 그룹 추가 함수
  void _addGroup(String groupName, String groupDescription) {
    setState(() {
      final newGroup = {
        'name': groupName,
        'description': groupDescription,
        'members': [],
      };
      _groups.add(newGroup);
      _filteredGroups = _groups;
    });
    _saveGroups(); // Firestore에 저장
  }

// 그룹 삭제 함수
  Future<void> _deleteGroup(int index) async {
    try {
      final groupId = _groups[index]['id']; // 그룹 ID 가져오기
      // Firestore에서 그룹 삭제
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .delete();

      // 로컬 데이터에서 그룹 삭제
      setState(() {
        _groups.removeAt(index);
        _filteredGroups = _groups;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('그룹이 성공적으로 삭제되었습니다.')),
      );
    } catch (e) {
      print('Error deleting group: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('그룹 삭제 중 오류가 발생했습니다.')),
      );
    }
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
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('groups')
            .where('members', arrayContains: _user!.email)
            .get();

        setState(() {
          _groups.clear();
          _filteredGroups.clear();

          for (var doc in snapshot.docs) {
            final groupData = doc.data();
            _groups.add({
              'id': doc.id,
              'name': groupData['name'],
              'description': groupData['description'],
              'members': List<String>.from(groupData['members']),
            });
          }
          _filteredGroups = _groups;
        });
      } catch (e) {
        print('Error loading groups: $e');
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

  // 멤버 추가 다이얼로그
  void _showAddMemberDialog(int groupIndex) {
    final TextEditingController memberController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('멤버 추가'),
          content: TextField(
            controller: memberController,
            decoration: const InputDecoration(
              hintText: '아이디/이메일 입력',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                final String newMember = memberController.text.trim();

                if (newMember.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('아이디/이메일을 입력하세요.')),
                  );
                } else if (!_friends.contains(newMember)) {
                  // 친구 목록에 없는 사용자일 경우
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('해당 사용자는 친구 목록에 없습니다.')),
                  );
                } else if (_groups[groupIndex]['members'].contains(newMember)) {
                  // 이미 멤버로 추가된 경우
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('이미 그룹에 추가된 사용자입니다.')),
                  );
                } else {
                  // 친구 목록에 있는 사용자만 추가
                  setState(() {
                    _groups[groupIndex]['members'].add(newMember);
                  });
                  _saveGroups();
                  Navigator.pop(context);
                }
              },
              child: const Text('추가'),
            ),
          ],
        );
      },
    );
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
                        builder: (context) => GroupCreationScreen(
                            userId:
                                FirebaseAuth.instance.currentUser?.uid ?? ''),
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
                  onTap: () {
                    // 그룹 상세 정보 화면으로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupDetailScreen(group: group),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.blue),
                        onPressed: () {
                          _showAddMemberDialog(index); // 멤버 추가 다이얼로그 호출
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.grey),
                        onPressed: () {
                          _deleteGroup(index); // 그룹 삭제
                        },
                      ),
                    ],
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
