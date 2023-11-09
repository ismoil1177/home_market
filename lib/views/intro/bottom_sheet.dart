import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_market/services/constants/app_colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomBottomSheet extends StatelessWidget {
  final PageController controller;
  const CustomBottomSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 70.sp,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SmoothPageIndicator(
              controller: controller,
              count: 3,
              effect: WormEffect(
                spacing: 7.sp,
                dotWidth: 10.sp,
                dotHeight: 10.sp,
                dotColor: const Color(0xffD2E0FF),
                activeDotColor: AppColors.ff006EFF,
                type: WormType.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
