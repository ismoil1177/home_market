import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_market/main.dart';
import 'package:home_market/models/post_model.dart';
import 'package:home_market/services/constants/app_icons.dart';

import '../../services/constants/app_colors.dart';
import '../../services/constants/app_str.dart';
import '../area_rooms.dart';

class MyCard extends StatelessWidget {
  final Post post;

  const MyCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.sp,
      color: !hiveDb.isLight
          ? AppColors.ffffffff
          : AppColors.ff000000.withOpacity(.4),
      child: Container(
        padding: EdgeInsets.all(10.sp),
        height: 120.sp,
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
                flex: 3,
                child: CachedNetworkImage(
                    imageUrl: post.gridImages[0],
                    placeholder: (context, url) =>
                        CircularProgressIndicator.adaptive(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.sp)),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      );
                    })),
            Expanded(
              flex: 7,
              child: Padding(
                padding: EdgeInsets.only(left: 7.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 15.sp),
                    Text(
                      post.title,
                      style: TextStyle(
                        fontFamily: I18N.inter,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                        color: hiveDb.isLight
                            ? AppColors.ffffffff.withOpacity(.9)
                            : AppColors.ff122D4D,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 5.sp),
                    Text(
                      post.content,
                      style: TextStyle(
                        fontFamily: I18N.inter,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: hiveDb.isLight
                            ? AppColors.ffffffff.withOpacity(.7)
                            : AppColors.ff415770,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      child: Row(
                        children: [
                          AreaAndRooms(count: post.area, icon: AppIcons.area),
                          SizedBox(width: 10.sp),
                          AreaAndRooms(count: post.rooms, icon: AppIcons.rooms),
                          const Spacer(),
                          Text(
                            '\$${post.price}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.ff016FFF,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
