import 'package:subscription_manage/core/exported_files/exported_file.dart';

import 'setting_widgets.dart';

class SettingMoreInfoSection extends StatelessWidget {
  const SettingMoreInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _SettingSectionBlock(
      title: 'more_info',
      accentColor: const Color(0xFFFFC857),
      cardGradient: AppColors.elevatedSurfaceGradient,
      children: [
        SettingTile(
          title: 'version',
          leadingIcon: Icons.info_outline,
          leadingGradient: const LinearGradient(
            colors: [Color(0xFFFFC857), Color(0xFFFF8A00)],
          ),
          trailing: SettingValuePill(
            text: const String.fromEnvironment(
              'APP_VERSION',
              defaultValue: '1.0.0',
            ),
            accent: const Color(0xFFFFC857),
          ),
          onTap: () {},
        ),
        const SizedBox(height: 10),
        SettingTile(
          title: 'more_apps',
          leadingIcon: Icons.apps,
          leadingGradient: const LinearGradient(
            colors: [Color(0xFF52D1FF), Color(0xFF9C8CFF)],
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: Color(0xFF95A0B6),
            size: 22,
          ),
          onTap: () {},
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
