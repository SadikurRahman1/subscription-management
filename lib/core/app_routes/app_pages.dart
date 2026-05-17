
import 'package:subscription_manage/feature/setting/presentation/bindings/setting_binding.dart';
import 'package:subscription_manage/feature/setting/presentation/screen/setting_screen.dart';
import 'package:subscription_manage/feature/subscription/presentation/binding/subscription_binding.dart';
import 'package:subscription_manage/feature/subscription/presentation/screens/subscription_screen.dart';
import 'package:subscription_manage/feature/main_bottom_nav/presentation/binding/main_bottom_nav_binding.dart';
import 'package:subscription_manage/feature/main_bottom_nav/presentation/screen/main_bottom_nav_screen.dart';
import 'package:subscription_manage/feature/splash/presentation/screen/splash_screen.dart';
import 'package:subscription_manage/feature/subscription_form/presentation/screens/subscription_form_screen.dart';
import '../exported_files/exported_file.dart';

class AppPages {
  static List<GetPage<dynamic>> appPages() {
    return [
    
      _getPages(
        name: AppRoutes.splashScreen,
        page: () => SplashScreen(),
        // binding: SplashBinding(),
      ),
      _getPages(
        name: AppRoutes.subscriptionScreen,
        page: () => SubscriptionScreen(),
        binding: SubscriptionBinding(),
      ),
      _getPages(
        name: AppRoutes.settingsScreen,
        page: () => SettingScreen(),
        binding: SettingBinding(),
      ),
      _getPages(
        name: AppRoutes.mainBottomNavScreen,
        page: () => MainBottomNavScreen(),
        binding: MainBottomNavBinding(),
      ),

      _getPages(
        name: AppRoutes.createScreen,
        page: () => const SubscriptionFormScreen(),
      ),
     
     
     
    ];
  }

  static GetPage<dynamic> _getPages({
    required String name,
    required Widget Function() page,
    Bindings? binding,
  }) => GetPage(name: name, page: page, binding: binding);
}
