import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FindCredentialsScreen extends StatefulWidget {
  const FindCredentialsScreen({super.key});

  @override
  _FindCredentialsScreenState createState() => _FindCredentialsScreenState();
}

class _FindCredentialsScreenState extends State<FindCredentialsScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isEmailSent = false; // 이메일 전송 상태
  String errorMessage = ''; // 에러 메시지

  // 비밀번호 재설정 이메일 전송 함수
  Future<void> sendResetPasswordEmail() async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        errorMessage = '이메일을 입력하세요.';
      });
      return;
    }

    try {
      // Firebase Authentication의 비밀번호 재설정 이메일 전송
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      setState(() {
        isEmailSent = true; // 이메일 전송 성공 상태
        errorMessage = ''; // 에러 메시지 초기화
      });

      // 성공 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('비밀번호 재설정 이메일이 전송되었습니다.'),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Firebase 오류 처리
      setState(() {
        isEmailSent = false; // 실패 시 상태 초기화
        errorMessage = _getErrorMessage(e.code);
      });
    } catch (e) {
      // 기타 오류 처리
      setState(() {
        isEmailSent = false;
        errorMessage = '알 수 없는 오류 발생: $e';
      });
    }
  }

  // FirebaseAuthException 오류 코드에 따른 메시지 반환
  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-email':
        return '이메일 형식이 잘못되었습니다.';
      case 'user-not-found':
        return '등록되지 않은 이메일입니다.';
      case 'too-many-requests':
        return '요청이 너무 많습니다. 잠시 후 다시 시도하세요.';
      case 'network-request-failed':
        return '네트워크 연결에 실패했습니다.';
      default:
        return '이메일 전송에 실패했습니다. 다시 시도하세요.';
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
            // 이메일 입력 필드
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

            // 비밀번호 재설정 이메일 전송 버튼
            ElevatedButton(
              onPressed: sendResetPasswordEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D3557),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                '비밀번호 재설정 이메일 전송',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),

            // 성공 메시지 표시
            if (isEmailSent)
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

            // 에러 메시지 표시
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  errorMessage,
                  style: const TextStyle(
                    color: Colors.red,
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
