import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes/config/routes/app_routes.dart';
import 'package:quotes/core/utils/app_colors.dart';
import 'package:quotes/core/utils/constants.dart';
import 'package:quotes/core/widgets/custom_bottom_bar.dart';
import 'package:quotes/core/widgets/home_page.dart';
import 'package:quotes/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:quotes/features/profile/presentation/pages/main_profile.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int selectedIndex = 0;
  final List<Widget> pages = [
    HomeScreen(),
    DefaultWidget(),
    DefaultWidget(),
    DefaultWidget(),
    MainProfile(),
  ];
  DateTime? lastPressedAt;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        if (lastPressedAt == null ||
            now.difference(lastPressedAt!) > Duration(seconds: 2)) {
          lastPressedAt = now;
          final snackBar = SnackBar(
            content: const Text(
              'Press back again to exit',
              style: TextStyle(
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
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return false;
        }
        context.read<AuthCubit>().reset();
        return true;
      },
      child: Scaffold(
        body: IndexedStack(
          index: selectedIndex,
          children: pages,
        ),
        bottomNavigationBar: _buildBottomBar(context),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return CustomBottomBar(onChanged: (BottomBarEnum type) {
      setState(() {
        switch (type) {
          case BottomBarEnum.Home:
            selectedIndex = 0;
            break;
          case BottomBarEnum.Messages:
            selectedIndex = 1;
            break;
          case BottomBarEnum.Schools:
            selectedIndex = 2;
            break;
          case BottomBarEnum.Classes:
            selectedIndex = 3;
            break;
          case BottomBarEnum.Profile:
            selectedIndex = 4;
            break;
        }
      });
    });
  }
}
