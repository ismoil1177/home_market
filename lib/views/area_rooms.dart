import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_market/main.dart';
import 'package:home_market/services/constants/app_colors.dart';
import 'package:home_market/services/constants/app_str.dart';

class AreaAndRooms extends StatelessWidget {
  final String icon;
  final String count;
  const AreaAndRooms({super.key, required this.count, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          icon,
          height: 15.sp,
          color: hiveDb.isLight ? AppColors.ff016FFF : null,
        ),
        SizedBox(width: 5.sp),
        Text(
          count,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            fontFamily: I18N.poppins,
          ),
        ),
      ],
    );
  }
}
