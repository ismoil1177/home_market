import 'package:flutter/material.dart';
import 'package:home_market/main.dart';
import 'package:home_market/services/constants/app_colors.dart';

class PostLoadingPage extends StatelessWidget {
  const PostLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      color: hiveDb.isLight
          ? AppColors.ff000000.withOpacity(.1)
          : AppColors.ffffffff.withOpacity(.1),
      child: const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
