import 'package:subscription_manage/core/exported_files/exported_file.dart';
import 'setting_widgets.dart';

class SettingAboutSection extends StatelessWidget {
  const SettingAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingSectionBlock(
      title: 'about',
      accentColor: AppColors.m1,
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
      leadingGradient: LinearGradient(
        colors: [AppColors.m1, AppColors.m2],
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
      leadingGradient: LinearGradient(
        colors: [AppColors.m1, AppColors.m2],
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

