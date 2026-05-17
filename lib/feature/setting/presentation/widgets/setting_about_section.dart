import 'package:subscription_manage/core/exported_files/exported_file.dart';

import 'setting_widgets.dart';

class SettingAboutSection extends StatelessWidget {
  const SettingAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _SettingSectionBlock(
      title: 'about',
      accentColor: const Color(0xFF9C8CFF),
      cardGradient: AppColors.elevatedSurfaceGradient,
      children: const [_PrivacyTile(), SizedBox(height: 10), _TermsTile()],
    );
  }
}

class _PrivacyTile extends StatelessWidget {
  const _PrivacyTile();

  @override
  Widget build(BuildContext context) {
    return SettingTile(
      title: 'privacy_policy',
      leadingIcon: Icons.privacy_tip_outlined,
      leadingGradient: const LinearGradient(
        colors: [Color(0xFF9C8CFF), Color(0xFF62D0FF)],
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Color(0xFF95A0B6),
        size: 22,
      ),
      onTap: () {},
    );
  }
}

class _TermsTile extends StatelessWidget {
  const _TermsTile();

  @override
  Widget build(BuildContext context) {
    return SettingTile(
      title: 'terms_and_conditions',
      leadingIcon: Icons.description_outlined,
      leadingGradient: const LinearGradient(
        colors: [Color(0xFF8A7CFF), Color(0xFFFF7AB6)],
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Color(0xFF95A0B6),
        size: 22,
      ),
      onTap: () {},
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
