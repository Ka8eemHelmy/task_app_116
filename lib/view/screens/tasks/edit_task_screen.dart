import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_app_116/translation/locale_keys.g.dart';
import 'package:task_app_116/view_model/cubits/tasks_cubit/tasks_cubit.dart';
import 'package:task_app_116/view_model/themes/light_theme.dart';
import 'package:task_app_116/view_model/utils/app_colors.dart';

class EditTaskScreen extends StatelessWidget {
  final int index;

  const EditTaskScreen({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = TasksCubit.get(context)
      ..initData(index)
      ..image = null;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: Form(
          key: cubit.formKey,
          child: ListView(
            padding: EdgeInsets.all(12.sp),
            shrinkWrap: true,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      LocaleKeys.editTask.tr(),
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12.h,
              ),
              TextFormField(
                controller: cubit.titleController,
                textInputAction: TextInputAction.next,
                onTapOutside: (focus) {
                  FocusScope.of(context).unfocus();
                },
                decoration: InputDecoration(
                  labelText: LocaleKeys.title.tr(),
                  prefixIcon: const Icon(
                    Icons.title_rounded,
                  ),
                ),
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return LocaleKeys.titleError.tr();
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 6.h,
              ),
              TextFormField(
                controller: cubit.descriptionController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: LocaleKeys.description.tr(),
                  prefixIcon: const Icon(
                    Icons.description,
                  ),
                ),
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return LocaleKeys.descriptionError.tr();
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 6.h,
              ),
              TextFormField(
                controller: cubit.startDateController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.none,
                readOnly: true,
                onTap: () {
                  showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 10),
                  ).then((value) {
                    cubit.startDateController.text =
                        (value ?? DateTime.now()).toStringDate();
                  });
                },
                decoration: InputDecoration(
                  labelText: LocaleKeys.startDate.tr(),
                  prefixIcon: const Icon(
                    Icons.timer_outlined,
                  ),
                ),
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return LocaleKeys.startDateError.tr();
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 6.h,
              ),
              TextFormField(
                controller: cubit.endDateController,
                decoration: InputDecoration(
                  labelText: LocaleKeys.endDate.tr(),
                  prefixIcon: const Icon(
                    Icons.timer_off_outlined,
                  ),
                ),
                keyboardType: TextInputType.none,
                readOnly: true,
                onTap: () {
                  showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 10),
                  ).then((value) {
                    cubit.endDateController.text =
                        (value ?? DateTime.now()).toStringDate();
                  });
                },
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return LocaleKeys.endDateError.tr();
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 12.h,
              ),
              Material(
                borderRadius: BorderRadius.circular(12.r),
                child: InkWell(
                  onTap: () {
                    cubit.selectImage();
                  },
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    padding: EdgeInsets.all(12.sp),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.purple,
                      ),
                    ),
                    child: BlocBuilder<TasksCubit, TasksState>(
                      builder: (context, state) {
                        return Visibility(
                          visible: cubit.tasks[index].image == null &&
                              cubit.image == null,
                          replacement: Visibility(
                            visible: cubit.image != null,
                            replacement: ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Image.network(
                                cubit.tasks[index].image ?? '',
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Image.file(
                                File(
                                  cubit.image?.path ?? '',
                                ),
                              ),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.r),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Image.network(
                                  'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
                                  height: 200.h,
                                ),
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              Text(
                                LocaleKeys.addPhotoToYourNote.tr(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              BlocBuilder<TasksCubit, TasksState>(
                builder: (context, state) {
                  return Visibility(
                    visible: state is AddTaskLoadingState,
                    child: const LinearProgressIndicator(),
                  );
                },
              ),
              SizedBox(
                height: 12.h,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        if (cubit.formKey.currentState!.validate()) {
                          cubit.editTaskFirebase(index).then((value) {
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: Text(
                        LocaleKeys.edit.tr(),
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                LocaleKeys.delete.tr(),
                              ),
                              content: Text(
                                LocaleKeys.deleteConfirmation.tr(),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    LocaleKeys.no.tr(),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    cubit.deleteTaskFirebase(index).then(
                                      (value) {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                  child: Text(
                                    LocaleKeys.yes.tr(),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text(
                        LocaleKeys.delete.tr(),
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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
