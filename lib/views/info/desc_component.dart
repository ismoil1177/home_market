import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_market/main.dart';
import 'package:home_market/services/constants/app_colors.dart';
import 'package:home_market/services/constants/app_str.dart';

class DescriptionComponent extends StatelessWidget {
  final String icon;
  final String ammount;
  final String place;
  const DescriptionComponent(
      {super.key,
      required this.ammount,
      required this.icon,
      required this.place});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10.sp, top: 10.sp),
      padding:
          EdgeInsets.only(left: 10.sp, right: 10.sp, bottom: 10.sp, top: 5.sp),
      height: 65.sp,
      width: 85.sp,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.sp)),
        color: hiveDb.isLight
            ? AppColors.ff989898.withOpacity(.4)
            : AppColors.ffffffff,
        boxShadow: [
          !hiveDb.isLight
              ? BoxShadow(
                  blurRadius: 12,
                  offset: Offset(2.sp, 6.sp),
                  color: AppColors.ff000000.withOpacity(.22),
                )
              : BoxShadow(
                  blurRadius: 4,
                  offset: Offset(1.sp, 1.sp),
                  color: AppColors.ffffffff,
                  blurStyle: BlurStyle.outer)
        ],
      ),
      child: Column(
        children: [
          Transform.scale(
            scale: 1.3.sp,
            child: Image.asset(
              icon,
              width: 20.sp,
              height: 15.sp,
              color: hiveDb.isLight ? AppColors.ffffffff : AppColors.ff006EFF,
            ),
          ),
          Spacer(),
          Text(
            ammount,
            style: TextStyle(
                fontSize: 12.sp,
                color: hiveDb.isLight ? AppColors.ffffffff : AppColors.ff006EFF,
                fontWeight: FontWeight.w500,
                fontFamily: I18N.poppins),
          ),
          Text(
            place,
            maxLines: 1,
            style: TextStyle(
                fontSize: 10.sp,
                fontFamily: I18N.poppins,
                fontWeight: FontWeight.w400,
                color: hiveDb.isLight
                    ? AppColors.ffffffff
                    : const Color(0xff6B6B6B)),
          )
        ],
      ),
    );
  }
}
