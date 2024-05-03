import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class SnackBarHelper {
  static void showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: AppColors.white,),
            SizedBox(width: 6.w,),
            Expanded(
              child: Text(
                msg,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  static void showMessage(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Expanded(
              child: Text(
                msg,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.purple,
      ),
    );
  }
}