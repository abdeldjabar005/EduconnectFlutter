import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:educonnect/config/themes/app_theme.dart';
import 'package:educonnect/config/themes/custom_text_style.dart';
import 'package:educonnect/config/themes/theme_helper.dart';
import 'package:educonnect/core/utils/app_colors.dart';
import 'package:educonnect/core/utils/image_constant.dart';
import 'package:educonnect/core/utils/size_utils.dart';
import 'package:educonnect/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:educonnect/features/auth/presentation/pages/forgot_password/success.dart';
import 'package:educonnect/features/auth/presentation/widgets/custom_elevated_button.dart';
import 'package:educonnect/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:educonnect/features/posts/presentation/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmpasswordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;

  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    bool isRtl = Localizations.localeOf(context).languageCode == 'ar';

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {

        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.red400,
            ),
          );
        } else if (state is AuthPasswordReset) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => Success(),
              )
            , (route) => false);
        }

      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.whiteA700,
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Set a new password',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Create a new password, Ensure it is different from your previous password for security reasons',
                            style: CustomTextStyles.titleMediumPoppinsGray900,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(height: 16.v),
                          Padding(
                            padding: EdgeInsets.only(left: 3.h),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate("password")!,
                              style: CustomTextStyles.titleMediumPoppinsGray900,
                            ),
                          ),
                          SizedBox(height: 11.v),
                          _buildPassword(
                              context,
                              AppLocalizations.of(context)!
                                  .translate("enter_your_password")!,
                              passwordController),
                          SizedBox(height: 16.v),
                          Padding(
                            padding: EdgeInsets.only(left: 3.h),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate("confirm_password")!,
                              style: CustomTextStyles.titleMediumPoppinsGray900,
                            ),
                          ),
                          SizedBox(height: 11.v),
                          _buildPassword(
                              context,
                              AppLocalizations.of(context)!
                                  .translate("confirm_password")!,
                              confirmpasswordController),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomElevatedButton(
                            text: "Update Password",
                            buttonStyle: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.indigoA100,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.h),
                              ),
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                // BlocProvider.of<AuthCubit>(context)
                                //     .forgotPassword(emailController.text);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 15.0,
                  left: isRtl ? null : 11.0,
                  right: isRtl ? 11.0 : null,
                  child: FloatingActionButton(
                    mini: true,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    backgroundColor: AppColors.black900.withOpacity(0.1),
                    elevation: 0.0,
                    child:
                        const Icon(Icons.arrow_back_sharp, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVerifyCodeButton(BuildContext context, AuthState state) {
    return CustomElevatedButton(
      onPressed: state is AuthLoading ||
              passwordController.text.isEmpty ||
              confirmpasswordController.text.isEmpty
          ? null
          : () {
              if (formKey.currentState!.validate()) {
                context.read<AuthCubit>().resetPassword(
                    passwordController.text, confirmpasswordController.text);
              }
            },
      buttonStyle: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        splashFactory: NoSplash.splashFactory,
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled) ||
                passwordController.text.isEmpty ||
                confirmpasswordController.text.isEmpty) {
              return AppColors.indigoA300.withOpacity(0.4);
            }
            return AppColors.indigoA300;
          },
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      isLoading: state is AuthLoading,
      text: AppLocalizations.of(context)!.translate("continue")!,
      margin: EdgeInsets.only(left: 6.h, right: 6.h),
      buttonTextStyle: CustomTextStyles.titleMediumPoppins,
    );
  }

  Widget _buildErrorCode(BuildContext context, AuthState state) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.h, 0, 15.h, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          state is AuthError
              ? Text(
                  state.message.contains('Server Failure')
                      ? AppLocalizations.of(context)!.translate("wrong_code")!
                      : state.message.contains('Email already exists')
                          ? AppLocalizations.of(context)!
                              .translate("email_exists")!
                          : state.message,
                  style: CustomTextStyles.titleMediumPoppinsBluegray100)
              : Text(errorMessage,
                  style: CustomTextStyles.titleMediumPoppinsBluegray100)
        ],
      ),
    );
  }

  Widget _buildPassword(
      BuildContext context, String hint, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(left: 3.h),
      child: CustomTextFormField(
        textStyle: TextStyle(
          fontFamily: "Poppins",
          color: AppColors.black900,
          fontWeight: FontWeight.w700,
        ),
        borderDecoration: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.gray300,
            width: 1.5,
          ),
        ),
        suffix: GestureDetector(
          onTap: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(10.h, 18.v, 16.h, 18.v),
            child: CustomImageView(
              imagePath: isPasswordVisible
                  ? ImageConstant.imgFirreyeopen
                  : ImageConstant.imgFirreyecrossed,
              height: 20.adaptSize,
              width: 20.adaptSize,
            ),
          ),
        ),
        hintStyle: CustomTextStyles.titleMediumPoppinsGray40001,
        suffixConstraints: BoxConstraints(maxHeight: 56.v),
        obscureText: !isPasswordVisible,
        contentPadding: EdgeInsets.symmetric(horizontal: 21.h, vertical: 15.v),
        controller: controller,
        hintText: hint,
        textInputType: TextInputType.visiblePassword,
      ),
    );
  }
}
