import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:remit_bi/controller/auth_controller.dart';
import 'package:remit_bi/view/screens/login/login_screen.dart';
import 'package:remit_bi/view/widgets/custom_textbutton.dart';
import 'package:remit_bi/view/widgets/loader.dart';
import 'package:remit_bi/view/widgets/primary_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final authController = Get.put(AuthController());
  late Country selectedCountry;

  @override
  void initState() {
    super.initState();
    authController.isLoading.value = false;
    selectedCountry = Country(
      phoneCode: '91',
      countryCode: 'IN',
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: 'India',
      example: '9123456789',
      displayName: 'India',
      displayNameNoCountryCode: 'India',
      e164Key: '',
    );

    authController.countryCtrl.text = selectedCountry.name;
    authController.phoneCodeCtrl.text = '+${selectedCountry.phoneCode}';
    authController.countryWithFlagCtrl.text =
        '${selectedCountry.flagEmoji} ${selectedCountry.name}';
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final formKey = GlobalKey<FormState>();

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
              child: SvgPicture.asset('assets/svg/curve.svg'),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (Navigator.of(context).canPop())
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            size: 28,
                            color: const Color.fromARGB(255, 38, 99, 205),
                          ),
                          onPressed: () => Get.back(),
                        ),
                      if (!Navigator.of(context).canPop())
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.05,
                        ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.05,
                          vertical: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Register your company and activate your Remit BI account.',
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                            SizedBox(height: 20),
                            Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildTextfield(
                                    controller: authController.companyCtrl,
                                    fieldLabel: 'Company Name',
                                    hintText: 'Enter Company Name',
                                    textInputAction: TextInputAction.next,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter Your Company Name';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 15),
                                  _buildTextfield(
                                    controller: authController.emailCtrl,
                                    fieldLabel: 'Email ID',
                                    hintText:
                                        'Enter your official email address',
                                    textInputAction: TextInputAction.next,
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
                                  SizedBox(height: 15),

                                  _buildTextfield(
                                    readOnly: true,
                                    controller:
                                        authController.countryWithFlagCtrl,
                                    fieldLabel: 'Country',
                                    hintText: 'Select Country',
                                    onTap: () {
                                      showCountryPicker(
                                        context: context,
                                        showPhoneCode: true,
                                        onSelect: (Country country) {
                                          selectedCountry = country;
                                          authController.countryCtrl.text =
                                              country.name;
                                          authController
                                                  .countryWithFlagCtrl
                                                  .text =
                                              '${country.flagEmoji} ${country.name}';
                                          authController.phoneCodeCtrl.text =
                                              '+${country.phoneCode}';
                                        },
                                      );
                                    },
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    'Mobile Number',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff00275D),
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: _buildTextfield(
                                          controller:
                                              authController.phoneCodeCtrl,
                                          readOnly: true,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        flex: 3,
                                        child: _buildTextfield(
                                          controller: authController.mobileCtrl,
                                          keyboardType: TextInputType.phone,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          hintText: 'Enter your mobile number',
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your mobile number';
                                            }
                                            if (!RegExp(
                                              r'^[0-9]+$',
                                            ).hasMatch(value)) {
                                              return 'Mobile number must contain digits only';
                                            }
                                            if (value.length < 7 ||
                                                value.length > 15) {
                                              return 'Enter a valid mobile number';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
                                    label: 'Sign In',
                                    width: width,
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        authController.signUpUser();
                                      }
                                    },
                                  );
                            }),
                            Center(
                              child: CustomTextButton(
                                text1: 'Have an account?',
                                text2: ' Login',
                                onTap2: () {
                                  Get.offAll(() => LoginScreen());
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
            ),
          ],
        ),
      ),
    );
  }

  Column _buildTextfield({
    required TextEditingController controller,
    String? fieldLabel,
    bool readOnly = false,
    String hintText = '',
    Widget? prefixIcon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    TextInputAction? textInputAction,
    Function(String?)? validator,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (fieldLabel != null) ...[
          Text(
            fieldLabel,
            style: TextStyle(fontSize: 16, color: Color(0xff00275D)),
          ),
          SizedBox(height: 6),
        ],
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Color(0xffF5F5F5),
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
            prefixIcon: prefixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          validator: validator != null ? (value) => validator(value) : null,
          onTap: onTap,
        ),
      ],
    );
  }
}
