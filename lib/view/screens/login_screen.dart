import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:remit_bi/view/screens/forget_mpin_screen.dart';
import 'package:remit_bi/view/screens/home_screen.dart';
import 'package:remit_bi/view/screens/signup_screen.dart';
import 'package:remit_bi/view/widgets/custom_textbutton.dart';
import 'package:remit_bi/view/widgets/pin_put.dart';
import 'package:remit_bi/view/widgets/primary_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final mpinCntrl = TextEditingController();
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: SvgPicture.asset('assets/svg/login.svg')),
                    SizedBox(height: 50),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Enter 6-digit MPIN',
                            style: TextStyle(
                              fontSize: 16,

                              color: Color(0xff00275D),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    MpinPut(
                      controller: mpinCntrl,
                      errorText: '',
                      onChanged: (s) {},
                      onCompleted: (p0) async {},
                    ),

                    SizedBox(height: 15),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: CustomTextButton(
                              text1: 'Forget MPIN?',
                              onTap1: () {
                                Get.to(() => ForgetMpinScreen());
                              },
                            ),
                          ),
                          PrimaryButton(
                            label: 'Login',
                            width: width,
                            onPressed: () => Get.offAll(HomeScreen()),
                          ),
                          CustomTextButton(
                            text1: 'New user?',
                            text2: ' Sign in for the first time.',
                            onTap1: () {
                              Get.to(() => SignupScreen());
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SvgPicture.asset('assets/svg/curve.svg'),
          ],
        ),
      ),
    );
  }
}
