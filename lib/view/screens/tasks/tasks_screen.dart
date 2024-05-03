import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_app_116/translation/locale_keys.g.dart';
import 'package:task_app_116/view/screens/auth/login_screen.dart';
import 'package:task_app_116/view_model/cubits/tasks_cubit/tasks_cubit.dart';
import 'package:task_app_116/view_model/data/local/shared_helper.dart';
import 'package:task_app_116/view_model/utils/app_colors.dart';
import 'package:task_app_116/view_model/utils/navigation.dart';
import 'package:task_app_116/view_model/utils/snackbar.dart';
import 'add_task_screen.dart';
import 'components/task_widget.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: TasksCubit.get(context)..getTasks(),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: AppColors.white,
          ),
          backgroundColor: AppColors.purple,
          title: Text(
            LocaleKeys.todoApp.tr(),
            style: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {
                if(context.locale.toString() == 'en'){
                  context.setLocale(const Locale('ar'));
                }else{
                  context.setLocale(const Locale('en'));
                }
              },
              icon: const Icon(
                Icons.translate,
                color: AppColors.white,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.filter_list_rounded,
                color: AppColors.white,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.exit_to_app_rounded,
                color: AppColors.white,
              ),
            ),
          ],
        ),
        body: BlocConsumer<TasksCubit, TasksState>(
          listener: (context, state) {
            if (state is UnauthenticatedState) {
              SnackBarHelper.showError(context,
                  'You Are Not Authenticated, Please Make A new Login');
              SharedHelper.clearData();
              Navigation.pushAndRemove(context, const LoginScreen());
            }
          },
          builder: (context, state) {
            var cubit = TasksCubit.get(context);
            return Visibility(
              visible: state is! GetTasksLoadingState,
              replacement:
                  const Center(child: CircularProgressIndicator.adaptive()),
              child: ListView.separated(
                padding: EdgeInsets.all(12.sp),
                itemBuilder: (context, index) {
                  return TaskWidget(
                    task: cubit.tasks[index],
                  );
                },
                separatorBuilder: (context, index) => SizedBox(
                  height: 12.h,
                ),
                itemCount: cubit.tasks.length,
              ),
            );
          },
        ),
        drawer: const Drawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              enableDrag: true,
              isDismissible: true,
              isScrollControlled: true,
              showDragHandle: true,
              builder: (context) {
                return AddTaskScreen();
              },
            );
          },
          shape: const CircleBorder(),
          backgroundColor: AppColors.purple,
          child: const Icon(
            Icons.add,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
