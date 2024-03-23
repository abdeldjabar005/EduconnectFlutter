import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quotes/config/routes/app_routes.dart';
import 'package:quotes/config/themes/app_decoration.dart';
import 'package:quotes/config/themes/custom_text_style.dart';
import 'package:quotes/config/themes/theme_helper.dart';
import 'package:quotes/core/utils/app_colors.dart';
import 'package:quotes/core/utils/image_constant.dart';
import 'package:quotes/core/utils/size_utils.dart';
import 'package:quotes/core/widgets/RootScreen.dart';
import 'package:quotes/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:quotes/features/auth/presentation/pages/login_screen.dart';
import 'package:quotes/features/auth/presentation/widgets/custom_drop_down.dart';
import 'package:quotes/features/auth/presentation/widgets/custom_elevated_button.dart';
import 'package:quotes/features/auth/presentation/widgets/custom_pin_code_text_field.dart';
import 'package:quotes/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:quotes/features/posts/presentation/widgets/custom_image_view.dart';

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

  List<String> role = [
    "parent",
    "teacher",
    "admin",
  ];
  final verificationCode = List<String>.filled(5, '', growable: false);
  final ValueNotifier<bool> isFilledNotifier = ValueNotifier<bool>(false);
  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmpasswordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();

  bool isPasswordVisible = false;

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
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              } else if (state is AuthEmailVerified) {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
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
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                    return false; // Prevents the route from being popped
                  }
                  return true; // Allows the route to be popped
                },
                child: PageView(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
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
    return SingleChildScrollView(
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
              Center(
                child:
                    Text("EduConnect", style: CustomTextStyles.displayMedium45),
              ),
              SizedBox(height: 4.v),
              Padding(
                padding: EdgeInsets.only(left: 2.h),
                child: Center(
                  child: Text(
                    "Registration",
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
                  "Email",
                  style: CustomTextStyles.titleMediumPoppinsGray900,
                ),
              ),
              SizedBox(height: 11.v),
              _buildEmail(context),
              SizedBox(height: 16.v),
              Padding(
                padding: EdgeInsets.only(left: 3.h),
                child: Text(
                  "Occupation",
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
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 21.h, vertical: 15.v),
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
                  hintText: "Select your role",
                  hintStyle: CustomTextStyles.titleMediumPoppinsGray40001,
                  items: role,
                  onChanged: (String newValue) {
                    setState(() {
                      context.read<AuthCubit>().selectedRole = newValue;

                      selectedRole = newValue;
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
    );
  }

  Widget _buildSecondPage(BuildContext context, AuthState state) {
    return SingleChildScrollView(
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
              Center(
                child:
                    Text("EduConnect", style: CustomTextStyles.displayMedium45),
              ),
              SizedBox(height: 4.v),
              Padding(
                padding: EdgeInsets.only(left: 2.h),
                child: Text(
                  "Registration",
                  style: CustomTextStyles.titleMediumPoppinsBlack2,
                ),
              ),
              SizedBox(height: 16.v),
              _buildsteps2(context),
              SizedBox(height: 16.v),
              Padding(
                padding: EdgeInsets.only(left: 3.h),
                child: Text(
                  "Password",
                  style: CustomTextStyles.titleMediumPoppinsGray900,
                ),
              ),
              SizedBox(height: 11.v),
              _buildPassword(context, "Enter Password", passwordController),
              SizedBox(height: 16.v),
              Padding(
                padding: EdgeInsets.only(left: 3.h),
                child: Text(
                  "Confirm Password",
                  style: CustomTextStyles.titleMediumPoppinsGray900,
                ),
              ),
              SizedBox(height: 11.v),
              _buildPassword(
                  context, "Confirm Password", confirmpasswordController),
              SizedBox(height: 30.v),
              _buildContinue(context, state),
              SizedBox(height: 8.v),
              _buildError(context, state),
              SizedBox(height: 8.v),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThirdPage(BuildContext context, AuthState state) {
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
                alignment: Alignment.centerLeft,
                child: Text("Check your email",
                    style: CustomTextStyles.titleMediumPoppinsBlack2),
              ),
              SizedBox(height: 10.v),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 333.h,
                  margin: EdgeInsets.only(right: 45.h),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: "We sent a verification code to ",
                        style: CustomTextStyles.titleMediumff989898,
                      ),
                      TextSpan(
                        text: emailController.text,
                        style: CustomTextStyles.titleMediumff545454
                            .copyWith(height: 1.25),
                      ),
                      TextSpan(
                        text: ". Please enter the code below.",
                        style: CustomTextStyles.titleMediumff989898,
                      ),
                    ]),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              SizedBox(height: 34.v),
              Padding(
                padding: EdgeInsets.only(right: 1.h),
                child: CustomPinCodeTextField(
                  validator: (value) =>
                      value!.isEmpty ? 'Enter the code' : null,
                  context: context,
                  onChanged: (value) {
                    for (int i = 0; i < value.length; i++) {
                      verificationCode[i] = value[i];
                    }
                    isFilledNotifier.value = value.length == 5;
                  },
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
                    text: "Haven’t got the email yet?",
                    style: CustomTextStyles.titleMediumff989898,
                  ),
                  TextSpan(text: " "),
                  TextSpan(
                    text: "Resend email",
                    style: CustomTextStyles.titleMediumff648ddb
                        .copyWith(decoration: TextDecoration.underline),
                  ),
                ]),
                textAlign: TextAlign.left,
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
                "Success!",
                style: CustomTextStyles.titleMediumPoppinsBlack2,
              ),
            ),
            SizedBox(height: 30.v),
            Padding(
              padding: EdgeInsets.only(left: 3.h),
              child: Text(
                "Welcome to EduConnect, You can now access your account.",
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
          _buildName(context, "First Name", firstNameController),
          Container(
            width: 23.v,
          ),
          _buildName(context, "Last Name", lastNameController),
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
        hintText: "Enter Email",
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
                      errorMessage = 'Invalid email format';
                    });
                  }
                }
              } else {
                setState(() {
                  errorMessage = 'Please fill all the fields';
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
      text: "Next Step",
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
                        errorMessage = 'Passwords do not match';
                      });
                    }
                  } else {
                    setState(() {
                      errorMessage = 'Password is too short';
                    });
                  }
                }
              } else {
                setState(() {
                  errorMessage = 'Please fill all the fields';
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
                return AppColors.indigoA300; // Use the component's default.
              },
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          isLoading: state is AuthLoading,
          text: "Verify Code",
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
      text: "Continue",
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
                      ? "Server error"
                      : state.message.contains('Email already exists')
                          ? "Email already exists"
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
                      ? "Wrong code"
                      : state.message.contains('Email already exists')
                          ? "Email already exists"
                          : state.message,
                  style: CustomTextStyles.titleMediumPoppinsBluegray100)
              : Text(errorMessage,
                  style: CustomTextStyles.titleMediumPoppinsBluegray100)
        ],
      ),
    );
  }
}
