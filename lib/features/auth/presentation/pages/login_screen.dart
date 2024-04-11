import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes/config/routes/app_routes.dart';
import 'package:quotes/config/themes/custom_text_style.dart';
import 'package:quotes/core/utils/app_colors.dart';
import 'package:quotes/core/utils/image_constant.dart';
import 'package:quotes/core/utils/size_utils.dart';
import 'package:quotes/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:quotes/features/auth/presentation/pages/signup_screen.dart';
import 'package:quotes/features/auth/presentation/widgets/custom_elevated_button.dart';
import 'package:quotes/features/auth/presentation/widgets/custom_outlined_button.dart';
import 'package:quotes/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:quotes/features/posts/presentation/widgets/custom_image_view.dart';

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
                      Text("Login",
                          style: CustomTextStyles.titleMediumPoppinsBlack),
                      SizedBox(height: 30.v),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.h),
                          child: Text("Your Email",
                              style:
                                  CustomTextStyles.titleMediumPoppinsGray900),
                        ),
                      ),
                      SizedBox(height: 5.v),
                      _buildEmail(context),
                      SizedBox(height: 18.v),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.h),
                          child: Text("Password",
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
                              text: "Don’t have an account?",
                              style:
                                  CustomTextStyles.titleMediumPoppinsff989898,
                            ),
                            TextSpan(text: " "),
                            TextSpan(
                              text: "Sign up",
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
            // Set the error message instead of returning it
            setState(() {
              errorMessage = "Email cannot be empty";
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
        hintText: "Enter your email",
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
              errorMessage = "Password cannot be empty";
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
        hintText: "Enter your password",
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
                      ? "Wrong credentials"
                      : state.message.contains('Server Failure')
                          ? "Server error"
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
            child: Text("Forgot password?",
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
                        errorMessage = 'Password is too short';
                      });
                    }
                  } else {
                    setState(() {
                      errorMessage = 'Invalid email format';
                    });
                  }
                }
              } else if (emailController.text.isEmpty ||
                  passwordController.text.isEmpty) {
                setState(() {
                  errorMessage = 'credentials can\'t be empty';
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
      text: "Continue",
      margin: EdgeInsets.only(left: 10.h, right: 15.h),
      buttonTextStyle: CustomTextStyles.titleMediumPoppins,
    );
  }

  /// Section Widget
  Widget _buildForty(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 35.h, right: 15.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
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
                child: Text("Or ",
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
      text: "Login with Google",
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
        margin: EdgeInsets.only(right: 8.h),
        child: CustomImageView(
            imagePath: ImageConstant.imgPngwing2,
            height: 24.adaptSize,
            width: 24.adaptSize),
      ),
    );
  }

  /// Navigates to the forgotpasswordScreen when the action is triggered.
  onTapTxtForgotPassword(BuildContext context) {
    Navigator.pushNamed(context, Routes.forgotpasswordRoute);
  }
}
