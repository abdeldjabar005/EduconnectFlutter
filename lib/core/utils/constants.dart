import 'package:educonnect/features/posts/presentation/pages/class_feed.dart';
import 'package:educonnect/features/posts/presentation/pages/school_feed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:educonnect/core/utils/app_colors.dart';
import 'package:educonnect/features/classrooms/presentation/pages/classroom_posts.dart';
import 'package:educonnect/features/classrooms/presentation/widgets/classes.dart';
import 'package:educonnect/features/classrooms/presentation/widgets/members.dart';
import 'package:educonnect/features/posts/presentation/pages/post_screen.dart';

class Constants {
  static void showErrorDialog(
      {required BuildContext context, required String msg}) {
    showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text(
                msg,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      textStyle: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  child: const Text('Ok'),
                )
              ],
            ));
  }

  static void showToast(
      {required String msg, Color? color, ToastGravity? gravity}) {
    Fluttertoast.showToast(
        toastLength: Toast.LENGTH_LONG,
        msg: msg,
        backgroundColor: color ?? AppColors.primary,
        gravity: gravity ?? ToastGravity.BOTTOM);
  }

  static List<Tab> getHomeScreenTabs(int index, context) {
    return [
      Tab(
        child: Text(
          AppLocalizations.of(context)!.translate('explore')!,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: index == 0 ? AppColors.blueA200 : Colors.black,
          ),
        ),
      ),
      Tab(
        child: Text(
          AppLocalizations.of(context)!.translate('schools')!,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: index == 1 ? AppColors.blueA200 : Colors.black,
          ),
        ),
      ),
      Tab(
        child: Text(
          AppLocalizations.of(context)!.translate('classes')!,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: index == 2 ? AppColors.blueA200 : Colors.black,
          ),
        ),
      ),
    ];
  }

  static List<Tab> getHomeScreenTabs2(int index, context) {
    return [
      Tab(
        child: Text(
          AppLocalizations.of(context)!.translate('posts')!,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: index == 0 ? AppColors.blueA200 : Colors.black,
          ),
        ),
      ),
      Tab(
        child: Text(
          AppLocalizations.of(context)!.translate('classes')!,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: index == 1 ? AppColors.blueA200 : Colors.black,
          ),
        ),
      ),
      Tab(
        child: Text(
          AppLocalizations.of(context)!.translate('members')!,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: index == 2 ? AppColors.blueA200 : Colors.black,
          ),
        ),
      ),
    ];
  }

  static List<Tab> getHomeScreenTabs3(int index, context) {
    return [
      Tab(
        child: Text(
          AppLocalizations.of(context)!.translate('posts')!,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: index == 0 ? AppColors.blueA200 : Colors.black,
          ),
        ),
      ),
      Tab(
        child: Text(
          AppLocalizations.of(context)!.translate('members')!,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: index == 1 ? AppColors.blueA200 : Colors.black,
          ),
        ),
      ),
    ];
  }

  static List<Widget> screens = [
    const PostScreen(),
    const SchoolFeed(),
    const ClassFeed(),
    // const Center(
    //   child: Text('School Screen'),
    // ),
    // const Center(
    //   child: Text('Class Screen'),
    // ),
  ];
  static List<Widget> screens2(int id, String name) {
    return [
      ClassroomPosts(id: id, type: "school", name: name),
      ClassesScreen(
        id: id,
      ),
      MembersScreen(id: id, type: "school"),
    ];
  }

  static List<Widget> screens3(int id, String name) {
    return [
      ClassroomPosts(id: id, type: "class", name: name),
      MembersScreen(id: id, type: "class"),
    ];
  }
}
