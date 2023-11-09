import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_market/services/constants/app_colors.dart';

class Intro extends StatelessWidget {
  final String image;
  final String str1;
  final String str2;
  final String str3;
  final String str4;
  const Intro(
      {super.key,
      required this.str1,
      required this.str2,
      required this.str3,
      required this.str4,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(top: 90.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 1),
            Image.asset(
              image,
              fit: BoxFit.fitWidth,
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).width - 90.sp,
            ),
            const Spacer(flex: 1),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: str1,
                    style: TextStyle(
                      color: AppColors.ff7D7D7D,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: str2,
                    style: TextStyle(
                      color: AppColors.ff006EFF,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                      text: str3,
                      style: TextStyle(
                        color: AppColors.ff7D7D7D,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              str4,
              style: TextStyle(
                color: AppColors.ff7D7D7D,
                fontSize: 12.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(flex: 4),
            SizedBox(height: 70.sp),
          ],
        ),
      ),
    );
  }
}
