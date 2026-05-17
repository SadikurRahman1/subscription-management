
import 'package:flutter/services.dart';
import 'package:subscription_manage/core/exported_files/exported_file.dart';
import 'package:subscription_manage/core/constants/app_colors.dart';
import 'package:subscription_manage/core/localization/language_service.dart';
import 'package:subscription_manage/core/localization/translation_service.dart';
import 'package:subscription_manage/feature/setting/presentation/controller/setting_controller.dart';
import '../core/app_routes/app_pages.dart';
// import '../core/themes/app_themes/app_themes.dart';

class Subms extends StatelessWidget {
  const Subms({super.key});

  @override
  Widget build(BuildContext context) {
    // ScreenSize.init(context);
    final SettingController settingController = Get.isRegistered<SettingController>()
        ? Get.find<SettingController>()
        : Get.put(SettingController(), permanent: true);

    return GetBuilder<SettingController>(
      init: settingController,
      builder: (controller) => GetMaterialApp(
        initialRoute: AppRoutes.splashScreen,
        getPages: AppPages.appPages(),
        translations: AppTranslation(),
        locale: LanguageService.getSavedLocale() ?? LanguageService.defaultLocale,
        fallbackLocale: LanguageService.defaultLocale,
        theme: AppColors.lightThemeData,
        darkTheme: AppColors.darkThemeData,
        themeMode: controller.currentThemeMode,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          final Brightness brightness = Theme.of(context).brightness;
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              statusBarIconBrightness: brightness == Brightness.dark
                  ? Brightness.light
                  : Brightness.dark,
              statusBarBrightness: brightness == Brightness.dark
                  ? Brightness.dark
                  : Brightness.light,
            ),
          );
          return child!;
        },
      ),
    );
  }
}