import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendManagementScreen extends StatefulWidget {
  final String userId; // 현재 로그인된 사용자 ID

  const FriendManagementScreen({required this.userId, super.key});

  @override
  _FriendManagementScreenState createState() => _FriendManagementScreenState();
}

class _FriendManagementScreenState extends State<FriendManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> friends = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _fetchFriends(); // 초기화 시 친구 목록 가져오기
  }

  // Firestore에서 친구 목록 가져오기
  Future<void> _fetchFriends() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(widget.userId)
          .collection('friends')
          .get();

      setState(() {
        friends = snapshot.docs
            .map((doc) => {"id": doc.id, ...doc.data()})
            .toList();
      });
    } catch (e) {
      print('친구 목록 가져오기 오류: $e');
    }
  }

  // Firestore에서 친구 삭제
  Future<void> _deleteFriend(String friendId) async {
    try {
      await _firestore
          .collection('users')
          .doc(widget.userId)
          .collection('friends')
          .doc(friendId)
          .delete();

      setState(() {
        friends.removeWhere((friend) => friend['id'] == friendId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('친구가 삭제되었습니다.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('친구 삭제 오류: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('친구 삭제 중 오류가 발생했습니다.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Firestore에서 사용자 확인 후 친구 추가
  Future<void> _addFriend(String email) async {
    try {
      // Firestore의 `users` 컬렉션에서 해당 이메일을 가진 사용자 찾기
      final userSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userSnapshot.docs.isEmpty) {
        // 이메일이 등록되지 않은 경우
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('해당 이메일로 등록된 사용자가 없습니다.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final userDoc = userSnapshot.docs.first;
      final friendData = {
        "name": userDoc.data()['name'] ?? "알 수 없음",
        "email": userDoc.data()['email'],
        "image": userDoc.data()['image'] ?? "", // 비어 있을 경우 빈 문자열
      };

      // 현재 사용자의 friends 컬렉션에 친구 추가
      await _firestore
          .collection('users')
          .doc(widget.userId)
          .collection('friends')
          .doc(userDoc.id) // 친구의 userId를 문서 ID로 사용
          .set(friendData);

      setState(() {
        friends.add({"id": userDoc.id, ...friendData});
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('친구가 추가되었습니다.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('친구 추가 오류: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('친구 추가 중 오류가 발생했습니다.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // 친구 추가 다이얼로그 표시
  void _showAddFriendDialog() {
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('친구 추가'),
          content: TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: '이메일'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
              },
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                final email = emailController.text.trim();

                if (email.isNotEmpty) {
                  _addFriend(email);
                  Navigator.pop(context); // 다이얼로그 닫기
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0.0,
        title: const Text(
          '친구 관리',
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
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 친구 수 표시
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '친구 ${friends.length}명',
              style: const TextStyle(
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
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: '검색',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          // 친구 목록
          Expanded(
  child: Theme(
    data: Theme.of(context).copyWith(
      popupMenuTheme: const PopupMenuThemeData(
        color: Colors.white, // 팝업 메뉴 배경색
        textStyle: TextStyle(color: Colors.black), // 텍스트 색상
      ),
    ),
    child: ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: friends.length, // friends 리스트의 길이 사용
      separatorBuilder: (context, index) => Divider(color: Colors.grey[300]),
      itemBuilder: (context, index) {
        final friend = friends[index];
        
        // 데이터 null 처리 및 기본값 설정
        final String name = friend['name'] ?? '이름 없음';
        final String email = friend['email'] ?? '이메일 없음';
        final String image = friend['image'] ?? ''; // null일 경우 빈 문자열
        
        return ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[300],
            child: image.isNotEmpty
                ? Image.asset(image) // `image` 값이 있으면 Asset 이미지 사용
                : const Icon(Icons.person, color: Colors.white), // 기본 아이콘 사용
          ),
          title: Text(
            name,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            email,
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onSelected: (value) {
              if (value == 'delete') {
                _deleteFriend(friend['id']); // 친구 삭제 함수 호출
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
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

          // 친구 추가 버튼
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _showAddFriendDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D3557),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                '친구 추가',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
