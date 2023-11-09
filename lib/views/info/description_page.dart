import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_market/main.dart';
import 'package:home_market/models/post_model.dart';
import 'package:home_market/services/constants/app_colors.dart';
import 'package:home_market/services/constants/app_icons.dart';
import 'package:home_market/services/constants/app_str.dart';
import 'package:home_market/views/info/desc_component.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../pages/map/google_map.dart';

// ignore: must_be_immutable
class DescriptionPage extends StatefulWidget {
  Post? post;
  DescriptionPage({required this.post, super.key});

  @override
  State<DescriptionPage> createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20.sp,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DescriptionComponent(
                  ammount: widget.post!.area,
                  icon: AppIcons.area,
                  place: "sqft".tr()),
              DescriptionComponent(
                  ammount: widget.post!.rooms,
                  icon: AppIcons.rooms,
                  place: 'Rooms'.tr()),
              DescriptionComponent(
                  ammount: widget.post!.bathrooms,
                  icon: AppIcons.bathroom,
                  place: "Bathrooms".tr())
            ],
          ),
        ),
        SizedBox(
          height: 25.sp,
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.sp),
          child: Text(
            "Listing Agent".tr(),
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                fontFamily: I18N.poppins,
                color:
                    hiveDb.isLight ? AppColors.ffffffff : AppColors.ff2A2B3F),
          ),
        ),
        SizedBox(height: 15.sp),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.sp),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25.sp,
                child: Text(
                  widget.post!.userName.substring(0, 1),
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: 8.sp),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.post!.userName,
                    style: TextStyle(
                      color: hiveDb.isLight
                          ? AppColors.ff006EFF
                          : AppColors.ff2A2B3F,
                      fontFamily: I18N.poppins,
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                      height: 1,
                    ),
                  ),
                  Text(
                    "user".tr(),
                    style: TextStyle(
                      color: AppColors.ff8C8C8C,
                      fontFamily: I18N.poppins,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 1),
              IconButton(
                onPressed: () async {
                  String email = widget.post!.email;
                  const String subject = "Home market messeng";
                  const String messeng = "Hello there\n\n";
                  String url = 'mailto:$email?subject=$subject&body=$messeng';

                  if (await canLaunchUrlString(url)) {
                    await launchUrlString(url);
                  }
                },
                icon: Image.asset(
                  AppIcons.email,
                  width: 25.sp,
                ),
              ),
              IconButton(
                onPressed: () async {
                  Uri url = Uri(scheme: 'tel', path: widget.post!.phone);

                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                icon: Image.asset(
                  AppIcons.phone,
                  width: 25.sp,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.sp, top: 25.sp),
          child: Text(
            "Facilities".tr(),
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                fontFamily: I18N.poppins),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 12.sp, left: 12.sp, top: 10.sp),
          child: Wrap(
            children: [
              for (int i = 0; i < widget.post!.facilities.length; i++)
                Container(
                  margin: EdgeInsets.only(right: 10.sp, top: 10.sp),
                  padding: EdgeInsets.only(
                      left: 10.sp, right: 10.sp, bottom: 10.sp, top: 5.sp),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        widget.post!.facilities[i].icon,
                        height: 25.sp,
                        color: hiveDb.isLight ? AppColors.ffffffff : null,
                      ),
                      Text(
                        widget.post!.facilities[i].name.tr(),
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: I18N.inter,
                            color: hiveDb.isLight
                                ? AppColors.ffffffff
                                : AppColors.ff000000),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.sp, top: 25.sp),
          child: Text(
            "Location of the building".tr(),
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                fontFamily: I18N.poppins),
          ),
        ),
        SizedBox(height: 20.sp),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.sp),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(16.sp)),
            child: SizedBox(
              width: double.infinity,
              height: 250.sp,
              child: StandartMap(
                lat: double.tryParse(widget.post!.lat)!,
                long: double.tryParse(widget.post!.long)!,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
