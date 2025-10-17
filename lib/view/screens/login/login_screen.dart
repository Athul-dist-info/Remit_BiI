import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:remit_bi/controller/auth_controller.dart';
import 'package:remit_bi/view/screens/login/forget_mpin_screen.dart';
import 'package:remit_bi/view/screens/signup/signup_screen.dart';
import 'package:remit_bi/view/widgets/custom_textbutton.dart';
import 'package:remit_bi/view/widgets/loader.dart';
import 'package:remit_bi/view/widgets/pin_put.dart';
import 'package:remit_bi/view/widgets/primary_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final authController = Get.put(AuthController());
    final mpinCntrl = TextEditingController();
    authController.mpinErrorText = '';
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
                    GetBuilder<AuthController>(
                      id: 'login-mpin',
                      builder: (controller) {
                        return MpinPut(
                          controller: mpinCntrl,
                          errorText: controller.mpinErrorText,
                          onChanged: (s) {
                            if (controller.mpinErrorText.isNotEmpty) {
                              controller.mpinErrorText = '';
                              controller.update(['login-mpin']);
                            }
                          },
                          onCompleted: (p0) async {},
                        );
                      },
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

                          Obx(() {
                            return authController.isLoading.isTrue
                                ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 50,
                                  ),
                                  child: loader(),
                                )
                                : PrimaryButton(
                                  label: 'Login',
                                  width: width,
                                  onPressed:
                                      () => authController.validateMPIN(
                                        mpinCntrl.text,
                                      ),
                                );
                          }),

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
