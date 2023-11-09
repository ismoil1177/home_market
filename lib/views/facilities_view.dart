import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_market/main.dart';
import 'package:home_market/models/facilities_model.dart';
import 'package:home_market/services/constants/app_colors.dart';
import 'package:home_market/services/constants/app_str.dart';

class FacilitiesContainer extends StatelessWidget {
  final Facilities facility;
  final List<Facilities> facilities;
  final void Function() onTap;
  const FacilitiesContainer(
      {super.key,
      required this.facility,
      required this.onTap,
      required this.facilities});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 10.sp, top: 10.sp),
        padding: EdgeInsets.only(
            left: 10.sp, right: 10.sp, bottom: 10.sp, top: 5.sp),
        height: 65.sp,
        width: 85.sp,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.sp)),
          color: facilities.contains(facility)
              ? hiveDb.isLight
                  ? AppColors.ff989898.withOpacity(.4)
                  : AppColors.ffffffff
              : AppColors.ff989898.withOpacity(.05),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              facility.icon,
              height: 25.sp,
              color: hiveDb.isLight ? AppColors.ffffffff : null,
            ),
            Text(
              facility.name.tr(),
              style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: I18N.inter,
                  color: !facilities.contains(facility)
                      ? AppColors.ffffffff
                      : hiveDb.isLight
                          ? AppColors.ffffffff
                          : AppColors.ff000000),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
