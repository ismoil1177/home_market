import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_market/blocs/bottom_app_bar/appbar_bloc.dart';
import 'package:home_market/main.dart';
import 'package:home_market/pages/auth_pages/sign_in_page.dart';
import 'package:home_market/pages/pofile/my_announcements.dart';
import 'package:home_market/views/profile/user_name_email.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../services/constants/app_colors.dart';
import '../../services/constants/app_str.dart';
import '../../views/profile/profile_button.dart';

import 'settings_page.dart';

class ProfilePage extends StatefulWidget {
  final PageController controller;
  const ProfilePage({super.key, required this.controller});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void dispose() {
    super.dispose();
  }

  //^ to delete showDialog
  void showWarningDialog(BuildContext ctx) {
    final controller = TextEditingController();
    showDialog(
      context: ctx,
      builder: (context) {
        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is DeleteAccountSuccess) {
              Navigator.of(context).pop();
              if (ctx.mounted) {
                Navigator.of(ctx).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignInPage()));
              }
            }

            if (state is AuthFailure) {
              Navigator.of(context).pop();
              Navigator.of(ctx).pop();
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                AlertDialog(
                  shadowColor: AppColors.ff016FFF.withOpacity(.2),
                  backgroundColor: hiveDb.isLight
                      ? AppColors.ff000000
                      : const Color(0xffF9FBFF),
                  title: Text(
                    I18N.deleteAccount.tr(),
                    style: TextStyle(
                        fontSize: 18.sp,
                        color: hiveDb.isLight
                            ? AppColors.ffffffff
                            : AppColors.ff122D4D,
                        fontFamily: I18N.poppins,
                        fontWeight: FontWeight.w600),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state is DeleteConfirmSuccess
                            ? I18N.requestPassword.tr()
                            : I18N.deleteAccountWarning.tr(),
                        style: TextStyle(
                            fontSize: 15.sp,
                            color: AppColors.ff8997A9,
                            fontFamily: I18N.poppins,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10.sp,
                      ),
                      if (state is DeleteConfirmSuccess)
                        TextField(
                          controller: controller,
                          decoration:
                              InputDecoration(hintText: I18N.password.tr()),
                        ),
                    ],
                  ),
                  actionsAlignment: MainAxisAlignment.spaceBetween,
                  actions: [
                    /// #confirm #delete
                    Container(
                      decoration: BoxDecoration(
                          color: hiveDb.isLight
                              ? AppColors.ff000000.withOpacity(.8)
                              : AppColors.ff016FFF.withOpacity(.9),
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.sp)),
                          boxShadow: [
                            hiveDb.isLight
                                ? BoxShadow(
                                    blurRadius: 2,
                                    offset: const Offset(1, 1),
                                    color: AppColors.ffffffff.withOpacity(.6))
                                : BoxShadow(
                                    blurRadius: 2,
                                    offset: const Offset(1, 1),
                                    color: AppColors.ff000000.withOpacity(.3))
                          ]),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(I18N.cancel.tr(),
                            style: const TextStyle(color: AppColors.ffffffff)),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: hiveDb.isLight
                              ? AppColors.ff000000.withOpacity(.8)
                              : AppColors.ff016FFF.withOpacity(.9),
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.sp)),
                          boxShadow: [
                            hiveDb.isLight
                                ? BoxShadow(
                                    blurRadius: 2,
                                    offset: const Offset(1, 1),
                                    color: AppColors.ffffffff.withOpacity(.6))
                                : BoxShadow(
                                    blurRadius: 2,
                                    offset: const Offset(1, 1),
                                    color: AppColors.ff000000.withOpacity(.3))
                          ]),
                      child: TextButton(
                        onPressed: () {
                          if (state is DeleteConfirmSuccess) {
                            context.read<AuthBloc>().add(
                                DeleteAccountEvent(controller.text.trim()));
                          } else {
                            context
                                .read<AuthBloc>()
                                .add(const DeleteConfirmEvent());
                          }
                        },
                        child: Text(
                            state is DeleteConfirmSuccess
                                ? I18N.delete.tr()
                                : I18N.confirm.tr(),
                            style: const TextStyle(color: AppColors.ffffffff)),
                      ),
                    ),

                    /// #cancel
                  ],
                ),
                if (state is AuthLoading)
                  const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
              ],
            );
          },
        );
      },
    );
  }

  //^ Contact us showDialog
  void showContactUsDialog(BuildContext ctx) {
    showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog.adaptive(
            title: Center(
              child: Text(
                "Contact us".tr(),
                style: TextStyle(
                    fontSize: 18.sp,
                    color: hiveDb.isLight
                        ? AppColors.ffffffff
                        : AppColors.ff122D4D,
                    fontFamily: I18N.poppins,
                    fontWeight: FontWeight.w600),
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(top: 10.sp, bottom: 10.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          const String url = 'https://t.me/IlhomDev1';

                          if (await canLaunchUrlString(url)) {
                            await launchUrlString(url);
                          }
                        },
                        child: Icon(
                          Icons.telegram,
                          size: 45.sp,
                          color: hiveDb.isLight
                              ? AppColors.ffffffff
                              : AppColors.ff016FFF,
                        ),
                      ),
                    ),
                    SizedBox(width: 2.sp),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          Uri url = Uri(scheme: 'tel', path: '+998901234567');

                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          }
                        },
                        child: Icon(
                          Icons.phone,
                          size: 45.sp,
                          color: hiveDb.isLight
                              ? AppColors.ffffffff
                              : AppColors.ff016FFF,
                        ),
                      ),
                    ),
                    SizedBox(width: 2.sp),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          const String email = 'homemarketapp@gmail.com';
                          const String subject = "Home market messeng";
                          const String messeng = "Hello there\n\n";
                          const String url =
                              'mailto:$email?subject=${subject}&body=${messeng}';

                          if (await canLaunchUrlString(url)) {
                            await launchUrlString(url);
                          }
                        },
                        child: Icon(
                          Icons.email_outlined,
                          size: 45.sp,
                          color: hiveDb.isLight
                              ? AppColors.ffffffff
                              : AppColors.ff016FFF,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

//^ Sign Out showDialog
  void showSignOutDialog(BuildContext ctx) {
    showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog.adaptive(
            title: Center(
              child: Text(
                "Are you sure you want to sign out?".tr(),
                style: TextStyle(
                    fontSize: 15.sp,
                    color: hiveDb.isLight
                        ? AppColors.ffffffff
                        : AppColors.ff122D4D,
                    fontFamily: I18N.poppins,
                    fontWeight: FontWeight.w600),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: hiveDb.isLight
                            ? AppColors.ff000000.withOpacity(.8)
                            : AppColors.ff016FFF.withOpacity(.9),
                        borderRadius: BorderRadius.all(Radius.circular(25.sp)),
                        boxShadow: [
                          hiveDb.isLight
                              ? BoxShadow(
                                  blurRadius: 2,
                                  offset: const Offset(1, 1),
                                  color: AppColors.ffffffff.withOpacity(.6))
                              : BoxShadow(
                                  blurRadius: 2,
                                  offset: const Offset(1, 1),
                                  color: AppColors.ff000000.withOpacity(.3))
                        ]),
                    child: TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: Text("No".tr(),
                            style: const TextStyle(color: AppColors.ffffffff))),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15.sp, bottom: 15.sp),
                    decoration: BoxDecoration(
                        color: hiveDb.isLight
                            ? AppColors.ff000000.withOpacity(.8)
                            : AppColors.ff016FFF.withOpacity(.9),
                        borderRadius: BorderRadius.all(Radius.circular(25.sp)),
                        boxShadow: [
                          hiveDb.isLight
                              ? BoxShadow(
                                  blurRadius: 2,
                                  offset: const Offset(1, 1),
                                  color: AppColors.ffffffff.withOpacity(.6))
                              : BoxShadow(
                                  blurRadius: 2,
                                  offset: const Offset(1, 1),
                                  color: AppColors.ff000000.withOpacity(.3))
                        ]),
                    child: TextButton(
                        onPressed: () async {
                          ctx.read<AuthBloc>().add(const SignOutEvent());
                          context
                              .read<LandingPageBloc>()
                              .add(TabChange(tabIndex: 0));
                        },
                        child: Text(
                          "Yes".tr(),
                          style: const TextStyle(color: AppColors.ffffffff),
                        )),
                  ),
                ],
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MultiBlocListener(
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
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => SignInPage(),
                      ),
                      (route) => false);
                }
              },
            )
          ],
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height - 100.sp,
              child: Column(
                children: [
                  const Spacer(flex: 4),
                  //^ user_name_email file
                  UserNameEmail(),
                  const Spacer(flex: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Card(
                      elevation: 6,
                      shadowColor: Colors.blueGrey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          //^ Settings Button
                          ProfileButtom(
                            text: "Settings".tr(),
                            icon: Icon(
                              Icons.settings,
                              size: 29.sp,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingsPage(
                                    controller: widget.controller,
                                  ),
                                ),
                              );
                            },
                          ),

                          Container(
                            width: double.infinity,
                            height: 1,
                            color: Colors.grey.shade300,
                          ),
                          //^ My announcements Button
                          ProfileButtom(
                            text: "My announcements".tr(),
                            icon: Icon(
                              Icons.web_stories_outlined,
                              size: 29.sp,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyAnnouncements(),
                                ),
                              );
                            },
                          ),
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: Colors.grey.shade300,
                          ),
                          //^ Contact us Button
                          ProfileButtom(
                            text: "Contact us".tr(),
                            icon: Icon(
                              Icons.email_outlined,
                              size: 29.sp,
                            ),
                            onTap: () {
                              showContactUsDialog(context);
                            },
                          ),
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: Colors.grey.shade300,
                          ),
                          //^ Sign Out Button
                          ProfileButtom(
                            text: "Sign Out".tr(),
                            icon: Icon(
                              Icons.login,
                              size: 29.sp,
                            ),
                            onTap: () {
                              showSignOutDialog(context);
                            },
                          ),
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: Colors.grey.shade300,
                          ),
                          //^ Delete account Button
                          ProfileButtom(
                            text: "Delete account".tr(),
                            icon: Icon(
                              Icons.delete_outline,
                              size: 29.sp,
                            ),
                            onTap: () {
                              showWarningDialog(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(flex: 4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
