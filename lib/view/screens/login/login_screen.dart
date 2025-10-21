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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final authController = Get.put(AuthController());
  final mpinCntrl = TextEditingController();
  final scrollController = ScrollController();
  final mpinFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    authController.mpinErrorText = '';
    authController.isLoading.value = false;

    mpinFocusNode.addListener(() {
      if (mpinFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 300), () {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    mpinCntrl.dispose();
    mpinFocusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: false,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              child: IgnorePointer(
                ignoring: true,
                child: SvgPicture.asset(
                  'assets/svg/curve.svg',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),

            LayoutBuilder(
              builder: (context, constraints) {
                return AnimatedPadding(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    physics: const ClampingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: SvgPicture.asset('assets/svg/login.svg'),
                            ),
                            const SizedBox(height: 50),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.08,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
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
                            const SizedBox(height: 20),

                            GetBuilder<AuthController>(
                              id: 'login-mpin',
                              builder: (controller) {
                                return MpinPut(
                                  controller: mpinCntrl,
                                  focusNode: mpinFocusNode,
                                  errorText: controller.mpinErrorText,
                                  onChanged: (s) {
                                    if (controller.mpinErrorText.isNotEmpty) {
                                      controller.mpinErrorText = '';
                                      controller.update(['login-mpin']);
                                    }
                                  },
                                );
                              },
                            ),

                            const SizedBox(height: 15),

                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.08,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: CustomTextButton(
                                      text1: 'Forget MPIN?',
                                      onTap1: () {
                                        Get.to(() => const ForgetMpinScreen());
                                      },
                                    ),
                                  ),
                                  Obx(() {
                                    return authController.isLoading.isTrue
                                        ? Padding(
                                          padding: EdgeInsets.symmetric(
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
                                      Get.to(() => const SignupScreen());
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
