import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:educonnect/config/routes/app_routes.dart';
import 'package:educonnect/config/themes/custom_text_style.dart';
import 'package:educonnect/core/utils/app_colors.dart';
import 'package:educonnect/core/utils/size_utils.dart';
import 'package:educonnect/features/auth/presentation/pages/login_screen.dart';
import 'package:educonnect/features/auth/presentation/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Success extends StatelessWidget {
  const Success({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                AppLocalizations.of(context)!.translate("welcome")!, // YOUR PASSWORD HAS BEEN CHANGED NOW YOU CAN LOGIN
                style: CustomTextStyles.bodyMediumRobotoGray2,
              ),
            ),
            SizedBox(height: 30.v),
            _buildContinue2(context),
          ],
        ),
      ),
    );
  }

  Widget _buildContinue2(BuildContext context) {
    return CustomElevatedButton(
      onPressed: () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
          (route) => false,
        );
      },
      buttonStyle: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(AppColors.indigoA300),
      ),
      text: AppLocalizations.of(context)!.translate("continue")!, // LOGIN 
      margin: EdgeInsets.only(left: 2.h, right: 2.h), 
      buttonTextStyle: CustomTextStyles.titleMediumPoppins,
    );
  }
}
