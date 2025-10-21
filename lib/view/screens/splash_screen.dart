import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remit_bi/data/hive_boxes.dart';
import 'package:remit_bi/view/screens/login/login_screen.dart';
import 'package:remit_bi/view/screens/signup/signup_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    final loggedIn = HiveBoxes.userBox.get('isLoggedIn', defaultValue: false);

    Future.delayed(const Duration(seconds: 2), () {
      Get.offAll(() => loggedIn ? const LoginScreen() : const SignupScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 99, 205),
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 50),
              // logo
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/Remit_BI-logo.png',
                  width: 150,
                  height: 150,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      "Remit BI",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "Your business insights, simplified.",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    CupertinoActivityIndicator(color: Colors.white, radius: 15),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
