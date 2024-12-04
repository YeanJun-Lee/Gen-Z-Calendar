import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

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
  String errorMessage = ''; // 에러 메시지를 표시하기 위한 변수

  Future<void> registerUser() async {
    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        errorMessage = '비밀번호가 일치하지 않습니다.';
      });
      return;
    }

    try {
      // Firebase Authentication을 이용한 회원가입
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // 추가 사용자 정보 저장 (ex: DisplayName)
      await userCredential.user?.updateDisplayName(usernameController.text);

      setState(() {
        errorMessage = '회원가입 성공: ${userCredential.user?.email}';
      });

      // 회원가입 성공 후 로그인 화면으로 이동
      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'email-already-in-use') {
          errorMessage = '이미 사용 중인 이메일입니다.';
        } else if (e.code == 'weak-password') {
          errorMessage = '비밀번호는 최소 6자 이상이어야 합니다.';
        } else {
          errorMessage = '오류 발생: ${e.message}';
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = '오류 발생: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '회원가입',
          style: TextStyle(
            color: Color(0xFF1D3557), // 진한 파란색
            fontWeight: FontWeight.bold,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Color(0xFF1D3557),
                    child: Icon(
                      Icons.person,
                      size: 50.0,
                      color: Color(0xFFCCCCCC),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // 프로필 이미지 추가 로직
                    },
                    icon: const Icon(Icons.camera_alt),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: '사용자명',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: '아이디 (이메일)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

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
            const SizedBox(height: 16.0),

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
            const SizedBox(height: 16.0),

            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                  activeColor: const Color(0xFF1D3557),
                ),
                const Expanded(
                  child: Text(
                    '본인은 만 14세 이상이고 이용약관에 동의합니다.',
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            ElevatedButton(
              onPressed: isChecked
                  ? () {
                      registerUser(); // 회원가입 로직 호출
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D3557),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                '회원가입',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),

            // 에러 메시지 출력
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 14.0),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}