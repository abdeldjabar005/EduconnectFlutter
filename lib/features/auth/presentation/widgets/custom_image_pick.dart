import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:educonnect/config/themes/custom_text_style.dart';
import 'package:educonnect/core/utils/app_colors.dart';
import 'package:educonnect/core/utils/size_utils.dart';
import 'package:educonnect/core/widgets/custom_icon_button.dart';
import 'package:educonnect/features/auth/presentation/widgets/custom_text_form_field.dart';

class ImageSelectionFormField extends StatefulWidget {
  final String text;
  final TextEditingController controller;

  ImageSelectionFormField({required this.text, required this.controller});

  @override
  _ImageSelectionFormFieldState createState() => _ImageSelectionFormFieldState();
}

class _ImageSelectionFormFieldState extends State<ImageSelectionFormField> {
  final ImagePicker _picker = ImagePicker();
  XFile? selectedImage;

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: 1.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
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
              controller: widget.controller,
              hintText: widget.text,
            ),
            CustomIconButton(
              
              onTap: pickImage,
              child: Text('Select Image'),
            ),
            if (selectedImage != null)
              Text(
                'Selected Image: ${selectedImage!.path.split('/').last}',
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}