import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = '';
  bool _isLoading = false;

  Future<void> loginUser() async {
    setState(() {
      _isLoading = true; // 로딩 상태 시작
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      setState(() {
        _message = "로그인 성공: ${userCredential.user?.email}";
        _emailController.clear();
        _passwordController.clear();
        _isLoading = false; // 로딩 상태 종료
      });

      Navigator.pushReplacementNamed(context, '/home'); // 홈 화면으로 이동
    } catch (e) {
      setState(() {
        _message = "로그인 실패: $e";
        _isLoading = false; // 로딩 상태 종료
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : loginUser, // 로딩 중에는 버튼 비활성화
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white) // 로딩 스피너 표시
                  : const Text('로그인'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register'); // 회원가입 화면으로 이동
              },
              child: const Text('회원가입'),
            ),
            const SizedBox(height: 20),
            Text(
              _message,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
