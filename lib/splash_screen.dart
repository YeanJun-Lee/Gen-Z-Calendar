import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2)); // 2초 대기
    if (mounted) {
    Navigator.pushReplacementNamed(context, '/login'); // 로그인 화면으로 이동
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xFF1D3557), // 진한 파란색 배경
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 첫 번째 로고 이미지
            Image.asset(
              'assets/calendarlogo.png', // 첫 번째 이미지 경로
              width: 100, // 원하는 너비
              height: 100, // 원하는 높이
            ),
            const SizedBox(height: 20), // 이미지 간격
            // 두 번째 로고 이미지
            Image.asset(
              'assets/Gen_Zlogo.png', // 두 번째 이미지 경로
              width: 200, // 원하는 너비
              height: 50, // 원하는 높이
            ),
            const SizedBox(height: 20), // 이미지와 텍스트 사이 간격
            // Text(
            //   'Gen-Z-Calendar',
            //   style: TextStyle(
            //     fontSize: 36,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.white,
            //   ),
            // ),
            const SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
