import 'package:flutter/material.dart';
import 'package:home_market/services/constants/app_colors.dart';
import 'package:home_market/views/intro/bottom_sheet.dart';
import 'package:home_market/views/intro/intros.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with SingleTickerProviderStateMixin {
  final controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool bookmarked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Exit'),
                content: const Text('Do you want to exit the app?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('No'),
                  ),
                  const SizedBox(
                    width: 120,
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Yes'),
                  ),
                ],
              );
            });
        if (value != null) {
          return Future.value(value);
        } else {
          return Future.value(false);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              PageView(
                controller: controller,
                children: const [
                  Intro(
                      image: 'assets/images/intro_image_3.png',
                      str1: 'Lorem ',
                      str2: 'Ipsum is simply\n',
                      str3: 'dummy text printing',
                      str4:
                          "Lorem Ipsum is simply dummy text of the\nprinting and typesetting industry."),
                  Intro(
                      image: 'assets/images/intro_image_1.png',
                      str1: 'Lorem ',
                      str2: 'Ipsum is simply\n',
                      str3: 'dummy text printing',
                      str4:
                          "Lorem Ipsum is simply dummy text of the\nprinting and typesetting industry."),
                  Intro(
                      image: 'assets/images/intro_image_2.png',
                      str1: 'Lorem ',
                      str2: 'Ipsum is simply\n',
                      str3: 'dummy text printing',
                      str4:
                          "Lorem Ipsum is simply dummy text of the\nprinting and typesetting industry."),
                ],
              ),
              TextButton(
                onPressed: () {
                  controller.animateToPage(3,
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.linear);
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.ff006EFF),
                ),
              ),
            ],
          ),
        ),
        bottomSheet: CustomBottomSheet(
          controller: controller,
        ),
      ),
    );
  }
}
