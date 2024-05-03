import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:task_app_116/my_app.dart';
import 'package:task_app_116/view_model/data/local/shared_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await SharedHelper.init();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      path: 'assets/translations',
      // <-- change the path of the translation files
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}
