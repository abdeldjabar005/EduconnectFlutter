import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:educonnect/config/themes/custom_text_style.dart';
import 'package:educonnect/core/utils/app_colors.dart';
import 'package:educonnect/core/utils/image_constant.dart';
import 'package:educonnect/core/utils/size_utils.dart';
import 'package:educonnect/core/widgets/RootScreen.dart';
import 'package:educonnect/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:educonnect/features/auth/presentation/widgets/custom_drop_down.dart';
import 'package:educonnect/features/auth/presentation/widgets/custom_elevated_button.dart';
import 'package:educonnect/features/auth/presentation/widgets/custom_pin_code_text_field.dart';
import 'package:educonnect/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:educonnect/features/posts/presentation/widgets/custom_image_view.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final PageController _pageController = PageController();

  String errorMessage = '';

  TextEditingController firstNameController = TextEditingController();

  TextEditingController lastNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  String selectedRole = '';

  List<String> roleKeys = ["parent", "teacher", "admin"];

  final verificationCode = List<String>.filled(5, '', growable: false);
  final ValueNotifier<bool> isFilledNotifier = ValueNotifier<bool>(false);
  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmpasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();

  bool isPasswordVisible = false;

  // timer for the resend email button

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

  late AuthCubit authCubit;

  @override
  void initState() {
    startTimer();
    authCubit = context.read<AuthCubit>();

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    authCubit.reset();

    super.dispose();
  }

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
              } else if (state is AuthEmailVerificationNeeded) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              } else if (state is AuthEmailVerified) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              } else if (state is AuthAuthenticated) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => RootScreen()),
                  (Route<dynamic> route) => false,
                );
              }
            },
            builder: (context, state) {
              return WillPopScope(
                onWillPop: () async {
                  if (_pageController.page != 0.0) {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                    return false;
                  }
                  return true;
                },
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildFirstPage(context, state),
                    _buildSecondPage(context, state),
                    _buildThirdPage(context, state),
                    _buildFourthPage(context, state),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFirstPage(BuildContext context, AuthState state) {
    bool isRtl = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                    Center(
                      child: Text("EduConnect",
                          style: CustomTextStyles.displayMedium45),
                    ),
                    SizedBox(height: 4.v),
                    Padding(
                      padding: EdgeInsets.only(left: 2.h),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!
                              .translate("registration")!,
                          style: CustomTextStyles.titleMediumPoppinsBlack2,
                        ),
                      ),
                    ),
                    SizedBox(height: 28.v),
                    _buildsteps(context),
                    SizedBox(height: 28.v),
                    _buildFiftyOne(context),
                    SizedBox(height: 16.v),
                    Padding(
                      padding: EdgeInsets.only(left: 3.h),
                      child: Text(
                        AppLocalizations.of(context)!.translate("email")!,
                        style: CustomTextStyles.titleMediumPoppinsGray900,
                      ),
                    ),
                    SizedBox(height: 11.v),
                    _buildEmail(context),
                    SizedBox(height: 16.v),
                    Padding(
                      padding: EdgeInsets.only(left: 3.h),
                      child: Text(
                        AppLocalizations.of(context)!.translate("occupation")!,
                        style: CustomTextStyles.titleMediumPoppinsGray900,
                      ),
                    ),
                    SizedBox(height: 11.v),
                    Padding(
                      padding: EdgeInsets.only(left: 3.h),
                      child: CustomDropDown(
                        value: context.read<AuthCubit>().selectedRole,
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
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 21.h, vertical: 15.v),
                        icon: Container(
                          margin: EdgeInsets.fromLTRB(30.h, 18.v, 9.h, 18.v),
                          child: CustomImageView(
                            imagePath: ImageConstant.imgArrowdown,
                            height: 20.adaptSize,
                            width: 20.adaptSize,
                          ),
                        ),
                        suffix: Container(
                          margin: EdgeInsets.fromLTRB(10.h, 18.v, 12.h, 18.v),
                          child: CustomImageView(
                            imagePath: ImageConstant.imgArrowdown,
                            height: 20.adaptSize,
                            width: 20.adaptSize,
                          ),
                        ),
                        hintText: AppLocalizations.of(context)!
                            .translate("select_role")!,
                        hintStyle: CustomTextStyles.titleMediumPoppinsGray40001,
                        items: roleKeys
                            .map((roleKey) => AppLocalizations.of(context)!
                                .translate(roleKey)!)
                            .toList(),
                        onChanged: (String newValue) {
                          setState(() {
                            String englishRole = roleKeys.firstWhere(
                                (roleKey) =>
                                    AppLocalizations.of(context)!
                                        .translate(roleKey)! ==
                                    newValue);
                            context.read<AuthCubit>().selectedRole =
                                englishRole;
                            selectedRole = englishRole;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 45.v),
                    _buildNextStep(context, state),
                    SizedBox(height: 8.v),
                    _buildError(context, state),
                    SizedBox(height: 8.v),
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
              child: const Icon(Icons.arrow_back_sharp, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondPage(BuildContext context, AuthState state) {
    bool isRtl = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Form(
              key: _formKey2,
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
                    Center(
                      child: Text("EduConnect",
                          style: CustomTextStyles.displayMedium45),
                    ),
                    SizedBox(height: 4.v),
                    Padding(
                      padding: EdgeInsets.only(left: 15.h),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!
                              .translate("registration")!,
                          textAlign: TextAlign.center,
                          style: CustomTextStyles.titleMediumPoppinsBlack2,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.v),
                    _buildsteps2(context),
                    SizedBox(height: 16.v),
                    Padding(
                      padding: EdgeInsets.only(left: 3.h),
                      child: Text(
                        AppLocalizations.of(context)!.translate("password")!,
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
          Positioned(
            top: 15.0,
            left: isRtl ? null : 11.0,
            right: isRtl ? 11.0 : null,
            child: FloatingActionButton(
              mini: true,
              onPressed: () {
                if (_pageController.page != 0.0) {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                } else {
                  Navigator.of(context).pop();
                }
              },
              backgroundColor: AppColors.black900.withOpacity(0.1),
              elevation: 0.0,
              child: const Icon(Icons.arrow_back_sharp, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThirdPage(BuildContext context, AuthState state) {
    bool isRtl = Localizations.localeOf(context).languageCode == 'ar';

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey3,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
            horizontal: 24.h,
            vertical: 15.v,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child:
                    Text("EduConnect", style: CustomTextStyles.displayMedium45),
              ),
              SizedBox(height: 28.v),
              _buildsteps3(context),
              SizedBox(height: 28.v),
              Align(
                alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
                child: Text(
                    AppLocalizations.of(context)!.translate("check_email")!,
                    style: CustomTextStyles.titleMediumPoppinsBlack2),
              ),
              SizedBox(height: 10.v),
              Align(
                alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
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
                        text: emailController.text,
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
                        ? AppLocalizations.of(context)!.translate("enter_code")!
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
                                      decoration: TextDecoration.underline),
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
                                    .resendEmail(emailController.text);
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
                                    borderRadius: BorderRadius.circular(20),
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
                                      decoration: TextDecoration.underline),
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
    );
  }

  Widget _buildFourthPage(BuildContext context, AuthState state) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(
          horizontal: 24.h,
          vertical: 15.v,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 110.v),
            Center(
              child: Container(
                height: 114.v,
                width: 114.v,
                decoration: BoxDecoration(
                  color: AppColors.indigoA100,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.indigoA300, width: 3),
                ),
                child: CircleAvatar(
                  backgroundColor: AppColors.indigoA100,
                  child: const Icon(
                      size: 35,
                      FontAwesomeIcons.check,
                      color: Color(0XFF648DDB)),
                ),
              ),
            ),
            SizedBox(height: 40.v),
            Center(
              child: Text(
                AppLocalizations.of(context)!.translate("success")!,
                style: CustomTextStyles.titleMediumPoppinsBlack2,
              ),
            ),
            SizedBox(height: 30.v),
            Padding(
              padding: EdgeInsets.only(left: 3.h),
              child: Text(
                AppLocalizations.of(context)!.translate("welcome")!,
                style: CustomTextStyles.bodyMediumRobotoGray2,
              ),
            ),
            SizedBox(height: 30.v),
            _buildContinue2(context, state),
          ],
        ),
      ),
    );
  }

  Widget _buildsteps(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 40.v,
          width: 40.v,
          child: CircleAvatar(
            backgroundColor: AppColors.indigoA400,
            child: Text(
              "1",
              style: CustomTextStyles.titleMediumPoppins,
            ),
          ),
        ),
        SizedBox(width: 10.h),
        Padding(
          padding: EdgeInsets.all(10.v),
          child: SizedBox(
            width: 70.h,
            child: const Divider(
              color: Color(0XFFE1E1E1),
              // height: 2,
              thickness: 5,
            ),
          ),
        ),
        SizedBox(width: 10.h),
        Container(
          height: 40.v,
          width: 40.v,
          child: CircleAvatar(
            backgroundColor: AppColors.gray250,
            child: Text(
              "2",
              style: CustomTextStyles.titleMediumPoppinsgray600,
            ),
          ),
        ),
        SizedBox(width: 10.h),
        Padding(
          padding: EdgeInsets.all(10.v),
          child: SizedBox(
            width: 70.h,
            child: const Divider(
              color: Color(0XFFE1E1E1),
              // height: 2,
              thickness: 5,
            ),
          ),
        ),
        SizedBox(width: 10.h),
        Container(
          height: 40.v,
          width: 40.v,
          child: CircleAvatar(
            backgroundColor: AppColors.gray250,
            child: Text(
              "3",
              style: CustomTextStyles.titleMediumPoppinsgray600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildsteps2(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 40.v,
          width: 40.v,
          child: CircleAvatar(
            backgroundColor: AppColors.indigoA400,
            child: const Icon(FontAwesomeIcons.check, color: Color(0XFFF5F5F5)),
          ),
        ),
        SizedBox(width: 10.h),
        Padding(
          padding: EdgeInsets.all(10.v),
          child: SizedBox(
            width: 70.h,
            child: const Divider(
              color: Color(0XFF6F7DFF),
              // height: 2,
              thickness: 5,
            ),
          ),
        ),
        SizedBox(width: 10.h),
        Container(
          height: 40.v,
          width: 40.v,
          child: CircleAvatar(
            backgroundColor: AppColors.indigoA200,
            child: Text(
              "2",
              style: CustomTextStyles.titleMediumPoppins,
            ),
          ),
        ),
        SizedBox(width: 10.h),
        Padding(
          padding: EdgeInsets.all(10.v),
          child: SizedBox(
            width: 70.h,
            child: const Divider(
              color: Color(0XFFE1E1E1),
              // height: 2,
              thickness: 5,
            ),
          ),
        ),
        SizedBox(width: 10.h),
        Container(
          height: 40.v,
          width: 40.v,
          child: CircleAvatar(
            backgroundColor: AppColors.gray250,
            child: Text(
              "3",
              style: CustomTextStyles.titleMediumPoppinsgray600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildsteps3(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 40.v,
          width: 40.v,
          child: CircleAvatar(
            backgroundColor: AppColors.indigoA400,
            child: const Icon(FontAwesomeIcons.check, color: Color(0XFFF5F5F5)),
          ),
        ),
        SizedBox(width: 10.h),
        Padding(
          padding: EdgeInsets.all(10.v),
          child: SizedBox(
            width: 70.h,
            child: const Divider(
              color: Color(0XFF6F7DFF),
              // height: 2,
              thickness: 5,
            ),
          ),
        ),
        SizedBox(width: 10.h),
        Container(
          height: 40.v,
          width: 40.v,
          child: CircleAvatar(
            backgroundColor: AppColors.indigoA400,
            child: const Icon(FontAwesomeIcons.check, color: Color(0XFFF5F5F5)),
          ),
        ),
        SizedBox(width: 10.h),
        Padding(
          padding: EdgeInsets.all(10.v),
          child: SizedBox(
            width: 70.h,
            child: const Divider(
              color: Color(0XFF6F7DFF),
              // height: 2,
              thickness: 5,
            ),
          ),
        ),
        SizedBox(width: 10.h),
        Container(
          height: 40.v,
          width: 40.v,
          child: CircleAvatar(
            backgroundColor: AppColors.indigoA200,
            child: Text(
              "3",
              style: CustomTextStyles.titleMediumPoppins,
            ),
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildName(
      BuildContext context, String text, TextEditingController controller) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: 1.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: CustomTextStyles.titleMediumPoppinsGray900,
            ),
            SizedBox(height: 12.v),
            CustomTextFormField(
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
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 21.h, vertical: 15.v),
              textInputType: TextInputType.name,
              width: 200.h,
              controller: controller,
              hintText: text,
            ),
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildFiftyOne(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildName(
              context,
              AppLocalizations.of(context)!.translate("first_name")!,
              firstNameController),
          Container(
            width: 23.v,
          ),
          _buildName(
              context,
              AppLocalizations.of(context)!.translate("last_name")!,
              lastNameController),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildEmail(BuildContext context) {
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
        contentPadding: EdgeInsets.symmetric(horizontal: 21.h, vertical: 15.v),
        controller: emailController,
        hintText: AppLocalizations.of(context)!.translate("enter_your_email")!,
        textInputType: TextInputType.emailAddress,
      ),
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

  Widget _buildNextStep(BuildContext context, AuthState state) {
    return CustomElevatedButton(
      onPressed: state is AuthLoading
          ? null
          : () {
              if (firstNameController.text.isNotEmpty &&
                  lastNameController.text.isNotEmpty &&
                  emailController.text.isNotEmpty &&
                  selectedRole.isNotEmpty) {
                setState(() {
                  errorMessage = '';
                });

                if (_formKey.currentState!.validate()) {
                  // Check if the email format is valid
                  if (RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(emailController.text)) {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  } else {
                    setState(() {
                      errorMessage = AppLocalizations.of(context)!
                          .translate("email_format")!;
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
      isLoading: state is AuthLoading,
      text: AppLocalizations.of(context)!.translate("next_step")!,
      margin: EdgeInsets.only(left: 2.h, right: 2.h),
      buttonTextStyle: CustomTextStyles.titleMediumPoppins,
    );
  }

  Widget _buildContinue(BuildContext context, state) {
    return CustomElevatedButton(
      onPressed: state is AuthLoading
          ? null
          : () {
              if (passwordController.text.isNotEmpty &&
                  confirmpasswordController.text.isNotEmpty) {
                setState(() {
                  errorMessage = '';
                });

                if (_formKey2.currentState!.validate()) {
                  // Check if the password length is valid
                  if (passwordController.text.length >= 6) {
                    // Check if the passwords match
                    if (passwordController.text ==
                        confirmpasswordController.text) {
                      context.read<AuthCubit>().signUp(
                            firstNameController.text,
                            lastNameController.text,
                            selectedRole,
                            emailController.text,
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
      isLoading: state is AuthLoading,
      text: AppLocalizations.of(context)!.translate("continue")!,
      margin: EdgeInsets.only(left: 2.h, right: 2.h),
      buttonTextStyle: CustomTextStyles.titleMediumPoppins,
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
                  if (_formKey3.currentState!.validate()) {
                    final code = verificationCode.join();
                    context
                        .read<AuthCubit>()
                        .verifyEmail(emailController.text, code);
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

  Widget _buildContinue2(BuildContext context, state) {
    return CustomElevatedButton(
      onPressed: state is AuthLoading
          ? null
          : () {
              context.read<AuthCubit>().emitAuthenticated();
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

  Widget _buildError(BuildContext context, AuthState state) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.h, 0, 15.h, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          state is AuthError
              ? Text(
                  state.message.contains('Server Failure')
                      ? AppLocalizations.of(context)!.translate("server_error")!
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
}
