import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:remit_bi/controller/auth_controller.dart';
import 'package:remit_bi/view/widgets/loader.dart';
import 'package:remit_bi/view/widgets/pin_put.dart';
import 'package:remit_bi/view/widgets/primary_button.dart';

class SetMpinScreen extends StatelessWidget {
  const SetMpinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final authController = Get.find<AuthController>();
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
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: 28,
                        color: const Color.fromARGB(255, 38, 99, 205),
                      ),
                      onPressed: () => Get.back(),
                    ),
                    Center(child: SvgPicture.asset('assets/svg/login.svg')),
                    SizedBox(height: 50),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Set MPIN',
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
                      id: 'set-mpin',
                      builder: (controller) {
                        return MpinPut(
                          controller: mpinCntrl,
                          errorText: controller.mpinErrorText,
                          obscureText: false,
                          onChanged: (s) {
                            if (controller.mpinErrorText.isNotEmpty) {
                              controller.mpinErrorText = '';
                              controller.update(['set-mpin']);
                            }
                          },
                          onCompleted: (p0) async {},
                        );
                      },
                    ),

                    SizedBox(height: 15),

                    Obx(() {
                      return authController.isLoading.isTrue
                          ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: loader(),
                          )
                          : Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.08,
                            ),
                            child: PrimaryButton(
                              label: 'Continue',
                              width: width,
                              onPressed:
                                  () => authController.saveMPIN(mpinCntrl.text),
                            ),
                          );
                    }),
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
