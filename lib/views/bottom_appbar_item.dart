import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_market/blocs/bottom_app_bar/appbar_bloc.dart';
import 'package:home_market/main.dart';
import 'package:home_market/services/constants/app_colors.dart';

// ignore: must_be_immutable
class BottomAppBarItem extends StatelessWidget {
  final String icon;

  int index;
  void Function() onTap;
  BottomAppBarItem({
    super.key,
    required this.icon,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 17.5.sp),
      child: BlocBuilder<LandingPageBloc, LandingPageState>(
          builder: (context, state) {
        return Padding(
          padding: index == 1
              ? EdgeInsets.only(right: 10.sp)
              : index == 2
                  ? EdgeInsets.only(left: 10.sp)
                  : EdgeInsets.zero,
          child: GestureDetector(
              onTap: onTap,
              child: state.tabIndex != index
                  ? Image.asset(
                      icon,
                      height: 25.sp,
                      color: hiveDb.isLight
                          ? AppColors.ffffffff.withOpacity(.5)
                          : AppColors.ff000000.withOpacity(.4),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          icon,
                          height: 30.sp,
                          color: hiveDb.isLight
                              ? AppColors.ff016FFF
                              : AppColors.ff016FFF.withOpacity(.8),
                        ),
                        SizedBox(height: 5.sp),
                        SizedBox(
                          height: 10.sp,
                          width: 10.sp,
                          child: const DecoratedBox(
                              decoration: BoxDecoration(
                            color: AppColors.ff016FFF,
                            shape: BoxShape.circle,
                          )),
                        )
                      ],
                    )),
        );
      }),
    );
  }
}
