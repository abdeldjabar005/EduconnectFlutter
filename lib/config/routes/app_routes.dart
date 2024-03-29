import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes/core/utils/app_strings.dart';
import 'package:quotes/core/widgets/RootScreen.dart';
import 'package:quotes/core/widgets/home_page.dart';
import 'package:quotes/features/auth/presentation/pages/login_screen.dart';
import 'package:quotes/features/auth/presentation/pages/signup_screen.dart';
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
          return HomeScreen(); // Make sure to import HomeScreen at the top
        });
      case Routes.rootScreen:
        return MaterialPageRoute(builder: (context) {
          return RootScreen();
        });
      case Routes.defaultWidget:
        return MaterialPageRoute(builder: (context) {
          return const Scaffold(
            body: Center(
              child: Text(AppStrings.noRouteFound),
            ),
          );
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
