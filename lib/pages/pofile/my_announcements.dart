import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:home_market/blocs/post/post_bloc.dart';
import 'package:home_market/main.dart';
import 'package:home_market/pages/detail_page.dart';
import 'package:home_market/pages/post_info_page.dart';
import 'package:home_market/services/constants/app_colors.dart';
import 'package:home_market/views/profile/my_card.dart';

import '../../blocs/main/main_bloc.dart';
import '../../services/constants/app_str.dart';

class MyAnnouncements extends StatefulWidget {
  const MyAnnouncements({super.key});

  @override
  State<MyAnnouncements> createState() => _MyAnnouncementsState();
}

class _MyAnnouncementsState extends State<MyAnnouncements> {
  @override
  void initState() {
    super.initState();
    context.read<MainBloc>().add(const MyPostEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: .0,
        title: Text(
          "My announcements".tr(),
          style: TextStyle(
              fontSize: 19.sp,
              color: hiveDb.isLight ? AppColors.ffffffff : AppColors.ff122D4D,
              fontFamily: I18N.poppins,
              fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
            color: hiveDb.isLight ? AppColors.ffffffff : AppColors.ff000000,
          ),
        ),
      ),
      body: BlocListener<PostBloc, PostState>(
        listener: (context, state) {
          if (state is DeletePostSuccess) {
            context.read<MainBloc>().add(const MyPostEvent());
          }
          if (state is UpdatePostSuccess) {
            context.read<MainBloc>().add(const MyPostEvent());
          }
        },
        child: BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            return Stack(
              children: [
                ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final post = state.items[index];

                    return Column(
                      children: [
                        SizedBox(height: 10.sp),
                        Slidable(
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  context.read<PostBloc>().add(DeletePostEvent(
                                      post.id, post.gridImages));
                                },
                                backgroundColor: const Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                              ),
                              SlidableAction(
                                onPressed: (context) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailPage(
                                                post: post,
                                              )));
                                },
                                backgroundColor: AppColors.ff006EFF,
                                foregroundColor: Colors.white,
                                icon: Icons.change_circle_outlined,
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => InfoPage(
                                            post: post,
                                          )));
                            },
                            child: MyCard(
                              post: post,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                if (state is MainLoading ||
                    context.read<PostBloc>().state is PostLoading)
                  const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
