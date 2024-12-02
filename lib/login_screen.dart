import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // 더미 데이터: 로그인 테스트용 이메일과 비밀번호
  final String dummyEmail = 'hansung@naver.com';
  final String dummyPassword = 'hansung';

  // 로그인 함수
  void login() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email == dummyEmail && password == dummyPassword) {
      // 로그인 성공
      Navigator.pushReplacementNamed(context, '/home'); // 홈 화면으로 이동
    } else {
      // 로그인 실패
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('아이디 또는 비밀번호가 잘못되었습니다.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '로그인',
          style: TextStyle(color: Colors.white), // 글씨를 흰색으로
        ),
        backgroundColor: Color(0xFF1D3557), // 진한 파란색
      ),
      backgroundColor: Colors.white, // 전체 화면 배경을 흰색으로 설정
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 이메일 입력 필드
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: '아이디 (이메일)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onSubmitted: (_) {
                // Enter 키 입력 시 포커스를 비밀번호 필드로 이동
                FocusScope.of(context).nextFocus();
              },
            ),
            SizedBox(height: 16.0),

            // 비밀번호 입력 필드
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onSubmitted: (_) {
                // Enter 키 입력 시 로그인 함수 호출
                login();
              },
            ),
            SizedBox(height: 24.0),

            // 로그인 버튼
            ElevatedButton(
              onPressed: login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1D3557), // 진한 파란색
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                '로그인',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
            SizedBox(height: 16.0),

            // 회원가입 버튼과 아이디/비밀번호 찾기 버튼 나란히 배치
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 회원가입 버튼
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup'); // 회원가입 화면으로 이동
                  },
                  child: Text(
                    '회원가입',
                    style: TextStyle(fontSize: 14.0, color: Color(0xFF1D3557)),
                  ),
                ),
                // 아이디/비밀번호 찾기 버튼
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, '/find'); // 아이디/비밀번호 찾기 화면으로 이동
                  },
                  child: Text(
                    '아이디/비밀번호 찾기',
                    style: TextStyle(fontSize: 14.0, color: Color(0xFF1D3557)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
