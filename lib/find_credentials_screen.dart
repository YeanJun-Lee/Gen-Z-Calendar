import 'package:flutter/material.dart';

class FindCredentialsScreen extends StatefulWidget {
  const FindCredentialsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FindCredentialsScreenState createState() => _FindCredentialsScreenState();
}

class _FindCredentialsScreenState extends State<FindCredentialsScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isEmailSent = false; // 이메일 전송 상태

  void sendResetPasswordEmail() {
    String email = emailController.text.trim();

    if (email.isNotEmpty) {
      // Firebase Authentication의 비밀번호 재설정 이메일 전송 로직
      try {
        // 예시 코드 - 실제 Firebase 연동 필요
        // FirebaseAuth.instance.sendPasswordResetEmail(email: email);

        setState(() {
          isEmailSent = true; // 이메일 전송 성공
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('비밀번호 재설정 이메일이 전송되었습니다.'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('이메일 전송에 실패했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('이메일을 입력하세요.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '아이디/비밀번호 찾기',
          style: TextStyle(
            color: Color(0xFF1D3557),
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: '이메일을 입력하세요',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: sendResetPasswordEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1D3557),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                '비밀번호 재설정 이메일 전송',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
            if (isEmailSent) // 이메일 전송 완료 메시지 표시
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text(
                  '비밀번호 재설정 이메일이 전송되었습니다. 이메일을 확인하세요.',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
