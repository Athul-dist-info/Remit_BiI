import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class MpinPut extends StatelessWidget {
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String)? onCompleted;
  final String errorText;
  final FocusNode? focusNode;
  final Widget? trailing;
  final bool autofocus;
  final void Function()? onClear;

  const MpinPut({
    super.key,
    this.controller,
    this.onChanged,
    this.onCompleted,
    this.errorText = '',
    this.focusNode,
    this.trailing,
    this.autofocus = false,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Pinput(
          length: 6,
          controller: controller,
          autofocus: autofocus,
          focusNode: focusNode,
          obscureText: true,
          errorText: errorText.isNotEmpty ? errorText : null,
          onCompleted: onCompleted,
          onChanged: onChanged,
          defaultPinTheme: _pinTheme(context, errorText, borderRadius: 10),
          focusedPinTheme: _pinTheme(
            context,
            errorText,
            borderRadius: 7,
            borderColor: const Color.fromARGB(255, 38, 99, 205),
          ),
        ),
      ),
    );
  }

  PinTheme _pinTheme(
    BuildContext context,
    String errorText, {
    double borderRadius = 8,
    Color? borderColor,
  }) {
    return PinTheme(
      width: MediaQuery.sizeOf(context).width / 8,
      height: MediaQuery.sizeOf(context).width / 8,
      textStyle: TextStyle(
        // color: accountController.isDark ? AppConfigs.w : null,
      ),
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Color(0xffEFEFEF),
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
    );
  }
}
