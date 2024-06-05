import 'dart:async';

import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:educonnect/config/themes/custom_text_style.dart';
import 'package:educonnect/core/utils/app_colors.dart';
import 'package:educonnect/core/utils/size_utils.dart';
import 'package:educonnect/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:educonnect/features/auth/presentation/pages/forgot_password/reset_password.dart';
import 'package:educonnect/features/auth/presentation/widgets/custom_elevated_button.dart';
import 'package:educonnect/features/auth/presentation/widgets/custom_pin_code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckEmail extends StatefulWidget {
  final String email;

  CheckEmail({Key? key, required this.email}) : super(key: key);

  @override
  State<CheckEmail> createState() => _CheckEmailState();
}

class _CheckEmailState extends State<CheckEmail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final verificationCode = List<String>.filled(5, '', growable: false);

  final ValueNotifier<bool> isFilledNotifier = ValueNotifier<bool>(false);

  String errorMessage = '';

  late Timer _timer;

  int _start = 180;

  bool _isClickable = false;

  void startTimer() {
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
            _isClickable = true;
          } else {
            _start--;
          }
        },
      ),
    );
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isRtl = Localizations.localeOf(context).languageCode == 'ar';

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text(state.message)),
          // );
        } else if (state is AuthEmailVerified) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => ResetPassword(),
              ),
              (route) => false);
        }
      },
      builder: (context, state) {
        return Scaffold(
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
                  vertical: 60.v,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50.v),
                    Align(
                      alignment:
                          isRtl ? Alignment.centerRight : Alignment.centerLeft,
                      child: Text(
                          AppLocalizations.of(context)!
                              .translate("check_email")!,
                          style: CustomTextStyles.titleMediumPoppinsBlack2),
                    ),
                    SizedBox(height: 10.v),
                    Align(
                      alignment:
                          isRtl ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        width: 333.h,
                        margin: isRtl
                            ? EdgeInsets.only(left: 45.h)
                            : EdgeInsets.only(right: 45.h),
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: AppLocalizations.of(context)!
                                  .translate("code_sent")!,
                              style: CustomTextStyles.titleMediumff989898,
                            ),
                            TextSpan(
                              text: widget.email,
                              style: CustomTextStyles.titleMediumff545454
                                  .copyWith(height: 1.25),
                            ),
                            TextSpan(
                              text: AppLocalizations.of(context)!
                                  .translate("code_enter")!,
                              style: CustomTextStyles.titleMediumff989898,
                            ),
                          ]),
                          textAlign: isRtl ? TextAlign.right : TextAlign.left,
                        ),
                      ),
                    ),
                    SizedBox(height: 34.v),
                    Padding(
                      padding: EdgeInsets.only(right: 1.h),
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: CustomPinCodeTextField(
                          validator: (value) => value!.isEmpty
                              ? AppLocalizations.of(context)!
                                  .translate("enter_code")!
                              : null,
                          context: context,
                          onChanged: (value) {
                            for (int i = 0; i < value.length; i++) {
                              verificationCode[i] = value[i];
                            }
                            isFilledNotifier.value = value.length == 5;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 26.v),
                    _buildVerifyCodeButton(context, state),
                    SizedBox(height: 8.v),
                    _buildErrorCode(context, state),
                    SizedBox(height: 8.v),
                    SizedBox(height: 38.v),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text:
                              "${AppLocalizations.of(context)!.translate("no_email_recieved")!} \n",
                          style: CustomTextStyles.titleMediumff545454,
                        ),
                        TextSpan(text: " "),
                        _start > 0
                            ? WidgetSpan(
                                child: GestureDetector(
                                  onTap: null,
                                  child: Text(
                                    "${AppLocalizations.of(context)!.translate("resend_code")!} (${_start ~/ 60}:${(_start % 60).toString().padLeft(2, '0')})",
                                    style: CustomTextStyles.titleMediumff989898
                                        .copyWith(
                                            decoration:
                                                TextDecoration.underline),
                                  ),
                                ),
                              )
                            : WidgetSpan(
                                child: GestureDetector(
                                  onTap: () {
                                    if (_isClickable) {
                                      setState(() {
                                        _isClickable = false;
                                        _start = 180;
                                      });
                                      startTimer();
                                      context
                                          .read<AuthCubit>()
                                          .resendEmail(widget.email);
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          AppLocalizations.of(context)!
                                              .translate("email_resent")!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        backgroundColor: AppColors.indigoA300,
                                        duration: Duration(seconds: 2),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .translate("resend_email")!,
                                    style: CustomTextStyles.titleMediumff648ddb
                                        .copyWith(
                                            decoration:
                                                TextDecoration.underline),
                                  ),
                                ),
                              ),
                      ]),
                      textAlign: isRtl ? TextAlign.right : TextAlign.left,
                    ),
                    SizedBox(height: 5.v),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVerifyCodeButton(BuildContext context, AuthState state) {
    return ValueListenableBuilder<bool>(
      valueListenable: isFilledNotifier,
      builder: (context, isFilled, child) {
        return CustomElevatedButton(
          onPressed: state is AuthLoading || !isFilled
              ? null
              : () {
                  if (_formKey.currentState!.validate()) {
                    final code = verificationCode.join();
                    context.read<AuthCubit>().validateOtp(code);
                    // _pageController.nextPage(
                    //   duration: Duration(milliseconds: 300),
                    //   curve: Curves.easeIn,
                    // );
                  }
                },
          buttonStyle: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            splashFactory: NoSplash.splashFactory,
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled) || !isFilled) {
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
          text: AppLocalizations.of(context)!.translate("verify_code")!,
          margin: EdgeInsets.only(left: 6.h, right: 6.h),
          buttonTextStyle: CustomTextStyles.titleMediumPoppins,
        );
      },
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
                      : state.message.contains('Invalid code')
                          ? AppLocalizations.of(context)!
                              .translate("wrong_code")!
                          : state.message,
                  style: CustomTextStyles.titleMediumPoppinsBluegray100)
              : Text(errorMessage,
                  style: CustomTextStyles.titleMediumPoppinsBluegray100)
        ],
      ),
    );
  }
}
