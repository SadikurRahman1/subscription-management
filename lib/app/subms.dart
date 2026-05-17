
import 'package:flutter/services.dart';
import 'package:subscription_manage/core/exported_files/exported_file.dart';
import 'package:subscription_manage/core/localization/language_service.dart';
import 'package:subscription_manage/core/localization/translation_service.dart';
import '../core/app_routes/app_pages.dart';
// import '../core/themes/app_themes/app_themes.dart';

class Subms extends StatelessWidget {
  const Subms({super.key});

  @override
  Widget build(BuildContext context) {
    // ScreenSize.init(context);
    return GetMaterialApp(
      initialRoute:  AppRoutes.splashScreen,
      getPages: AppPages.appPages(),
      translations: AppTranslation(),
      locale: LanguageService.getSavedLocale() ?? LanguageService.defaultLocale,
      fallbackLocale: LanguageService.defaultLocale,
      // theme: AppThemes.lightThemeData,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      builder: (context, child) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          // statusBarColor: AppColors.,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ));
        return child!;
      },
    );
  }
}