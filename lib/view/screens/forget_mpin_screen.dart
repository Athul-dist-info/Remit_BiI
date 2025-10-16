import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:remit_bi/view/screens/signup_screen.dart';
import 'package:remit_bi/view/widgets/custom_textbutton.dart';
import 'package:remit_bi/view/widgets/primary_button.dart';

class ForgetMpinScreen extends StatelessWidget {
  const ForgetMpinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
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
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: 28,
                        color: const Color.fromARGB(255, 38, 99, 205),
                      ),
                      onPressed: () => Get.back(),
                    ),
                    Center(
                      child: SvgPicture.asset('assets/svg/forgot-password.svg'),
                    ),
                    SizedBox(height: 50),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Forget MPIN',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Reset Your MPIN',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff00275D),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Enter your registered email address to reset your MPIN',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              isDense: true,
                              filled: true,
                              fillColor: Color(0xffF5F5F5),
                              hintText: 'example@gmail.com',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          PrimaryButton(
                            label: 'Send Reset Link',
                            width: width,
                            onPressed: () {},
                          ),
                          Center(
                            child: CustomTextButton(
                              text1: 'New user?',
                              text2: ' Sign in for the first time.',
                              onTap1: () {
                                Get.to(() => SignupScreen());
                              },
                            ),
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
