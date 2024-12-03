import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈 화면'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login'); // 로그인 화면으로 이동
              } catch (e) {
                print("로그아웃 실패: $e");
              }
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('로그인 성공! 홈 화면입니다.'),
      ),
    );
  }
}
