import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:remit_bi/controller/auth_controller.dart';
import 'package:remit_bi/view/screens/signup/signup_screen.dart';
import 'package:remit_bi/view/widgets/custom_textbutton.dart';
import 'package:remit_bi/view/widgets/loader.dart';
import 'package:remit_bi/view/widgets/primary_button.dart';

class ForgetMpinScreen extends StatelessWidget {
  const ForgetMpinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final width = MediaQuery.sizeOf(context).width;
    final authController = Get.put(AuthController());
    final emailCtrl = TextEditingController();
    authController.isLoading.value = false;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                          Form(
                            key: formKey,
                            child: TextFormField(
                              controller: emailCtrl,
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!GetUtils.isEmail(value)) {
                                  return 'Enter a valid email address';
                                }
                                return null;
                              },
                            ),
                          ),

                          Obx(() {
                            return authController.isLoading.isTrue
                                ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 50,
                                  ),
                                  child: loader(),
                                )
                                : PrimaryButton(
                                  label: 'Send Reset Link',
                                  width: width,
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      authController.resetMPIN();
                                    }
                                  },
                                );
                          }),

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
