import 'package:easy_localization/easy_localization.dart';
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

extension ToDate on String {
  String toDate() {
    return DateFormat.yMMMd().add_jms().format(DateTime.parse(this));
  }
}

extension ToStringDate on DateTime{
  String toStringDate () {
    return DateFormat('yyyy-MM-dd')
        .format(this);
  }
}