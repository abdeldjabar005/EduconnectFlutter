import 'package:flutter/material.dart';
import 'package:educonnect/config/themes/app_theme.dart';
import 'package:educonnect/core/utils/app_colors.dart';
import 'package:educonnect/core/utils/image_constant.dart';
import 'package:educonnect/core/utils/size_utils.dart';
import 'package:educonnect/features/posts/presentation/widgets/custom_image_view.dart';

class CustomBottomBar extends StatefulWidget {
  CustomBottomBar({this.onChanged});

  Function(BottomBarEnum)? onChanged;

  @override
  CustomBottomBarState createState() => CustomBottomBarState();
}

class CustomBottomBarState extends State<CustomBottomBar> {
  int selectedIndex = 0;

  List<BottomMenuModel> bottomMenuList = [
    BottomMenuModel(
      icon: ImageConstant.imgHome,
      activeIcon: ImageConstant.imgHome,
      type: BottomBarEnum.Home,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgUserGray40028x28,
      activeIcon: ImageConstant.imgUserGray40028x28,
      type: BottomBarEnum.Messages,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgGroup21,
      activeIcon: ImageConstant.imgGroup21,
      type: BottomBarEnum.Schools,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgLock,
      activeIcon: ImageConstant.imgLock,
      type: BottomBarEnum.Profile,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 63.v,
      decoration: BoxDecoration(
        color: AppColors.whiteA700,
        boxShadow: [
          BoxShadow(
            color: AppColors.black900.withOpacity(0.19),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: const Offset(
              0,
              3.75,
            ),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0,
        elevation: 0,
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: List.generate(bottomMenuList.length, (index) {
          return BottomNavigationBarItem(
            icon: CustomImageView(
              imagePath: bottomMenuList[index].icon,
              height: 27.v,
              width: 28.h,
              color: AppColors.gray400,
            ),
            activeIcon: CustomImageView(
              imagePath: bottomMenuList[index].activeIcon,
              height: 27.v,
              width: 28.h,
              color: AppColors.lightBlue500,
            ),
            label: '',
          );
        }),
        onTap: (index) {
          selectedIndex = index;
          widget.onChanged?.call(bottomMenuList[index].type);
          setState(() {});
        },
      ),
    );
  }
}

enum BottomBarEnum {
  Home,
  Messages,
  Schools,
  Profile,
}

class BottomMenuModel {
  BottomMenuModel({
    required this.icon,
    required this.activeIcon,
    required this.type,
  });

  String icon;

  String activeIcon;

  BottomBarEnum type;
}

class DefaultWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffffffff),
      padding: const EdgeInsets.all(10),
      child: const Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please replace the respective Widget here',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
