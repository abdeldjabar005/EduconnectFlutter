import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quotes/core/utils/app_colors.dart';
import 'package:quotes/features/classrooms/presentation/pages/classroom_posts.dart';
import 'package:quotes/features/classrooms/presentation/widgets/classes.dart';
import 'package:quotes/features/classrooms/presentation/widgets/members.dart';
import 'package:quotes/features/posts/presentation/pages/post_screen.dart';

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

  static List<Tab> getHomeScreenTabs(int index) {
    return [
      Tab(
        child: Text(
          'Explore',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: index == 0 ? AppColors.blueA200 : Colors.black,
          ),
        ),
      ),
      Tab(
        child: Text(
          'School',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: index == 1 ? AppColors.blueA200 : Colors.black,
          ),
        ),
      ),
      Tab(
        child: Text(
          'Class',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: index == 2 ? AppColors.blueA200 : Colors.black,
          ),
        ),
      ),
    ];
  }

  static List<Tab> getHomeScreenTabs2(int index) {
    return [
      Tab(
        child: Text(
          'Posts',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: index == 0 ? AppColors.blueA200 : Colors.black,
          ),
        ),
      ),
      Tab(
        child: Text(
          'Classes',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: index == 1 ? AppColors.blueA200 : Colors.black,
          ),
        ),
      ),
      Tab(
        child: Text(
          'Members',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: index == 2 ? AppColors.blueA200 : Colors.black,
          ),
        ),
      ),
    ];
  }

  static List<Tab> getHomeScreenTabs3(int index) {
    return [
      Tab(
        child: Text(
          'Posts',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: index == 0 ? AppColors.blueA200 : Colors.black,
          ),
        ),
      ),
      Tab(
        child: Text(
          'Members',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: index == 1 ? AppColors.blueA200 : Colors.black,
          ),
        ),
      ),
    ];
  }

  static const List<Widget> screens = [
    PostScreen(),
    Center(
      child: Text('School Screen'),
    ),
    Center(
      child: Text('Class Screen'),
    ),
  ];
  static List<Widget> screens2(int id) {
    return [
      ClassroomPosts(id: id, type: "school"),
      ClassesScreen(
        id: id,
      ),
      MembersScreen(id: id, type: "school"),
    ];
  }

  static List<Widget> screens3(int id) {
    return [
      ClassroomPosts(id: id, type: "class"),
      MembersScreen(id: id, type: "class"),
    ];
  }
}
