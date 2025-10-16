import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.text1,
    this.text2 = '',
    this.onTap1,
    this.onTap2,
  });

  final String text1;
  final String text2;
  final VoidCallback? onTap1;
  final VoidCallback? onTap2;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: text1,
            style: TextStyle(
              color:
                  onTap1 != null
                      ? const Color.fromARGB(255, 38, 99, 205)
                      : Colors.black,
              fontWeight: onTap1 != null ? FontWeight.w500 : FontWeight.normal,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTap1,
          ),
          TextSpan(
            text: text2,
            style: TextStyle(
              color:
                  onTap2 != null
                      ? const Color.fromARGB(255, 38, 99, 205)
                      : Colors.black,
              fontWeight: onTap2 != null ? FontWeight.w500 : FontWeight.normal,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTap2,
          ),
        ],
      ),
    );
  }
}
