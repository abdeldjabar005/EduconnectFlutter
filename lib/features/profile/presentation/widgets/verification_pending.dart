import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:educonnect/config/themes/custom_text_style.dart';
import 'package:educonnect/core/utils/app_colors.dart';
import 'package:educonnect/core/utils/image_constant.dart';
import 'package:educonnect/core/utils/size_utils.dart';
import 'package:educonnect/features/classrooms/presentation/cubit/class_cubit.dart';

class VerificationPending extends StatefulWidget {
  const VerificationPending({Key? key})
      : super(
          key: key,
        );

  @override
  State<VerificationPending> createState() => _VerificationPendingState();
}

class _VerificationPendingState extends State<VerificationPending>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              AppLocalizations.of(context)!.translate('verification_pending')!,
              style: TextStyle(
                fontFamily: "Poppins",
                color: AppColors.black900,
                fontWeight: FontWeight.w400,
                fontSize: 18.v,
              ),
            ),
          ),
          body: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.v), // 40.v
              Center(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (_, child) {
                    return Transform.rotate(
                      angle: _controller.value * 2.0 * pi,
                      child: child,
                    );
                  },
                  child: Image.asset(ImageConstant.pending,
                      height: 200.v, width: 200.v),
                ),
              ),
              SizedBox(height: 40.v),
              Center(
                child: Text(
                    AppLocalizations.of(context)!
                        .translate('your_verification_pending')!,
                    textAlign: TextAlign.center,
                    style: CustomTextStyles.bodyMediumRobotoBlack),
              ),
              SizedBox(height: 20.v),
              Center(
                child: Text(
                  AppLocalizations.of(context)!.translate('support_team')!,
                  textAlign: TextAlign.center,
                  style: CustomTextStyles.bodyMediumRobotoBlack2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
