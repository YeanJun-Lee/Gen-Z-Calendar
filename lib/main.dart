import 'package:flutter/material.dart';
import 'package:gen_z_calendar/notification_screen.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart'; // flutterfire configure로 생성된 파일
import 'splash_screen.dart'; // 스플래시 화면 파일
import 'login_screen.dart'; // 로그인 화면 파일
import 'home_screen.dart'; // 홈 화면 파일
import 'signup_screen.dart'; // 회원가입 화면 파일
import 'find_credentials_screen.dart'; // 아이디/비밀번호 찾기 화면 파일

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  // options: DefaultFirebaseOptions.currentPlatform,
  // ); // Firebase 초기화
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gen-Z Calendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // 앱 시작 시 표시될 초기 화면
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(), // 로그인 화면
        '/home': (context) => HomeScreen(), // 홈 화면
        '/signup': (context) => SignupScreen(), // 회원가입 화면
        '/find': (context) => FindCredentialsScreen(), // 아이디/비밀번호 찾기 라우트 추가
        'notification': (context) => NotificationScreen(), // 알림 화면
      },
    );
  }
}
