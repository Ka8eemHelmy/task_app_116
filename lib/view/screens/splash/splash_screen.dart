import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_app_116/view/screens/auth/login_screen.dart';
import 'package:task_app_116/view/screens/tasks/tasks_screen.dart';
import 'package:task_app_116/view_model/data/local/shared_helper.dart';
import 'package:task_app_116/view_model/data/local/shared_keys.dart';
import 'package:task_app_116/view_model/utils/app_assets.dart';
import 'package:task_app_116/view_model/utils/navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      if(SharedHelper.getData(SharedKeys.uid) == null){
        Navigation.pushAndRemove(context, const LoginScreen());
      }else{
        Navigation.pushAndRemove(context, const TasksScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          AppAssets.todo,
          height: 200.h,
        ),
      ),
    );
  }
}
