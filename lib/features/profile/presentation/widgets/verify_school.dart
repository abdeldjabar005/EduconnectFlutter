import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes/config/themes/custom_text_style.dart';
import 'package:quotes/core/utils/app_colors.dart';
import 'package:quotes/core/utils/image_constant.dart';
import 'package:quotes/core/utils/size_utils.dart';
import 'package:quotes/features/auth/domain/entities/user.dart';
import 'package:quotes/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:quotes/features/auth/presentation/widgets/custom_drop_down.dart';
import 'package:quotes/features/auth/presentation/widgets/custom_elevated_button.dart';
import 'package:quotes/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:quotes/features/classrooms/data/models/class_m.dart';
import 'package:quotes/features/classrooms/data/models/school_m.dart';
import 'package:quotes/features/classrooms/presentation/cubit/class_cubit.dart';
import 'package:quotes/features/posts/presentation/widgets/custom_image_view.dart';
import 'package:quotes/features/profile/presentation/cubit/children_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quotes/features/profile/presentation/widgets/manage_school.dart';
import 'package:file_picker/file_picker.dart';

class VerifySchool extends StatefulWidget {
  const VerifySchool({Key? key})
      : super(
          key: key,
        );

  @override
  _VerifySchoolState createState() => _VerifySchoolState();
}

class _VerifySchoolState extends State<VerifySchool> {
  String errorMessage = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  TextEditingController phoneNumberController = TextEditingController();

  File? selectedFile;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        selectedFile = file;
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClassCubit, ClassState>(
      listener: (context, state) {
        log(state.toString());
        if (state is SchoolVerifyRequested) {
          Navigator.maybePop(context);
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
                  "Verify your school",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: AppColors.black900,
                    fontWeight: FontWeight.w400,
                    fontSize: 18.v,
                  ),
                ),
              ),
              body: Form(
                key: _formKey,
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.h,
                    vertical: 15.v,
                  ),
                  child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.v),
                      Center(
                        child: Text("Please Fill in the required Informations",
                            textAlign: TextAlign.center,
                            style: CustomTextStyles.bodyMediumRobotoBlack),
                      ),
                      SizedBox(height: 20.v),
                      Center(
                        child: Text(
                          "Provide the necessary documents to verify your school",
                          textAlign: TextAlign.center,
                          style: CustomTextStyles.bodyMediumRobotoBlack2,
                        ),
                      ),
                      SizedBox(height: 40.v),
                      _buildName(context, "School Email", emailController,
                          TextInputType.emailAddress),
                      SizedBox(height: 20.v),
                      _buildName(context, "Phone Number", phoneNumberController,
                          TextInputType.phone),
                      SizedBox(height: 20.v),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 3.h),
                            child: Text(
                              "Select File",
                              style: CustomTextStyles.titleMediumPoppinsGray900,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.v),
                      Padding(
                        padding: EdgeInsets.only(left: 3.h),
                        child: InkWell(
                          onTap: pickFile,
                          child: selectedFile == null
                              ? Text('Select File',
                                  style: CustomTextStyles
                                      .titleMediumPoppinsGray40001
                                      .copyWith(
                                    fontSize: 16.v,
                                    //fontWeight: FontWeight.w800,
                                  ))
                              : Text(
                                  'File Selected: ${selectedFile!.path.split('/').last}',
                                  style: CustomTextStyles
                                      .titleMediumPoppinsGray40001),
                        ),
                      ),
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
        );
      },
    );
  }

  /// Section Widget
  Widget _buildName(BuildContext context, String text,
      TextEditingController controller, TextInputType type) {
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
              textInputType: type,
              // width: 200.h,
              controller: controller,
              hintText: text,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinue(BuildContext context, state) {
    final user = (context.read<AuthCubit>().state as AuthAuthenticated).user;

    return CustomElevatedButton(
      onPressed: state is ChildrenLoading
          ? null
          : () {
              if (emailController.text.isNotEmpty &&
                  phoneNumberController.text.isNotEmpty &&
                  selectedFile != null) {
                setState(() {
                  errorMessage = '';
                });
                if (RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(emailController.text)) {
                  if (_formKey.currentState!.validate()) {
                    File? file;
                    if (selectedFile != null) {
                      file = File(selectedFile!.path);
                    }
                    context.read<ClassCubit>().schoolVerifyRequest(
                          user.school!.id,
                          emailController.text,
                          phoneNumberController.text,
                          file,
                        );
                  }
                } else {
                  setState(() {
                    errorMessage = 'Invalid email format';
                  });
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
      isLoading: state is ClassLoading,
      text: "Continue",
      margin: EdgeInsets.only(left: 2.h, right: 2.h),
      buttonTextStyle: CustomTextStyles.titleMediumPoppins,
    );
  }

  Widget _buildError(BuildContext context, state) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.h, 0, 15.h, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          state is ClassError
              ? Text(
                  state.message.contains('Server Failure')
                      ? "Server error"
                      : state.message,
                  style: CustomTextStyles.titleMediumPoppinsBluegray100)
              : Text(errorMessage,
                  style: CustomTextStyles.titleMediumPoppinsBluegray100)
        ],
      ),
    );
  }
}
