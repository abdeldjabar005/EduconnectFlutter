import 'package:educonnect/features/auth/presentation/pages/forgot_password/forgotpassword.dart';
import 'package:educonnect/features/chat/data/models/contact_model.dart';
import 'package:educonnect/features/chat/presentation/pages/chat_list_screen.dart';
import 'package:educonnect/features/chat/presentation/pages/chat_screen.dart';
import 'package:educonnect/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:educonnect/core/utils/app_strings.dart';
import 'package:educonnect/core/widgets/RootScreen.dart';
import 'package:educonnect/core/widgets/custom_bottom_bar.dart';
import 'package:educonnect/core/widgets/home_page.dart';
import 'package:educonnect/features/auth/presentation/pages/login_screen.dart';
import 'package:educonnect/features/auth/presentation/pages/signup_screen.dart';
import 'package:educonnect/features/classrooms/presentation/widgets/join.dart';
import 'package:educonnect/features/profile/presentation/widgets/manage_children.dart';
import 'package:educonnect/features/profile/presentation/widgets/manage_school.dart';
import '../../features/posts/presentation/cubit/post_cubit.dart';
import 'package:educonnect/injection_container.dart' as di;
import 'package:educonnect/features/posts/presentation/pages/post_screen.dart';

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
  static const String chatList = '/chat-list';
  static const String chat = '/chat';
}

class AppRoutes {
  static Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.initialRoute:
        return MaterialPageRoute(builder: (context) {
          return SplashScreen();
        });
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
          return ForgotPasswordScreen();
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
      case Routes.chatList:
        return MaterialPageRoute(builder: (_) => ChatListScreen());
      case Routes.chat:
        final ContactModel contact = routeSettings.arguments as ContactModel;
        return MaterialPageRoute(
          builder: (_) => ChatScreen(contact: contact),
        );
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
