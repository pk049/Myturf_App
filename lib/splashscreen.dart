import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_turf/main.dart';
import 'package:my_turf/signuppage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_turf/Authstorage.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  var loginData=null;
  // final loginData = await AuthStorage.getLoginData();

  Future<void> checkLogin() async {
    loginData = await AuthStorage.getLoginData();
  }

  @override
  void initState() {
    super.initState();

    checkLogin();

    Timer(const Duration(seconds: 3), () {
      if (loginData['token'] != null){
        Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainPage()),
      );}
      else
        {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const SignUpPage()),
          );
        }
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );


  }



  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildBouncingDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 12,
              height: 12 + (_animation.value * (i == 0 ? 1 : i == 1 ? 0.7 : 0.5)),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF00C853), // Mint green
              Color(0xFF009624), // Deeper green
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              buildBouncingDots(),

              const SizedBox(height: 40),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'My',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    margin: const EdgeInsets.only(left: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Turf',
                      style: TextStyle(
                        color: Color(0xFF0A9D56),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
