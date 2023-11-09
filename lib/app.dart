import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_market/blocs/auth/auth_bloc.dart';
import 'package:home_market/blocs/bottom_app_bar/appbar_bloc.dart';
import 'package:home_market/blocs/main/main_bloc.dart';
import 'package:home_market/blocs/post/post_bloc.dart';
import 'package:home_market/main.dart';
import 'package:home_market/pages/auth_pages/sign_in_page.dart';
import 'package:home_market/pages/main_page.dart';
import 'package:home_market/services/firebase/auth_service.dart';

class HomeMarketApp extends StatelessWidget {
  const HomeMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
        BlocProvider<MainBloc>(create: (_) => MainBloc()),
        BlocProvider<PostBloc>(create: (_) => PostBloc()),
        BlocProvider<LandingPageBloc>(create: (_) => LandingPageBloc()),
      ],
      child: ValueListenableBuilder(
          valueListenable: hiveDb.getListenable,
          builder: (context, mode, child) {
            return MaterialApp(
              theme: ThemeData.light(useMaterial3: true),
              darkTheme: ThemeData.dark(useMaterial3: true),
              themeMode: hiveDb.mode,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              debugShowCheckedModeBanner: false,
              home: ScreenUtilInit(
                designSize: const Size(375, 812),
                minTextAdapt: true,
                child: StreamBuilder<User?>(
                  initialData: null,
                  stream: AuthService.auth.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null &&
                        FirebaseAuth.instance.currentUser!.emailVerified) {
                      return const MainPage();
                    } else {
                      return SignInPage();
                    }
                  },
                ),
              ),
            );
          }),
    );
  }
}
