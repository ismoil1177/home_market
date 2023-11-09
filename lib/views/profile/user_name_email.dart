import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_market/main.dart';
import 'package:home_market/services/firebase/auth_service.dart';

import '../../services/constants/app_colors.dart';
import '../../services/constants/app_str.dart';

class UserNameEmail extends StatelessWidget {
  UserNameEmail({super.key});

  final String? name = FirebaseAuth.instance.currentUser!.displayName;
  final String? email = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.sp),
      child: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.ffffffff.withOpacity(.2),
                  blurRadius: 2,
                  offset: Offset(2, 2),
                )
              ],
            ),
            child: CircleAvatar(
                radius: 62.sp,
                backgroundColor: hiveDb.isLight
                    ? AppColors.ff000000.withOpacity(.5)
                    : AppColors.ff016FFF,
                child: AuthService.user.photoURL == null
                    ? Icon(
                        Icons.person,
                        size: 70.sp,
                        color: hiveDb.isLight
                            ? AppColors.ffffffff
                            : AppColors.ffffffff,
                      )
                    : CachedNetworkImage(
                        imageUrl: AuthService.user.photoURL!,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator.adaptive(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover, image: imageProvider)),
                          );
                        })),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 18.sp),
              Text(
                name ?? "Name",
                style: TextStyle(
                    fontSize: 20.sp,
                    height: 1,
                    fontFamily: I18N.poppins,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 6.sp),
              Text(
                email ?? "email",
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 1,
                  fontFamily: I18N.poppins,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
