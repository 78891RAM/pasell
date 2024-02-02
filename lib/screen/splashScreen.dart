import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:recan/screen/Entry/loginScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  // void initState() {
  //   super.initState();
  //   _navigateToLogin();
  // }

  var gap = const SizedBox(height: 10, width: 10);
  // _navigateToLogin() {
  //   Future.delayed(const Duration(seconds: 2), () {
  //     Navigator.of(context).pushReplacementNamed('/Login');
  //   });
  // }
  @override
  void initState() {
    super.initState();
    _checkTokenAndNavigate();
  }

  _checkTokenAndNavigate() async {
    const storage = FlutterSecureStorage();
    var token = await storage.read(key: 'token');

    if (token != null) {
      // Token is available, navigate to home page
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      // Token is not available, navigate to login page after a delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/Login');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(children: [
        Image.asset('images/aa.png'),
        // const Text('Recan', style: TextStyle(fontSize: 30)),
        gap,
        Container(
          margin: const EdgeInsets.only(left: 120, right: 120),
          child: const LinearProgressIndicator(
            backgroundColor: Colors.white,
            valueColor:
                AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 70, 207, 74)),
          ),
        )
      ]),
      backgroundColor: const Color.fromARGB(254, 4, 115, 195),
      nextScreen: const Login(),
      splashIconSize: 190,
      duration: 2000,
      splashTransition: SplashTransition.scaleTransition,
      pageTransitionType: PageTransitionType.topToBottom,
      // animationDuration: const Duration(seconds: 2),
    );
  }
}
