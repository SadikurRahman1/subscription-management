import 'package:subscription_manage/core/exported_files/exported_file.dart';
import 'package:subscription_manage/feature/setting/presentation/controller/setting_controller.dart';
import 'package:subscription_manage/feature/setting/presentation/widgets/setting_about_section.dart';
import 'package:subscription_manage/feature/setting/presentation/widgets/setting_general_section.dart';
import 'package:subscription_manage/feature/setting/presentation/widgets/setting_more_info_section.dart';
import 'package:subscription_manage/feature/setting/presentation/widgets/setting_notifications_section.dart';
import 'package:subscription_manage/feature/setting/presentation/widgets/setting_support_section.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});

  final SettingController controller = Get.isRegistered<SettingController>()
      ? Get.find<SettingController>()
      : Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        foregroundColor: Colors.white,
        title: Text(
          'settings'.tr,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.mainColor, AppColors.bgColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body:RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bgColor, AppColors.mainColor, AppColors.bgColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
            children: [
              SettingGeneralSection(controller: controller),
              const SizedBox(height: 18),
              SettingNotificationsSection(controller: controller),
              const SizedBox(height: 18),
              SettingSupportSection(controller: controller),
              const SizedBox(height: 18),
              const SettingAboutSection(),
              const SizedBox(height: 18),
              const SettingMoreInfoSection(),
            ],
          ),
        ),
      ),)
    );
  }
}
