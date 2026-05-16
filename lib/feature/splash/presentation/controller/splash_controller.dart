import 'package:get/get.dart';
import 'package:subscription_manage/core/app_routes/app_routes.dart';

class SplashController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2)); 
    
    Get.offAllNamed(
      AppRoutes.mainBottomNavScreen,
      arguments: 0,
    );
    
  }
}