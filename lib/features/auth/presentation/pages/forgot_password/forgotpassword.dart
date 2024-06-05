import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:educonnect/config/themes/app_theme.dart';
import 'package:educonnect/config/themes/custom_text_style.dart';
import 'package:educonnect/config/themes/theme_helper.dart';
import 'package:educonnect/core/utils/app_colors.dart';
import 'package:educonnect/core/utils/size_utils.dart';
import 'package:educonnect/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:educonnect/features/auth/presentation/pages/forgot_password/check_email.dart';
import 'package:educonnect/features/auth/presentation/widgets/custom_elevated_button.dart';
import 'package:educonnect/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String errormessage2 = '';
  late AuthCubit authCubit;

  @override
  void initState() {
    super.initState();
    authCubit = context.read<AuthCubit>();
  }

  @override
  void dispose() {
    authCubit.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isRtl = Localizations.localeOf(context).languageCode == 'ar';

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text(state.message),
          //     backgroundColor: AppColors.red400,
          //   ),
          // );
        } else if (state is AuthCodeSent) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => CheckEmail(
                  email: emailController.text,
                ),
              ),
              (route) => false);
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
                          SizedBox(height: 80.h),
                          Align(
                            alignment:
                                Localizations.localeOf(context).languageCode ==
                                        'ar'
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 10.h, left: 10.h, right: 10.h),
                              child: Text(
                                  // AppLocalizations.of(context)!.translate("email")!,
                                  AppLocalizations.of(context)!.translate("forgot_password")!,
                                  style: CustomTextStyles
                                      .titleMediumPoppinsBlack2),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Align(
                            alignment:
                                Localizations.localeOf(context).languageCode ==
                                        'ar'
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.h),
                              child: Text(
                                  // AppLocalizations.of(context)!.translate("email")!,
                                  AppLocalizations.of(context)!.translate("enter_email_to_reset")!,
                                  // 'Enter your email to reset your password',
                                  style: CustomTextStyles
                                      .titleMediumPoppinsGray3002),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Align(
                            alignment:
                                Localizations.localeOf(context).languageCode ==
                                        'ar'
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.h),
                              child: Text(
                                  AppLocalizations.of(context)!
                                      .translate("email")!,
                                  style: CustomTextStyles
                                      .titleMediumPoppinsGray900),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
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
                                    errormessage2 =
                                        AppLocalizations.of(context)!
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
                              hintText: AppLocalizations.of(context)!
                                  .translate("enter_your_email")!,
                              textInputType: TextInputType.emailAddress,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 21.h, vertical: 15.v),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          _buildErrorCode(context, state),
                          const SizedBox(
                            height: 20,
                          ),
                          _buildVerifyCodeButton(context, state)
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
      onPressed: state is AuthLoading
          ? null
          : () {
              if (emailController.text.isNotEmpty) {
                setState(() {
                  errormessage2 = '';
                });

                if (formKey.currentState!.validate()) {
                  // Check if the email format is valid
                  if (RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(emailController.text)) {
                    context
                        .read<AuthCubit>()
                        .forgotPassword(emailController.text);
                  } else {
                    setState(() {
                      errormessage2 = AppLocalizations.of(context)!
                          .translate("email_format")!;
                    });
                  }
                }
              } else {
                setState(() {
                  errormessage2 = AppLocalizations.of(context)!
                      .translate("fill_text_fields")!;
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
      margin: EdgeInsets.only(left: 2.h, right: 2.h),
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
                      : state.message.contains('Email does not exist')
                          ? AppLocalizations.of(context)!
                              .translate("email_doesnt_exists")!
                          : state.message,
                  style: CustomTextStyles.titleMediumPoppinsBluegray100)
              : Text(errormessage2,
                  style: CustomTextStyles.titleMediumPoppinsBluegray100)
        ],
      ),
    );
  }
}
