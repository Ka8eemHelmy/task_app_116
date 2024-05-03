import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_app_116/view_model/utils/app_colors.dart';

ThemeData lightTheme = ThemeData(
  primaryColor: AppColors.purple,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.purple,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r,),
      ),
    ),
  ),
);