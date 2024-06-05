import 'dart:io';

import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:educonnect/config/themes/custom_text_style.dart';
import 'package:educonnect/core/utils/app_colors.dart';
import 'package:educonnect/core/utils/size_utils.dart';
import 'package:educonnect/features/auth/presentation/widgets/custom_elevated_button.dart';
import 'package:educonnect/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:educonnect/features/profile/data/models/profile_model.dart';
import 'package:educonnect/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfile extends StatefulWidget {
  final ProfileModel profile;

  UpdateProfile({Key? key, required this.profile}) : super(key: key);

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  String errorMessage = '';
  @override
  void dispose() {
    errorMessage = '';
    super.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController contactInfoController = TextEditingController();

  @override
  void initState() {
    firstNameController.text = widget.profile.firstName;
    lastNameController.text = widget.profile.lastName;
    bioController.text = widget.profile.bio;
    contactInfoController.text = widget.profile.contactInformation;
    super.initState();
  }

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
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdated) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: WillPopScope(
            onWillPop: () async {
              return true;
            },
            child: Scaffold(
              appBar: AppBar(
                leading: BackButton(color: Colors.black),
                backgroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  AppLocalizations.of(context)!.translate('edit_profile')!,
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
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                  child: ListView(
                    children: [
                      SizedBox(height: 20),
                      _buildFiftyOne(context),
                      SizedBox(height: 20),
                      _buildField(context, 'bio', bioController),
                      SizedBox(height: 20.v),
                      _buildField(
                          context, 'contactInfo', contactInfoController),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 3.h),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate('select_new_image')!,
                              style: CustomTextStyles.titleMediumPoppinsGray900,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 3.h),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate('optional')!,
                              style:
                                  CustomTextStyles.titleMediumPoppinsGray40001,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7.v),
                      InkWell(
                        onTap: pickImage,
                        child: selectedImage == null
                            ? Text(AppLocalizations.of(context)!
                                .translate('select_image')!)
                            : Text(
                                'Image Selected: ${selectedImage!.path.split('/').last}'),
                      ),
                      SizedBox(height: 30.v),
                      SizedBox(height: 30),
                      _buildUpdateButton(context, state),
                      SizedBox(height: 8),
                      _buildError(context, state),
                      SizedBox(height: 8),
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

  Widget _buildTextField(
      BuildContext context, String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(right: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          SizedBox(height: 12),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey, width: 1.5),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 21, vertical: 15),
              hintText: label,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateButton(BuildContext context, state) {
    return CustomElevatedButton(
      onPressed: state is ProfileLoading
          ? null
          : () {
              if (firstNameController.text.isNotEmpty ||
                  lastNameController.text.isNotEmpty ||
                  bioController.text.isNotEmpty ||
                  contactInfoController.text.isNotEmpty ||
                  selectedImage != null) {
                setState(() {
                  errorMessage = '';
                });

                if (_formKey.currentState!.validate()) {
                  File? image;
                  if (selectedImage != null) {
                    image = File(selectedImage!.path);
                  }
                  context.read<ProfileCubit>().updateProfile(
                        ProfileModel(
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          bio: bioController.text,
                          contactInformation: contactInfoController.text,
                        ),
                        image,
                      );
                }
              } else {
                setState(() {
                  errorMessage = 'Please fill at least one field.';
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
      text: AppLocalizations.of(context)!.translate('continue')!,
      margin: EdgeInsets.only(left: 2.h, right: 2.h),
      buttonTextStyle: CustomTextStyles.titleMediumPoppins,
    );
  }

  Widget _buildFiftyOne(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildName(
              context,
              AppLocalizations.of(context)!.translate('first_name')!,
              firstNameController),
          Container(
            width: 23.v,
          ),
          _buildName(
              context,
              AppLocalizations.of(context)!.translate('last_name')!,
              lastNameController),
        ],
      ),
    );
  }

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

  Widget _buildField(
      BuildContext context, String text, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(left: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.translate(text)!,
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
            controller: controller,
            hintText: AppLocalizations.of(context)!.translate(text)!,
            textInputType: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, state) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.h, 0, 15.h, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          state is ProfileError
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
