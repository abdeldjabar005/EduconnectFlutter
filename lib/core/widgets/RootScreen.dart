import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:educonnect/features/chat/presentation/pages/chat_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:educonnect/config/routes/app_routes.dart';
import 'package:educonnect/core/utils/app_colors.dart';
import 'package:educonnect/core/utils/constants.dart';
import 'package:educonnect/core/widgets/custom_bottom_bar.dart';
import 'package:educonnect/core/widgets/home_page.dart';
import 'package:educonnect/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:educonnect/features/classrooms/presentation/pages/main_classroom.dart';
import 'package:educonnect/features/posts/presentation/pages/new_post.dart';
import 'package:educonnect/features/profile/presentation/pages/main_profile.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int selectedIndex = 0;
  final List<Widget> pages = [
    HomeScreen(),
    // NewPost(),
    ChatListScreen(),
    // DefaultWidget(),
    MainClassroom(),
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
            content: Text(
              AppLocalizations.of(context)!.translate('exit_message')!,
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
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return false;
        }
        context.read<AuthCubit>().reset();
        return true;
      },
      child: Scaffold(
        body: IndexedStack(index: selectedIndex, children: pages),
        bottomNavigationBar: _buildBottomBar(context),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: CustomBottomBar(onChanged: (BottomBarEnum type) {
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
            case BottomBarEnum.Profile:
              selectedIndex = 3;
              break;
          }
        });
      }),
    );
  }
}
