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
  final bool obscureText;
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
    this.obscureText = true,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: Pinput(
              length: 6,
              controller: controller,
              autofocus: autofocus,
              focusNode: focusNode,
              obscureText: obscureText,
              errorText: errorText.isNotEmpty ? errorText : null,
              scrollPadding: const EdgeInsets.only(bottom: 100),
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
          if (errorText.isNotEmpty)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 6,
                  right: MediaQuery.sizeOf(context).width * 0.08,
                ),
                child: Text(
                  errorText,
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                ),
              ),
            ),
        ],
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
