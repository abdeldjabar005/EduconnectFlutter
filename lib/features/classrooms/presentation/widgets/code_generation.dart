// lib/screens/code_generation_screen.dart

import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:educonnect/config/themes/custom_text_style.dart';
import 'package:educonnect/core/utils/app_colors.dart';
import 'package:educonnect/core/utils/size_utils.dart';
import 'package:educonnect/features/auth/presentation/widgets/custom_elevated_button.dart';
import 'package:educonnect/features/classrooms/presentation/cubit/class_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CodeGenerationScreen extends StatefulWidget {
  final int schoolId;
  final String type;
  const CodeGenerationScreen({required this.schoolId, required this.type});

  @override
  _CodeGenerationScreenState createState() => _CodeGenerationScreenState();
}

class _CodeGenerationScreenState extends State<CodeGenerationScreen>
    with AutomaticKeepAliveClientMixin {
  int? _selectedNumber = 1;

  @override
  bool get wantKeepAlive => false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray200,
      appBar: AppBar(
        leading: BackButton(
          color: AppColors.black900,
        ),
        backgroundColor: AppColors.whiteA700,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.translate('generate_codes')!,
          style: TextStyle(
            fontFamily: "Poppins",
            color: AppColors.black900,
            fontWeight: FontWeight.w400,
            fontSize: 18.v,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!
                  .translate('select_number_of_codes')!,
              style: CustomTextStyles.displayMedium30,
            ),
            SizedBox(height: 10),
            Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Colors.white,
                brightness: Brightness.dark,
              ),
              child: DropdownButton<int>(
                value: _selectedNumber,
                dropdownColor: Colors.grey[200],
                style: TextStyle(color: Colors.black, fontSize: 18),
                items: [1, 2, 3, 5, 10].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(
                      value.toString(),
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedNumber = newValue;
                  });
                },
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.deepPurpleAccent,
                ),
              ),
            ),
            SizedBox(height: 20),
            CustomElevatedButton(
              onPressed: () {
                if (_selectedNumber != null) {
                  context.read<ClassCubit>().generateCodes(
                      widget.type, widget.schoolId, _selectedNumber!);
                }
              },
              buttonStyle: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                backgroundColor:
                    MaterialStateProperty.all(AppColors.indigoA300),
              ),
              text: AppLocalizations.of(context)!.translate("generate_name") ??
                  'انشاء الرموز',
              margin: EdgeInsets.only(left: 20.h, right: 10.h),
              buttonTextStyle: CustomTextStyles.titleMediumPoppins,
            ),
            SizedBox(height: 20),
            BlocBuilder<ClassCubit, ClassState>(
              builder: (context, state) {
                if (state is ClassLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is CodesGenerated) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: state.codes.map((code) {
                      return SelectableText(
                        code,
                        style: CustomTextStyles.displayMedium25,
                      );
                    }).toList(),
                  );
                } else if (state is ClassError) {
                  return Text(state.message,
                      style: TextStyle(color: Colors.red));
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
