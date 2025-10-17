import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remit_bi/data/hive_boxes.dart';
import 'package:remit_bi/view/screens/home_screen.dart';
import 'package:remit_bi/view/screens/login/login_screen.dart';
import 'package:remit_bi/view/screens/login/set_mpin_screen.dart';

class AuthController extends GetxController {
  final companyCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final countryCtrl = TextEditingController(text: 'India');
  final countryWithFlagCtrl = TextEditingController();
  final phoneCodeCtrl = TextEditingController(text: '+91');
  final mobileCtrl = TextEditingController();

  String mpinErrorText = '';
  RxBool isLoading = false.obs;

  Future<void> signUpUser() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    final box = HiveBoxes.userBox;
    box.put('company', companyCtrl.text);
    box.put('email', emailCtrl.text);
    box.put('country', countryCtrl.text);
    box.put('mobile', mobileCtrl.text);
    isLoading.value = false;
    Get.to(() => SetMpinScreen());
  }

  Future<void> saveMPIN(String mpin) async {
    debugPrint('Saving MPIN: $mpin');
    isLoading.value = true;
    if (mpin.length == 6) {
      await Future.delayed(const Duration(milliseconds: 300));
      HiveBoxes.userBox.put('mpin', mpin);
      HiveBoxes.userBox.put('isLoggedIn', true);
      Get.snackbar('MPIN', 'MPIN set successfully. Please login.');
      Get.offAll(() => LoginScreen());
    } else {
      mpinErrorText = 'MPIN must be 6 digits';
      update(['set-mpin']);
    }
    isLoading.value = false;
  }

  Future<void> validateMPIN(String enteredMpin) async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 300));
    final savedMpin = HiveBoxes.userBox.get('mpin');
    if (enteredMpin == savedMpin) {
      final box = HiveBoxes.userBox;
      debugPrint("Hello ${box.get('company')}\nEmail: ${box.get('email')}");
      isLoading.value = false;
      Get.offAll(() => HomeScreen());
    } else {
      mpinErrorText = 'Invalid MPIN';
      update(['login-mpin']);
      isLoading.value = false;
    }
  }

  Future<void> resetMPIN() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    Get.snackbar(
      duration: Duration(seconds: 5),
      'MPIN',
      'We’ve verified your registered email ID. You can now set a new MPIN to access your account securely.',
    );
    isLoading.value = false;
    Get.off(() => SetMpinScreen());
  }
}
