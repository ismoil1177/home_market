import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_market/main.dart';
import 'package:home_market/services/constants/app_colors.dart';
import 'package:home_market/views/custom_txt_field.dart';

import '../../services/constants/app_str.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _controller = TextEditingController();

  void resetPassword(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _controller.text.trim(),
      );
      if (mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }

      if (mounted) {
        Navigator.pop(context);
      }
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(flex: 1),
            Center(
              child: Text(
                "Receive an email to your password.",
                style: TextStyle(
                  color:
                      hiveDb.isLight ? AppColors.ffffffff : AppColors.ff000000,
                  fontFamily: I18N.poppins,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 15.sp),
            Center(
                child: CustomTextField(
              controller: _controller,
              title: 'Email',
            )),
            const Spacer(flex: 2),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: hiveDb.isLight
                    ? AppColors.ff000000.withOpacity(.7)
                    : AppColors.ff016FFF,
                minimumSize: Size(MediaQuery.sizeOf(context).width, 54.sp),
              ),
              onPressed: () {
                resetPassword(context);
              },
              child: Text(
                "Reset password",
                style: TextStyle(
                  color: AppColors.ffffffff,
                  fontSize: 16.sp,
                ),
              ),
            ),
            SizedBox(height: 35.sp),
          ],
        ),
      ),
    );
  }
}
