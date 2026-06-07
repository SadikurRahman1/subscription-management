import 'package:subscription_manage/core/exported_files/exported_file.dart';
import '../controller/setting_controller.dart';
import 'setting_widgets.dart';

class SettingGeneralSection extends StatelessWidget {
  const SettingGeneralSection({super.key, required this.controller});

  final SettingController controller;

  @override
  Widget build(BuildContext context) {
    return SettingSectionBlock(
      title: 'general',
      accentColor: AppColors.m1,
      cardGradient: AppColors.elevatedSurfaceGradient,
      children: [
        Obx(
          () => SettingTile(
            title: 'currency',
            leadingIcon: Icons.currency_exchange,
            leadingGradient: const LinearGradient(
              colors: [AppColors.m1, AppColors.m2],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SettingValuePill(
                  text: controller.selectedCurrencyDisplayLabel,
                  accent: AppColors.m2,
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF95A0B6),
                  size: 22,
                ),
              ],
            ),
            onTap: controller.openCurrencySheet,
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () => SettingTile(
            title: 'language',
            leadingIcon: Icons.language,
            leadingGradient: const LinearGradient(
              colors: [AppColors.m1, AppColors.m2],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SettingValuePill(
                  text: controller.selectedLanguage.value,
                  accent: AppColors.m2,
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF95A0B6),
                  size: 22,
                ),
              ],
            ),
            onTap: controller.openLanguageSheet,
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () => SettingTile(
            title: 'theme',
            leadingIcon: Icons.dark_mode_outlined,
            leadingGradient: LinearGradient(
              colors: [AppColors.m1, AppColors.m2],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SettingValuePill(
                  text: controller.selectedTheme.value,
                  accent: AppColors.m2,
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF95A0B6),
                  size: 22,
                ),
              ],
            ),
            onTap: controller.openThemeSheet,
          ),
        ),
      ],
    );
  }
}
