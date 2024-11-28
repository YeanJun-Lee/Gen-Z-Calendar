import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '회원가입',
          style: TextStyle(
            color: Color(0xFF1D3557), // 진한 파란색
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // 뒤로가기 버튼을 검정색으로
          onPressed: () {
            Navigator.pop(context); // 이전 화면으로 돌아가기
          },
        ),
        backgroundColor: Colors.white, // AppBar 배경색을 흰색으로 설정
        elevation: 0, // AppBar 그림자 제거
      ),
      backgroundColor: Colors.white, // 전체 배경색을 흰색으로 설정
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 프로필 이미지 추가 버튼
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Color(0xFF1D3557), // 진한 파란색 배경
                    child: Icon(
                      Icons.person,
                      size: 50.0,
                      color: Color(0xFFCCCCCC), // 사람 아이콘을 밝은 회색으로 설정
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // 프로필 이미지 추가 로직
                    },
                    icon: Icon(Icons.camera_alt),
                    color: Colors.white, // 카메라 아이콘을 흰색으로 설정
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.0),

            // 사용자명 입력 필드
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: '사용자명',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),

            // 이메일 입력 필드
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: '아이디 (이메일)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
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
            ),
            SizedBox(height: 16.0),

            // 비밀번호 확인 입력 필드
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호 확인',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),

            // 약관 동의 체크박스
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                  activeColor: Color(0xFF1D3557),
                ),
                Expanded(
                  child: Text(
                    '본인은 만 14세 이상이고 이용약관에 동의합니다.',
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),

            // 회원가입 버튼
            ElevatedButton(
              onPressed: isChecked
                  ? () {
                      // 회원가입 로직 추가
                    }
                  : null, // 체크박스가 선택되지 않으면 버튼 비활성화
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1D3557), // 버튼 색상: 진한 파란색
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                '회원가입',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
