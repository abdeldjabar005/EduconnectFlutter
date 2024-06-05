import 'dart:developer';

import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:educonnect/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:educonnect/config/themes/custom_text_style.dart';
import 'package:educonnect/core/utils/app_colors.dart';
import 'package:educonnect/core/utils/image_constant.dart';
import 'package:educonnect/core/utils/size_utils.dart';
import 'package:educonnect/core/widgets/custom_bottom_bar.dart';
import 'package:educonnect/features/auth/presentation/widgets/custom_drop_down.dart';
import 'package:educonnect/features/auth/presentation/widgets/custom_elevated_button.dart';
import 'package:educonnect/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:educonnect/features/posts/presentation/widgets/custom_image_view.dart';
import 'package:educonnect/features/profile/data/models/child_model.dart';
import 'package:educonnect/features/profile/presentation/cubit/children_cubit.dart';
import 'package:educonnect/injection_container.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key})
      : super(
          key: key,
        );

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  String errorMessage = '';
  @override
  void dispose() {
    errorMessage = '';
    super.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController oldpasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context2) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        log(state.toString());
        if (state is ProfilePasswordUpdated) {
          Navigator.maybePop(context2);
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: WillPopScope(
            onWillPop: () async {
              return true;
            },
            child: Scaffold(
              backgroundColor: AppColors.gray200,
              appBar: AppBar(
                leading: BackButton(
                  color: AppColors.black900,
                ),
                backgroundColor: AppColors.whiteA700,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  AppLocalizations.of(context)!.translate('change_password')!,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: AppColors.black900,
                    fontWeight: FontWeight.w400,
                    fontSize: 18.v,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Form(
                  key: _formKey,
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.h,
                      vertical: 15.v,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 45.v,
                        ),
                        SizedBox(height: 16.v),
                        Padding(
                          padding: EdgeInsets.only(left: 3.h),
                          child: Text(
                            AppLocalizations.of(context)!
                                .translate("old_password")!,
                            style: CustomTextStyles.titleMediumPoppinsGray900,
                          ),
                        ),
                        SizedBox(height: 11.v),
                        _buildPassword(
                            context,
                            AppLocalizations.of(context)!
                                .translate("enter_old_password")!,
                            oldpasswordController),
                        SizedBox(height: 16.v),
                        Padding(
                          padding: EdgeInsets.only(left: 3.h),
                          child: Text(
                            AppLocalizations.of(context)!
                                .translate("new_password2")!,
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
                        SizedBox(height: 30.v),
                        _buildContinue(context, state),
                        SizedBox(height: 8.v),
                        _buildError(context, state),
                        SizedBox(height: 8.v),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Section Widget
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

  Widget _buildContinue(BuildContext context, state) {
    return CustomElevatedButton(
      onPressed: state is ProfileLoading
          ? null
          : () {
              if (passwordController.text.isNotEmpty &&
                  oldpasswordController.text.isNotEmpty &&
                  confirmpasswordController.text.isNotEmpty) {
                setState(() {
                  errorMessage = '';
                });

                if (_formKey.currentState!.validate()) {
                  // Check if the password length is valid
                  if (passwordController.text.length >= 6 &&
                      oldpasswordController.text.length >= 6) {
                    // Check if the passwords match
                    if (passwordController.text ==
                        confirmpasswordController.text) {
                      context.read<ProfileCubit>().changePassword(
                            oldpasswordController.text,
                            passwordController.text,
                            confirmpasswordController.text,
                          );
                    } else {
                      setState(() {
                        errorMessage = AppLocalizations.of(context)!
                            .translate("password_match")!;
                      });
                    }
                  } else {
                    setState(() {
                      errorMessage = AppLocalizations.of(context)!
                          .translate("password_short")!;
                    });
                  }
                }
              } else {
                setState(() {
                  errorMessage = AppLocalizations.of(context)!
                      .translate("fill_all_fields")!;
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
      isLoading: state is ProfileLoading,
      text: AppLocalizations.of(context)!.translate("continue")!,
      margin: EdgeInsets.only(left: 2.h, right: 2.h),
      buttonTextStyle: CustomTextStyles.titleMediumPoppins,
    );
  }

  Widget _buildError(BuildContext context, ProfileState state) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.h, 0, 15.h, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          state is ProfileError
              ? Text(
                  state.message.contains('Server Failure')
                      ? AppLocalizations.of(context)!.translate('server_error')!
                      : state.message.contains('old password is wrong')
                          ? AppLocalizations.of(context)!
                              .translate('old_password_wrong')!
                          : state.message,
                  style: CustomTextStyles.titleMediumPoppinsBluegray100)
              : Text(errorMessage,
                  style: CustomTextStyles.titleMediumPoppinsBluegray100)
        ],
      ),
    );
  }
}
