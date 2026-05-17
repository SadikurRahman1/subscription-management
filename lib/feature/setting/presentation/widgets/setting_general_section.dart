import 'package:subscription_manage/core/exported_files/exported_file.dart';

import '../controller/setting_controller.dart';
import 'setting_widgets.dart';

class SettingGeneralSection extends StatelessWidget {
  const SettingGeneralSection({super.key, required this.controller});

  final SettingController controller;

  @override
  Widget build(BuildContext context) {
    return _SettingSectionBlock(
      title: 'general',
      accentColor: const Color(0xFF52D1FF),
      cardGradient: AppColors.elevatedSurfaceGradient,
      children: [
        Obx(
          () => SettingTile(
            title: 'currency',
            leadingIcon: Icons.currency_exchange,
            leadingGradient: const LinearGradient(
              colors: [Color(0xFFFF8A00), Color(0xFFFFC533)],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SettingValuePill(
                  text: controller.selectedCurrencyDisplayLabel,
                  accent: const Color(0xFFFFC857),
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
              colors: [Color(0xFF5B8DEF), Color(0xFF62D0FF)],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SettingValuePill(
                  text: controller.selectedLanguage.value,
                  accent: const Color(0xFF62D0FF),
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
            leadingGradient: const LinearGradient(
              colors: [Color(0xFF8A7CFF), Color(0xFF4F46E5)],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SettingValuePill(
                  text: controller.selectedTheme.value,
                  accent: const Color(0xFF9C8CFF),
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

class _SettingSectionBlock extends StatelessWidget {
  const _SettingSectionBlock({
    required this.title,
    required this.accentColor,
    required this.cardGradient,
    required this.children,
  });

  final String title;
  final Color accentColor;
  final Gradient cardGradient;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingSectionHeader(title: title, accentColor: accentColor),
        const SizedBox(height: 12),
        SettingCard(gradient: cardGradient, children: children),
      ],
    );
  }
}
