import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_market/services/constants/app_colors.dart';
import 'package:home_market/services/constants/app_str.dart';

class CustomDetailTextField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final int maxLines;
  final bool inputFormatter;
  final TextInputType keyboardType;
  const CustomDetailTextField(
      {Key? key,
      this.inputFormatter = false,
      required this.controller,
      required this.title,
      required this.maxLines,
      required this.keyboardType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      inputFormatters: inputFormatter
          ? [FilteringTextInputFormatter(RegExp('[0-9]'), allow: true)]
          : null,
      style: TextStyle(
          fontWeight: FontWeight.w600, fontSize: 14.sp, fontFamily: I18N.inter),
      minLines: 1,
      maxLines: maxLines,
      controller: controller,
      cursorColor: AppColors.ff016FFF,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: title,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(11.sp)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(11.sp)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(11.sp)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.ff016FFF, width: 2.sp),
          borderRadius: BorderRadius.all(Radius.circular(11.sp)),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(11.sp)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(11.sp)),
        ),
      ),
    );
  }
}
