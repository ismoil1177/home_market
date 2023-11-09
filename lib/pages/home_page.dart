import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_market/blocs/auth/auth_bloc.dart';
import 'package:home_market/blocs/main/main_bloc.dart';
import 'package:home_market/blocs/post/post_bloc.dart';
import 'package:home_market/main.dart';
import 'package:home_market/pages/auth_pages/sign_in_page.dart';
import 'package:home_market/pages/post_info_page.dart';
import 'package:home_market/pages/search_page.dart';
import 'package:home_market/services/constants/app_colors.dart';
import 'package:home_market/services/constants/app_icons.dart';
import 'package:home_market/services/constants/app_str.dart';
import 'package:home_market/services/firebase/auth_service.dart';
import 'package:home_market/views/area_rooms.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<MainBloc>().add(const GetAllDataEvent());
  }

  bool enabled = true;
  bool like = false;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: hiveDb.getListenable,
        builder: (context, mode, child) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              forceMaterialTransparency: true,
              toolbarHeight: 100.sp,
              centerTitle: false,
              title: RichText(
                  text: TextSpan(
                children: [
                  TextSpan(
                    text: I18N.letsFind.tr(),
                    style: TextStyle(
                        fontSize: 20.sp,
                        color: hiveDb.isLight
                            ? AppColors.ffffffff
                            : AppColors.ff8997A9,
                        fontFamily: I18N.poppins,
                        fontWeight: FontWeight.w400),
                  ),
                  TextSpan(
                    text: I18N.favHome.tr(),
                    style: TextStyle(
                        fontSize: 25.sp,
                        color: hiveDb.isLight
                            ? AppColors.ff016FFF
                            : AppColors.ff122D4D,
                        fontFamily: I18N.poppins,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              )),
              actions: [
                if (AuthService.user.photoURL == null)
                  CircleAvatar(
                    radius: 30.sp,
                    child: Text(
                      AuthService.user.displayName!
                          .substring(0, 1)
                          .toUpperCase(),
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontFamily: I18N.poppins,
                      ),
                    ),
                  )
                else
                  CachedNetworkImage(
                    imageUrl: AuthService.user.photoURL!,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator.adaptive(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                        radius: 30.sp,
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover)),
                        )),
                  ),
                SizedBox(width: 25.sp),
              ],
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
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchPage(
                                    str: "Search Announcements".tr())));
                      },
                      child: SizedBox(
                        height: 55.sp,
                        width: double.infinity,
                        child: TextField(
                          autofocus: false,
                          enabled: false,
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
                                    : AppColors.ff000000),
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
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: MultiBlocListener(
              listeners: [
                BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthFailure) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.message)));
                    }

                    if (state is DeleteAccountSuccess && context.mounted) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.message)));
                    }

                    if (state is SignOutSuccess) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const SignInPage()));
                    }
                  },
                ),
                BlocListener<PostBloc, PostState>(
                  listener: (context, state) {
                    if (state is DeletePostSuccess) {
                      context.read<MainBloc>().add(const GetAllDataEvent());
                    }

                    if (state is PostFailure) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                )
              ],
              child:
                  BlocBuilder<MainBloc, MainState>(builder: (context, state) {
                return ListView(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                            left: 10.sp, bottom: 20.sp, top: 10.sp),
                        child: context.read<MainBloc>().state.items.isNotEmpty
                            ? Text(
                                I18N.recomendations.tr(),
                                style: TextStyle(
                                  fontFamily: I18N.inter,
                                  fontSize: 23.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : const SizedBox.shrink()),
                    Stack(
                      children: [
                        if (state.items.isNotEmpty)
                          CarouselSlider.builder(
                            itemCount: state.items.length,
                            itemBuilder: (context, index, realIndex) {
                              final post = state.items[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => InfoPage(
                                            post: post,
                                          )));
                                },
                                child: Stack(
                                  alignment: Alignment(0.8.sp, -1.sp),
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: hiveDb.isLight
                                            ? AppColors.ff000000.withOpacity(.2)
                                            : AppColors.ffffffff,
                                        borderRadius:
                                            BorderRadius.circular(15.sp),
                                        boxShadow: [
                                          hiveDb.isLight
                                              ? BoxShadow(
                                                  blurRadius: 4.sp,
                                                  offset: Offset(2.sp, 2.sp),
                                                  color: AppColors.ffffffff,
                                                  blurStyle: BlurStyle.outer)
                                              : BoxShadow(
                                                  blurRadius: 4.sp,
                                                  offset: Offset(2.sp, 2.sp),
                                                  color: AppColors.ff000000
                                                      .withOpacity(.3),
                                                ),
                                        ],
                                      ),
                                      margin: EdgeInsets.only(right: 20.sp),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(15.sp),
                                                  topRight:
                                                      Radius.circular(15.sp)),
                                              child: CachedNetworkImage(
                                                placeholder: (context, _) =>
                                                    SizedBox(
                                                  height: 40.sp,
                                                  width: 40.sp,
                                                  child: const Center(
                                                    child:
                                                        CircularProgressIndicator
                                                            .adaptive(),
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                                imageUrl: post.gridImages[0],
                                                imageBuilder: (context,
                                                        imageBuilder) =>
                                                    Image(
                                                        width: double.infinity,
                                                        fit: BoxFit.cover,
                                                        image: imageBuilder),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 15.sp,
                                                  right: 15.sp,
                                                  bottom: 5.sp),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      post.title,
                                                      style: TextStyle(
                                                        fontFamily: I18N.inter,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 18.sp,
                                                        color: hiveDb.isLight
                                                            ? AppColors.ffffffff
                                                                .withOpacity(.9)
                                                            : AppColors
                                                                .ff122D4D,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      post.content,
                                                      style: TextStyle(
                                                        fontFamily: I18N.inter,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14.sp,
                                                        color: hiveDb.isLight
                                                            ? AppColors.ffffffff
                                                                .withOpacity(.7)
                                                            : AppColors
                                                                .ff415770,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
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
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.sp, vertical: 5.sp),
                                      decoration: BoxDecoration(
                                          color: hiveDb.isLight
                                              ? AppColors.ff415770
                                                  .withOpacity(.9)
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
                                                    offset:
                                                        const Offset(-1, -1),
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
                                                  ),
                                                  BoxShadow(
                                                    blurRadius: 4,
                                                    offset:
                                                        const Offset(-1, -1),
                                                    color: AppColors.ffffffff
                                                        .withOpacity(.7),
                                                  ),
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
                            options: CarouselOptions(
                              enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                              clipBehavior: Clip.none,
                              aspectRatio: 6.sp / 3.5.sp,
                              viewportFraction: 0.8,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.5,
                              scrollDirection: Axis.horizontal,
                            ),
                          )
                        else
                          const SizedBox.shrink(),
                        if (state is MainLoading)
                          const Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 10.sp, right: 15.sp, top: 10.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            I18N.all.tr(),
                            style: TextStyle(
                              fontFamily: I18N.inter,
                              fontSize: 23.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        ListView.separated(
                          separatorBuilder: (context, index) => SizedBox(
                            height: 20.sp,
                          ),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.only(
                              left: 10.sp, top: 15.sp, right: 10.sp),
                          itemCount: state.items.length,
                          itemBuilder: (context, index) {
                            final post = state.items[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        InfoPage(post: post)));
                              },
                              child: Stack(
                                alignment: Alignment(0.9.sp, -1.sp),
                                children: [
                                  Card(
                                    elevation: 7.sp,
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
                                                  placeholder: (context, url) =>
                                                      SizedBox(
                                                        height: 35.sp,
                                                        width: 20.sp,
                                                        child: const Center(
                                                          child:
                                                              CircularProgressIndicator
                                                                  .adaptive(),
                                                        ),
                                                      ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                  imageUrl: post.gridImages[0],
                                                  imageBuilder:
                                                      (context, imageBuilder) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15.sp)),
                                                        image: DecorationImage(
                                                            image: imageBuilder,
                                                            fit: BoxFit.cover),
                                                      ),
                                                    );
                                                  })),
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
                                            ? AppColors.ff415770.withOpacity(.9)
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
                                                      .withOpacity(.2),
                                                ),
                                                BoxShadow(
                                                  blurRadius: 4,
                                                  offset: const Offset(-1, -1),
                                                  color: AppColors.ffffffff
                                                      .withOpacity(.2),
                                                ),
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
