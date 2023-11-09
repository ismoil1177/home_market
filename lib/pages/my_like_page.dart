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
import 'package:home_market/services/constants/data.dart';
import 'package:home_market/views/area_rooms.dart';

class MyLikePage extends StatefulWidget {
  const MyLikePage({super.key});

  @override
  State<MyLikePage> createState() => _MyLikePageState();
}

class _MyLikePageState extends State<MyLikePage> {
  @override
  void initState() {
    context.read<MainBloc>().add(const MyLikedEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: hiveDb.getListenable,
        builder: (context, mode, child) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: Text(
                'Favorite Houses'.tr(),
                style: TextStyle(
                    fontFamily: I18N.poppins,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: hiveDb.isLight
                        ? AppColors.ffffffff
                        : AppColors.ff006EFF),
              ),
            ),
            body: SafeArea(
              child: BlocBuilder<MainBloc, MainState>(
                  buildWhen: (previous, current) {
                return current is MyLikedSuccess;
              }, builder: (context, state) {
                return ListView(
                  children: [
                    Stack(
                      children: [
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.only(
                              left: 10.sp, top: 15.sp, right: 10.sp),
                          itemCount: state.items.length,
                          itemBuilder: (context, index) {
                            final post = state.items[index];

                            return GestureDetector(
                              onTap: () async {
                                fromIsLiked = true;
                                await Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            InfoPage(post: post)));
                                if (mounted) {
                                  context
                                      .read<MainBloc>()
                                      .add(const MyLikedEvent());
                                }
                              },
                              child: Stack(
                                alignment: Alignment(0.9.sp, -0.8.sp),
                                children: [
                                  Card(
                                    elevation: 10.sp,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 2.sp, vertical: 20.sp),
                                    color: !hiveDb.isLight
                                        ? AppColors.ffffffff
                                        : AppColors.ff000000.withOpacity(.4),
                                    child: Container(
                                      padding: EdgeInsets.all(10.sp),
                                      height: 350.sp,
                                      width: double.infinity,
                                      child: Column(
                                        children: [
                                          Expanded(
                                              flex: 9,
                                              child: CachedNetworkImage(
                                                imageUrl: post.gridImages[0],
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator
                                                        .adaptive(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                                imageBuilder:
                                                    (context, imageBuilder) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15.sp)),
                                                    image: DecorationImage(
                                                        image: imageBuilder,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                              )),
                                          Expanded(
                                            flex: 7,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 7.sp),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(height: 15.sp),
                                                  Text(
                                                    post.title,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontFamily: I18N.inter,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 18.sp,
                                                      color: hiveDb.isLight
                                                          ? AppColors.ffffffff
                                                              .withOpacity(.9)
                                                          : AppColors.ff122D4D,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  SizedBox(height: 5.sp),
                                                  Text(
                                                    post.content,
                                                    maxLines: 3,
                                                    style: TextStyle(
                                                      fontFamily: I18N.inter,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14.sp,
                                                      color: hiveDb.isLight
                                                          ? AppColors.ffffffff
                                                              .withOpacity(.7)
                                                          : AppColors.ff415770,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        AreaAndRooms(
                                                            count: post.area,
                                                            icon:
                                                                AppIcons.area),
                                                        SizedBox(width: 10.sp),
                                                        AreaAndRooms(
                                                            count: post.rooms,
                                                            icon:
                                                                AppIcons.rooms),
                                                        const Spacer(),
                                                        Text(
                                                          '\$${post.price}',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            color: AppColors
                                                                .ff016FFF,
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
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.sp, vertical: 5.sp),
                                    decoration: BoxDecoration(
                                        color: hiveDb.isLight
                                            ? AppColors.ff7D7D7D.withOpacity(1)
                                            : AppColors.ffffffff,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20.sp),
                                        ),
                                        boxShadow: !hiveDb.isLight
                                            ? [
                                                BoxShadow(
                                                  blurRadius: 2,
                                                  offset: const Offset(1, 1),
                                                  color: AppColors.ff000000
                                                      .withOpacity(.2),
                                                ),
                                                BoxShadow(
                                                  blurRadius: 2,
                                                  offset: const Offset(-1, -1),
                                                  color: AppColors.ff000000
                                                      .withOpacity(.1),
                                                ),
                                              ]
                                            : [
                                                BoxShadow(
                                                    blurRadius: 4,
                                                    offset: const Offset(1, 1),
                                                    color: AppColors.ffffffff
                                                        .withOpacity(.7),
                                                    blurStyle: BlurStyle.outer),
                                                BoxShadow(
                                                    blurRadius: 4,
                                                    offset:
                                                        const Offset(-1, -1),
                                                    color: AppColors.ffffffff
                                                        .withOpacity(.7),
                                                    blurStyle: BlurStyle.outer),
                                              ]),
                                    child: Text(
                                      post.isApartment
                                          ? I18N.apartment.tr()
                                          : I18N.house.tr(),
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: I18N.poppins,
                                          color: hiveDb.isLight
                                              ? AppColors.ffffffff
                                              : AppColors.ff478FF1),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        if (state is MainLoading)
                          const Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                      ],
                    ),
                  ],
                );
              }),
            ),
          );
        });
  }
}
