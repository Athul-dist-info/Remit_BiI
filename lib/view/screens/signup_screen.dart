import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:remit_bi/view/screens/login_screen.dart';
import 'package:remit_bi/view/widgets/custom_textbutton.dart';
import 'package:remit_bi/view/widgets/primary_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final companyCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final countryCtrl = TextEditingController(text: 'India');
  final countryWithFlagCtrl = TextEditingController();
  final phoneCodeCtrl = TextEditingController(text: '+91');
  final mobileCtrl = TextEditingController();

  late Country selectedCountry;

  @override
  void initState() {
    super.initState();
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

    countryCtrl.text = selectedCountry.name;
    phoneCodeCtrl.text = '+${selectedCountry.phoneCode}';
    countryWithFlagCtrl.text =
        '${selectedCountry.flagEmoji} ${selectedCountry.name}';
  }

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
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.04,
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
                          _buildTextfield(
                            controller: companyCtrl,
                            fieldLabel: 'Company Name',
                            hintText: 'Enter Company Name',
                          ),
                          SizedBox(height: 15),
                          _buildTextfield(
                            controller: emailCtrl,
                            fieldLabel: 'Email ID',
                            hintText: 'Enter your official email address',
                          ),
                          SizedBox(height: 15),

                          _buildTextfield(
                            readOnly: true,
                            controller: countryWithFlagCtrl,
                            fieldLabel: 'Country',
                            hintText: 'Select Country',
                            onTap: () {
                              showCountryPicker(
                                context: context,
                                showPhoneCode: true,
                                onSelect: (Country country) {
                                  selectedCountry = country;
                                  countryCtrl.text = country.name;
                                  countryWithFlagCtrl.text =
                                      '${country.flagEmoji} ${country.name}';
                                  phoneCodeCtrl.text = '+${country.phoneCode}';
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
                                  controller: phoneCodeCtrl,
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                flex: 3,
                                child: _buildTextfield(
                                  controller: mobileCtrl,
                                  hintText: 'Enter your mobile number',
                                ),
                              ),
                            ],
                          ),
                          PrimaryButton(
                            label: 'Sign In',
                            width: width,
                            onPressed: () {},
                          ),
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
            SvgPicture.asset('assets/svg/curve.svg'),
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
          onTap: onTap,
        ),
      ],
    );
  }
}
