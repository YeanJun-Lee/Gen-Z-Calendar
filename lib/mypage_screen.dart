import 'package:flutter/material.dart';
import 'login_screen.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '내 정보',
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
        backgroundColor: Colors.white,
        elevation: 0, // 그림자 제거
      ),
      backgroundColor: Colors.white, // 바디 전체 배경색을 흰색으로 설정
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 프로필 이미지 및 정보
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(
                        radius: 50.0,
                        backgroundColor: Color(0xFF1D3557),
                        child: Icon(
                          Icons.person,
                          size: 50.0,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // 프로필 사진 변경 로직
                        },
                        icon: const Icon(Icons.camera_alt),
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'xxx 님',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'nhlee0918@gmail.com',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            // 사용자 정보 수정 입력 필드
            TextField(
              decoration: InputDecoration(
                labelText: '사용자명',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // 정보 수정 버튼
            ElevatedButton(
              onPressed: () {
                // 회원 정보 수정 로직
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D3557),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('회원 정보 수정', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 24.0),

            // 친구 및 그룹 정보
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '친구 수',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                Text('11', style: TextStyle(fontSize: 16.0)),
              ],
            ),
            const SizedBox(height: 8.0),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '공유 그룹 수',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                Text('3', style: TextStyle(fontSize: 16.0)),
              ],
            ),
            const SizedBox(height: 24.0),

            // 로그아웃 버튼
            ElevatedButton(
              onPressed: () {
                // 로그인 화면으로 이동
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D3557),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('로그아웃', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
