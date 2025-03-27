import 'package:authentication_app/screens/home/home_page.dart';
import 'package:authentication_app/screens/login/login_page.dart';
import 'package:authentication_app/screens/signUp/signUp_page.dart';
import 'package:authentication_app/screens/splash/splash_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppRoutes {
  static String splash = '/';
  static String login = '/login';
  static String signUp = '/signup';
  static String home = '/home';
  static String favourite = '/favourite';

  static List<GetPage> pages = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: home,
      page: () => const HomePage(),
    ),
    GetPage(
      name: login,
      page: () => LoginPage(),
    ),
    GetPage(
      name: signUp,
      page: () => SignupPage(),
    ),
  ];
}
