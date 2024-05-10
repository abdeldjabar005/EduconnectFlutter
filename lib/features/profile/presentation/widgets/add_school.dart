import 'dart:developer';
import 'dart:io';

import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:educonnect/config/themes/custom_text_style.dart';
import 'package:educonnect/core/utils/app_colors.dart';
import 'package:educonnect/core/utils/image_constant.dart';
import 'package:educonnect/core/utils/size_utils.dart';
import 'package:educonnect/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:educonnect/features/auth/presentation/widgets/custom_drop_down.dart';
import 'package:educonnect/features/auth/presentation/widgets/custom_elevated_button.dart';
import 'package:educonnect/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:educonnect/features/classrooms/data/models/class_m.dart';
import 'package:educonnect/features/classrooms/data/models/school_m.dart';
import 'package:educonnect/features/classrooms/presentation/cubit/class_cubit.dart';
import 'package:educonnect/features/posts/presentation/widgets/custom_image_view.dart';
import 'package:educonnect/features/profile/presentation/cubit/children_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:educonnect/features/profile/presentation/widgets/manage_school.dart';

class AddSchool extends StatefulWidget {
  const AddSchool({Key? key})
      : super(
          key: key,
        );

  @override
  _AddSchoolState createState() => _AddSchoolState();
}

class _AddSchoolState extends State<AddSchool> {
  String errorMessage = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController schoolNameController = TextEditingController();

  TextEditingController addressController = TextEditingController();

  XFile? selectedImage;

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClassCubit, ClassState>(
      listener: (context, state) {
        log(state.toString());
        if (state is SchoolLoaded) {
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
                  AppLocalizations.of(context)!.translate('add_school2')!,
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
                      SizedBox(height: 40.v),
                      Center(
                        child: Text(
                            AppLocalizations.of(context)!
                                .translate('no_school_yet')!,
                            style: CustomTextStyles.bodyMediumRobotoBlack),
                      ),
                      SizedBox(height: 20.v),
                      Center(
                        child: Text(
                          AppLocalizations.of(context)!
                              .translate('add_school_started')!,
                          style: CustomTextStyles.bodyMediumRobotoBlack2,
                        ),
                      ),
                      SizedBox(height: 40.v),
                      _buildName(
                          context,
                          AppLocalizations.of(context)!
                              .translate('school_name')!,
                          schoolNameController),
                      SizedBox(height: 20.v),
                      _buildName(
                          context,
                          AppLocalizations.of(context)!.translate('address')!,
                          addressController),
                      SizedBox(height: 20.v),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 3.h),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate('select_image')!,
                              style: CustomTextStyles.titleMediumPoppinsGray900,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 3.h),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate('optional')!,
                              style: CustomTextStyles
                                  .titleMediumPoppinsGray40001
                                  .copyWith(
                                fontSize: 16.v,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.v),
                      Padding(
                        padding: EdgeInsets.only(left: 3.h),
                        child: InkWell(
                          onTap: pickImage,
                          child: selectedImage == null
                              ? Text(
                                  AppLocalizations.of(context)!
                                      .translate('select_image')!,
                                  style: CustomTextStyles
                                      .titleMediumPoppinsGray40001
                                      .copyWith(
                                    fontSize: 16.v,
                                    //fontWeight: FontWeight.w800,
                                  ))
                              : Text(
                                  '${AppLocalizations.of(context)!.translate('image_selected')!}: ${selectedImage!.path.split('/').last}',
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
    return CustomElevatedButton(
      onPressed: state is ChildrenLoading
          ? null
          : () {
              if (schoolNameController.text.isNotEmpty &&
                  addressController.text.isNotEmpty) {
                setState(() {
                  errorMessage = '';
                });

                if (_formKey.currentState!.validate()) {
                  File? image;
                  if (selectedImage != null) {
                    image = File(selectedImage!.path);
                  }
                  context.read<ClassCubit>().addSchool(
                        SchoolM(
                          name: schoolNameController.text,
                          address: addressController.text,
                        ),
                        image,
                      );
                }
              } else {
                setState(() {
                  errorMessage = AppLocalizations.of(context)!
                      .translate('fill_all_fields')!;
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
      text: AppLocalizations.of(context)!.translate('continue')!,
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
                      ? AppLocalizations.of(context)!.translate('server_error')!
                      : state.message,
                  style: CustomTextStyles.titleMediumPoppinsBluegray100)
              : Text(errorMessage,
                  style: CustomTextStyles.titleMediumPoppinsBluegray100)
        ],
      ),
    );
  }
}
