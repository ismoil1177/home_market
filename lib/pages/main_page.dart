import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_market/blocs/bottom_app_bar/appbar_bloc.dart';
import 'package:home_market/main.dart';
import 'package:home_market/pages/detail_page.dart';
import 'package:home_market/pages/home_page.dart';
import 'package:home_market/pages/map/all_home_map.dart';
import 'package:home_market/pages/my_like_page.dart';
import 'package:home_market/pages/pofile/profile.dart';
import 'package:home_market/services/constants/data.dart';
import 'package:home_market/views/bottom_appbar_item.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController controller = PageController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: hiveDb.getListenable,
        builder: (context, mode, child) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetailPage(),
                    ));
              },
              shape: const CircleBorder(),
              child: Icon(
                Icons.add,
                size: 30.sp,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniCenterDocked,
            bottomNavigationBar:
                BlocConsumer<LandingPageBloc, LandingPageState>(
              listener: (context, state) {},
              builder: (context, state) {
                return BottomAppBar(
                    height: 70.sp,
                    notchMargin: 12.sp,
                    shape: const CircularNotchedRectangle(),
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (int i = 0; i < icons.length; i++)
                          BottomAppBarItem(
                              icon: icons[i],
                              index: i,
                              onTap: () {
                                context
                                    .read<LandingPageBloc>()
                                    .add(TabChange(tabIndex: i));
                                controller.jumpToPage(i);
                              })
                      ],
                    ));
              },
            ),
            body: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: controller,
              children: [
                const HomePage(),
                const AllHomeMap(),
                const MyLikePage(),
                ProfilePage(controller: controller),
              ],
            ),
          );
        });
  }
}
