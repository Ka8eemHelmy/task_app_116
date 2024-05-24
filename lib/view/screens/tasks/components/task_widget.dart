import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_app_116/model/task_model.dart';
import '../../../../view_model/utils/app_colors.dart';

class TaskWidget extends StatelessWidget {
  final Task task;
  final void Function()? onTap;
  const TaskWidget({required this.task, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cyan.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(12.sp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: checkStatus(task.status ?? ''),
              width: 2.w,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title ?? '',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 6.h,
              ),
              Text(
                task.description ?? '',
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 14.sp,
                ),
              ),
              Visibility(
                visible: task.image != null,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    task.image ?? '',
                    height: 200.h,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error_outline_rounded, color: Colors.red,);
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 6.h,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(12.sp),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.purple,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.timer_outlined,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          Expanded(
                            child: Text(
                              task.startDate ?? '',
                              style: TextStyle(
                                color: AppColors.grey,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w,),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(12.sp),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.purple,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.timer_off_outlined,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          Expanded(
                            child: Text(
                              task.endDate ?? '',
                              style: TextStyle(
                                color: AppColors.grey,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


Color checkStatus(String status){
  switch (status) {
    case 'outdated':
      return Colors.black54;
    case 'compeleted':
      return Colors.green;
    case 'doing':
      return Colors.blue;
    default:
      return AppColors.purple;
  }
}