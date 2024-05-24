import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_app_116/translation/locale_keys.g.dart';
import 'package:task_app_116/view/screens/auth/register_screen.dart';
import 'package:task_app_116/view_model/cubits/auth_cubit/auth_cubit.dart';
import 'package:task_app_116/view_model/utils/app_assets.dart';
import 'package:task_app_116/view_model/utils/navigation.dart';
import 'package:task_app_116/view_model/utils/snackbar.dart';
import '../../../view_model/utils/app_colors.dart';
import '../tasks/tasks_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: AuthCubit.get(context).formKey,
          child: ListView(
            padding: EdgeInsets.all(12.sp),
            children: [
              Image.asset(
                AppAssets.todo,
                height: 200.h,
              ),
              SizedBox(
                height: 12.h,
              ),
              Align(
                alignment: AlignmentDirectional.center,
                child: Text(
                  LocaleKeys.login.tr(),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              TextFormField(
                controller: AuthCubit.get(context).emailController,
                decoration: InputDecoration(
                  labelText: LocaleKeys.email.tr(),
                ),
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return LocaleKeys.emailError.tr();
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 6.h,
              ),
              BlocBuilder<AuthCubit, AuthState>(
                buildWhen: (previous, current) {
                  return current is ChangeHidePasswordState;
                },
                builder: (context, state) {
                  return TextFormField(
                    controller: AuthCubit.get(context).passwordController,
                    decoration: InputDecoration(
                        labelText: LocaleKeys.password.tr(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            AuthCubit.get(context).changeHidePassword();
                          },
                          icon: Icon(
                            AuthCubit.get(context).hidePassword
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_outlined,
                          ),
                        )),
                    obscureText: AuthCubit.get(context).hidePassword,
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) {
                        return LocaleKeys.passwordError.tr();
                      }
                      return null;
                    },
                  );
                },
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Text(
                    LocaleKeys.doNotHaveAnAccount.tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.grey,
                    ),
                  ),
                  SizedBox(
                    width: 6.w,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigation.push(context, const RegisterScreen());
                    },
                    child: Text(
                      LocaleKeys.register.tr(),
                      style: TextStyle(
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12.h,
              ),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is LoginSuccessState) {
                    SnackBarHelper.showMessage(context, 'Login Successfully');
                    Navigation.pushAndRemove(context, const TasksScreen());
                  } else if (state is LoginErrorState) {
                    SnackBarHelper.showError(context, state.msg);
                  }
                },
                buildWhen: (previous, current) {
                  return current is! ChangeHidePasswordState;
                },
                builder: (context, state) {
                  if (state is LoginLoadingState) {
                    return const CircularProgressIndicator.adaptive();
                  }
                  return ElevatedButton(
                    onPressed: () {
                      if (AuthCubit.get(context)
                          .formKey
                          .currentState!
                          .validate()) {
                        AuthCubit.get(context).loginFirebase();
                      }
                    },
                    child: Text(
                      LocaleKeys.login.tr(),
                      style: TextStyle(fontSize: 16.sp, color: AppColors.white),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 12.h,
              ),
              TextButton(
                onPressed: () {
                  AuthCubit.get(context).forgetPasswordFirebase();
                },
                child: Text(
                  LocaleKeys.forgetPassword.tr(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
