import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_app_116/view_model/cubits/auth_cubit/auth_cubit.dart';
import 'package:task_app_116/view_model/cubits/tasks_cubit/tasks_cubit.dart';

import 'view/screens/splash/splash_screen.dart';
import 'view_model/themes/light_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthCubit(),
            ),
            BlocProvider(
              create: (context) => TasksCubit(),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            home: child,
          ),
        );
      },
      child: const SplashScreen(),
    );
  }
}

/// To Generate Locale Translations Keys File
///
/// flutter pub run easy_localization:generate -S assets/translations -O lib/translation -o locale_keys.g.dart -f keys
