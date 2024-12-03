import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = '';

  Future<void> _login() async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      setState(() {
        _message = "로그인 성공: ${userCredential.user?.email}";
      });

      Navigator.pushReplacementNamed(context, '/home'); // 홈 화면으로 이동
    } catch (e) {
      setState(() {
        _message = "로그인 실패: $e";
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
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            ElevatedButton(onPressed: _login, child: const Text('로그인')),
            Text(_message, style: const TextStyle(color: Colors.red)),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register'); // 회원가입 화면으로 이동
              },
              child: const Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}
