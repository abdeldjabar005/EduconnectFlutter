import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes/core/utils/app_strings.dart';
import 'package:quotes/core/widgets/RootScreen.dart';
import 'package:quotes/core/widgets/custom_bottom_bar.dart';
import 'package:quotes/core/widgets/home_page.dart';
import 'package:quotes/features/auth/presentation/pages/login_screen.dart';
import 'package:quotes/features/auth/presentation/pages/signup_screen.dart';
import 'package:quotes/features/classrooms/presentation/widgets/join.dart';
import 'package:quotes/features/profile/presentation/widgets/manage_children.dart';
import 'package:quotes/features/profile/presentation/widgets/manage_school.dart';
import '../../features/posts/presentation/cubit/post_cubit.dart';
import 'package:quotes/injection_container.dart' as di;
import 'package:quotes/features/posts/presentation/pages/post_screen.dart';

class Routes {
  static const String initialRoute = '/';
  static const String loginRoute = '/login';
  static const String signUpRoute = '/signUp';
  static const String forgotpasswordRoute = '/forgotpassword';

  static const String homeRoute = '/home';
  static const String defaultWidget = '/defaultWidget';
  static const String postRoute = '/posts';
  static const String rootScreen = '/rootScreen';

  static const String joinSchool = '/join-school';
  static const String joinClass = '/join-class';
  static const String manageChildren = '/manage-children';
  static const String manageSchool = '/manage-school';
  static const String classRoom = '/classroom';
  
}

class AppRoutes {
  static Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.initialRoute:
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (context) {
          return LoginScreen();
        });

      case Routes.signUpRoute:
        return MaterialPageRoute(builder: (context) {
          return SignupScreen();
        });

      case Routes.forgotpasswordRoute:
        return MaterialPageRoute(builder: (context) {
          return SignupScreen();
        });

      case Routes.postRoute:
        return MaterialPageRoute(builder: ((context) {
          return BlocProvider(
            create: ((context) => di.sl<PostCubit>()),
            child: const PostScreen(),
          );
        }));
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (context) {
          return HomeScreen();
        });
      case Routes.rootScreen:
        return MaterialPageRoute(builder: (context) {
          return RootScreen();
        });
      case Routes.defaultWidget:
        return MaterialPageRoute(builder: (context) {
          return DefaultWidget();
        });
      case Routes.joinSchool:
        return MaterialPageRoute(builder: (context) {
          return Join(type: 'school');
        });
      case Routes.joinClass:
        return MaterialPageRoute(builder: (context) {
          return Join(type: 'class');
        });
      case Routes.manageChildren:
        return MaterialPageRoute(builder: (context) {
          return ManageChildren();
        });
      case Routes.manageSchool:
        return MaterialPageRoute(builder: (context) {
          return ManageSchool();
        });
      
      default:
        return undefinedRoute();
    }
  }

  static Route<dynamic> undefinedRoute() {
    return MaterialPageRoute(
        builder: ((context) => const Scaffold(
              body: Center(
                child: Text(AppStrings.noRouteFound),
              ),
            )));
  }
}
