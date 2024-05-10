import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:educonnect/config/routes/app_routes.dart';
import 'package:educonnect/config/themes/custom_text_style.dart';
import 'package:educonnect/core/utils/app_colors.dart';
import 'package:educonnect/core/utils/image_constant.dart';
import 'package:educonnect/core/utils/size_utils.dart';
import 'package:educonnect/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:educonnect/features/auth/presentation/pages/signup_screen.dart';
import 'package:educonnect/features/auth/presentation/widgets/custom_elevated_button.dart';
import 'package:educonnect/features/auth/presentation/widgets/custom_outlined_button.dart';
import 'package:educonnect/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:educonnect/features/posts/presentation/widgets/custom_image_view.dart';
import 'package:educonnect/features/splash/presentation/cubit/locale_cubit.dart';

// ignore_for_file: must_be_immutable
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  String errorMessage = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          width: SizeUtils.width,
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthError) {
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(content: Text(state.message)),
                // );
              } else if (state is AuthAuthenticated) {
                Navigator.of(context).pushReplacementNamed(Routes.rootScreen);
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                  key: _formKey,
                  child: Container(
                    width: double.maxFinite,
                    padding:
                        EdgeInsets.only(left: 10.h, top: 42.v, right: 10.h),
                    child: Column(children: [
                      Text("EduConnect",
                          style: CustomTextStyles.displayMedium45),
                      SizedBox(height: 35.v),
                      Text(AppLocalizations.of(context)!.translate("login")!,
                          style: CustomTextStyles.titleMediumPoppinsBlack),
                      SizedBox(height: 30.v),
                      Align(
                        alignment:
                            Localizations.localeOf(context).languageCode == 'ar'
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.h),
                          child: Text(
                              AppLocalizations.of(context)!.translate("email")!,
                              style:
                                  CustomTextStyles.titleMediumPoppinsGray900),
                        ),
                      ),
                      SizedBox(height: 5.v),
                      _buildEmail(context),
                      SizedBox(height: 18.v),
                      Align(
                        alignment:
                            Localizations.localeOf(context).languageCode == 'ar'
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.h),
                          child: Text(
                              AppLocalizations.of(context)!
                                  .translate("password")!,
                              style:
                                  CustomTextStyles.titleMediumPoppinsGray900),
                        ),
                      ),
                      SizedBox(height: 5.v),
                      _buildPassword(context),
                      SizedBox(height: 18.v),
                      _buildThirtyNine(context, state),
                      SizedBox(height: 22.v),
                      _buildContinue(context, state),
                      SizedBox(height: 17.v),
                      _buildForty(context),
                      SizedBox(height: 17.v),
                      _buildLoginWithGoogle(context),
                      SizedBox(height: 36.v),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: AppLocalizations.of(context)!
                                  .translate("dont_have_account")!,
                              style:
                                  CustomTextStyles.titleMediumPoppinsff989898,
                            ),
                            TextSpan(text: " "),
                            TextSpan(
                              text: AppLocalizations.of(context)!
                                  .translate("sign_up")!,
                              style:
                                  CustomTextStyles.titleMediumPoppinsff648ddb,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignupScreen()),
                                  );
                                },
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5.v)
                    ]),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildEmail(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.h, right: 15.h),
      child: CustomTextFormField(
        textStyle: TextStyle(
          fontFamily: "Poppins",
          color: AppColors.black900,
          fontWeight: FontWeight.w700,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            setState(() {
              errorMessage = AppLocalizations.of(context)!
                  .translate("email_cant_be_empty")!;
            });
            return null;
          }
          return null;
        },
        borderDecoration: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.gray300,
            width: 1.5,
          ),
        ),
        controller: emailController,
        hintText: AppLocalizations.of(context)!.translate("enter_your_email")!,
        textInputType: TextInputType.emailAddress,
        contentPadding: EdgeInsets.symmetric(horizontal: 21.h, vertical: 15.v),
      ),
    );
  }

  /// Section Widget
  Widget _buildPassword(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.h, right: 15.h),
      child: CustomTextFormField(
        textStyle: TextStyle(
          fontFamily: "Poppins",
          color: AppColors.black900,
          fontWeight: FontWeight.w700,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            setState(() {
              errorMessage = AppLocalizations.of(context)!
                  .translate("password_cant_be_empty")!;
            });
            return null;
          }
          return null;
        },
        borderDecoration: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.gray300,
            width: 1.5,
          ),
        ),
        controller: passwordController,
        hintText:
            AppLocalizations.of(context)!.translate("enter_your_password")!,
        textInputAction: TextInputAction.done,
        suffix: GestureDetector(
          onTap: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(30.h, 18.v, 28.h, 18.v),
            child: CustomImageView(
              imagePath: isPasswordVisible
                  ? ImageConstant.imgFirreyeopen
                  : ImageConstant.imgFirreyecrossed,
              height: 20.adaptSize,
              width: 20.adaptSize,
            ),
          ),
        ),
        suffixConstraints: BoxConstraints(maxHeight: 56.v),
        obscureText: !isPasswordVisible,
        contentPadding: EdgeInsets.symmetric(horizontal: 21.h, vertical: 15.v),
      ),
    );
  }

  Widget _buildThirtyNine(BuildContext context, AuthState state) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.h, 0, 15.h, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          state is AuthError
              ? Text(
                  state.message.contains('Invalid credentials')
                      ? AppLocalizations.of(context)!
                          .translate("wrong_credentials")!
                      : state.message.contains('Server Failure')
                          ? AppLocalizations.of(context)!
                              .translate("server_error")!
                          : state.message,
                  style: CustomTextStyles.titleMediumPoppinsBluegray100)

              // ? Text("Wrong credentials",
              //     style: CustomTextStyles.titleMediumPoppinsBluegray100)
              : errorMessage.isNotEmpty
                  ? Text(errorMessage,
                      style: CustomTextStyles.titleMediumPoppinsBluegray100)
                  : Container(),
          GestureDetector(
            onTap: () {
              onTapTxtForgotPassword(context);
            },
            child: Text(
                AppLocalizations.of(context)!.translate("forgot_password")!,
                style: CustomTextStyles.titleMediumPoppinsPrimary),
          )
        ],
      ),
    );
  }

  Widget _buildContinue(BuildContext context, state) {
    // log(state.toString());

    return CustomElevatedButton(
      onPressed: state is AuthLoading
          ? null
          : () {
              if (emailController.text.isNotEmpty &&
                  passwordController.text.isNotEmpty) {
                setState(() {
                  errorMessage = '';
                });

                if (_formKey.currentState!.validate()) {
                  // Check if the email format is valid
                  if (RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(emailController.text)) {
                    // Check if the password length is valid
                    if (passwordController.text.length >= 6) {
                      context.read<AuthCubit>().login(
                            emailController.text,
                            passwordController.text,
                          );
                    } else {
                      setState(() {
                        errorMessage = AppLocalizations.of(context)!
                            .translate("password_short")!;
                      });
                    }
                  } else {
                    setState(() {
                      errorMessage = AppLocalizations.of(context)!
                          .translate("email_format")!;
                    });
                  }
                }
              } else if (emailController.text.isEmpty ||
                  passwordController.text.isEmpty) {
                setState(() {
                  errorMessage = AppLocalizations.of(context)!
                      .translate("cant_empty_credentials")!;
                });
              }
            },
      buttonStyle: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(AppColors.indigoA300),
      ),
      isLoading: state is AuthLoading,
      text: AppLocalizations.of(context)!.translate("continue")!,
      margin: EdgeInsets.only(left: 10.h, right: 15.h),
      buttonTextStyle: CustomTextStyles.titleMediumPoppins,
    );
  }

  Widget _buildForty(BuildContext context) {
    bool isRtl = Localizations.localeOf(context).languageCode == 'ar';

    return Align(
      alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 55.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 14.v, bottom: 8.v),
              child: SizedBox(
                width: 98.h,
                child: const Divider(),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.h, vertical: 3.v),
                child: Text(AppLocalizations.of(context)!.translate("or")!,
                    style: CustomTextStyles.titleMediumPoppinsGray300)),
            Padding(
              padding: EdgeInsets.only(top: 14.v, bottom: 8.v),
              child: SizedBox(
                width: 98.h,
                child: const Divider(),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildLoginWithGoogle(BuildContext context) {
    return CustomOutlinedButton(
      text: AppLocalizations.of(context)!.translate("login_with_google")!,
      margin: EdgeInsets.only(left: 10.h, right: 15.h),
      buttonStyle: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        side: MaterialStateProperty.all(
          BorderSide(
            color: AppColors.gray300,
            width: 1.5,
          ),
        ),
      ),
      leftIcon: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.h),
        child: CustomImageView(
            imagePath: ImageConstant.imgPngwing2,
            height: 24.adaptSize,
            width: 24.adaptSize),
      ),
    );
  }

  onTapTxtForgotPassword(BuildContext context) {
    if (AppLocalizations.of(context)!.isEnLocale) {
      BlocProvider.of<LocaleCubit>(context).toArabic();
    } else {
      BlocProvider.of<LocaleCubit>(context).toEnglish();
    }
    // Navigator.pushNamed(context, Routes.forgotpasswordRoute);
  }
}
