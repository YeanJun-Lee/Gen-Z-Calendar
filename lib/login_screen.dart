import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String errorMessage = ''; // 오류 메시지를 저장하는 변수
  bool isLoading = false; // 로딩 상태 

  // 로그인 함수
  Future<void> login() async {
    setState(() {
      isLoading = true;
    });
    try {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      // Firebase Authentication 로그인
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (mounted) {
      // 로그인 성공 시 홈 화면으로 이동
      Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      // Firebase 로그인 오류 처리
      setState(() {
        switch (e.code) {
          case 'user_not_found':
            errorMessage = '등록되지 않은 이메일입니다.';
            break;
          case 'wrong_password':
            errorMessage = '비밀번호가 올바르지 않습니다. ';
            break;
          case 'empth-fields':
            errorMessage = e.message!;
            break;
          defalut:
            errorMessage = '오류 발생: ${e.message}';
        }
        if (e.code == 'user-not-found') {
          errorMessage = '등록되지 않은 이메일입니다.';
        } else if (e.code == 'wrong-password') {
          errorMessage = '비밀번호가 올바르지 않습니다.';
        } else {
          errorMessage = '오류 발생: ${e.message}';
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = '예기치 않은 오류가 발생했습니다. ';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '로그인',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1D3557),
      ),
      backgroundColor: Colors.white,
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
                FocusScope.of(context).nextFocus();
              },
            ),
            const SizedBox(height: 16.0),

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
                login();
              },
            ),
            const SizedBox(height: 24.0),

            // 로그인 버튼
            ElevatedButton(
              onPressed: login,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D3557),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                '로그인',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),

            // 오류 메시지 출력
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 14.0),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 16.0),

            // 회원가입과 아이디/비밀번호 찾기
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 회원가입 버튼
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: const Text(
                    '회원가입',
                    style: TextStyle(fontSize: 14.0, color: Color(0xFF1D3557)),
                  ),
                ),
                // 아이디/비밀번호 찾기 버튼
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/find');
                  },
                  child: const Text(
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
