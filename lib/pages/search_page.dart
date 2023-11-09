import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_market/blocs/main/main_bloc.dart';
import 'package:home_market/main.dart';

import 'package:home_market/pages/post_info_page.dart';
import 'package:home_market/services/constants/app_colors.dart';
import 'package:home_market/services/constants/app_icons.dart';
import 'package:home_market/services/constants/app_str.dart';

class SearchPage extends StatefulWidget {
  final String str;
  const SearchPage({super.key, required this.str});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<MainBloc>().add(const GetAllDataEvent());
        return true;
      },
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.velocity.pixelsPerSecond.dx > 50.sp) {
            context.read<MainBloc>().add(const GetAllDataEvent());
            Navigator.pop(context);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () {
                context.read<MainBloc>().add(const GetAllDataEvent());
                Navigator.pop(context);
              },
              child: Icon(
                  Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios),
            ),
            title: Text(
              widget.str.tr(),
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: I18N.poppins),
            ),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 80.sp),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 10.sp, horizontal: 15.sp),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(14.sp)),
                    boxShadow: [
                      !hiveDb.isLight
                          ? BoxShadow(
                              blurRadius: 4.sp,
                              offset: Offset(2.sp, 3.sp),
                              color: AppColors.ff000000.withOpacity(.23),
                            )
                          : BoxShadow(
                              blurRadius: 4.sp,
                              offset: Offset(2.sp, 3.sp),
                              color: AppColors.ffffffff.withOpacity(.4),
                              blurStyle: BlurStyle.outer),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      fillColor: hiveDb.isLight
                          ? AppColors.ff000000.withOpacity(.2)
                          : AppColors.ffffffff,
                      filled: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(
                            top: 8.0.sp,
                            bottom: 8.0.sp,
                            left: 15.sp,
                            right: 15.sp),
                        child: Image.asset(
                          AppIcons.search,
                          height: 20.sp,
                        ),
                      ),
                      hintStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: hiveDb.isLight
                              ? AppColors.ffffffff
                              : const Color(0xFF000000)),
                      hintText: "Search".tr(),
                      border: InputBorder.none,
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius:
                              BorderRadius.all(Radius.circular(14.sp))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius:
                              BorderRadius.all(Radius.circular(14.sp))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius:
                              BorderRadius.all(Radius.circular(14.sp))),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius:
                              BorderRadius.all(Radius.circular(14.sp))),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius:
                              BorderRadius.all(Radius.circular(14.sp))),
                    ),
                    onChanged: (text) {
                      final bloc = context.read<MainBloc>();
                      debugPrint(text);
                      if (text.isEmpty) {
                        bloc.add(const GetAllDataEvent());
                      } else {
                        bloc.add(SearchMainEvent(text));
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          body: BlocBuilder<MainBloc, MainState>(builder: (context, state) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 5.sp, top: 10.sp, right: 5.sp),
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final post = state.items[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => InfoPage(post: post)));
                  },
                  child: Stack(
                    alignment: Alignment(0.9.sp, -1.sp),
                    children: [
                      Card(
                        elevation: 10.sp,
                        color: !hiveDb.isLight
                            ? AppColors.ffffffff
                            : AppColors.ff000000.withOpacity(.4),
                        child: SizedBox(
                          height: 180.sp,
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: CachedNetworkImage(
                                      imageUrl: post.gridImages[0],
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator
                                              .adaptive(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      imageBuilder: (context, imageProvider) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.sp)),
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        );
                                      })),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 7.sp, right: 5.sp),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          post.title,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontFamily: I18N.poppins,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12.sp,
                                            color: hiveDb.isLight
                                                ? AppColors.ffffffff
                                                    .withOpacity(.9)
                                                : const Color(0xff2F2F2F),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          post.content,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontFamily: I18N.inter,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11.sp,
                                            color: hiveDb.isLight
                                                ? AppColors.ffffffff
                                                    .withOpacity(.7)
                                                : AppColors.ff000000
                                                    .withOpacity(.5),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            "\$${post.price}",
                                            style: TextStyle(
                                              fontFamily: I18N.inter,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 11.sp,
                                              color: hiveDb.isLight
                                                  ? AppColors.ffffffff
                                                      .withOpacity(.8)
                                                  : AppColors.ff006EFF,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
