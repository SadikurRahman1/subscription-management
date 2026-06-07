import 'package:subscription_manage/core/exported_files/exported_file.dart';
import 'setting_widgets.dart';

class SettingMoreInfoSection extends StatelessWidget {
  const SettingMoreInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingSectionBlock(
      title: 'more_info',
      accentColor: AppColors.m1,
      cardGradient: AppColors.elevatedSurfaceGradient,
      children: [
        SettingTile(
          title: 'version',
          leadingIcon: Icons.info_outline,
          leadingGradient: const LinearGradient(
            colors: [AppColors.m1, AppColors.m2],
          ),
          trailing: SettingValuePill(
            text: const String.fromEnvironment(
              'APP_VERSION',
              defaultValue: '1.0.0',
            ),
            accent: AppColors.m1,
          ),
          onTap: () {},
        ),
        const SizedBox(height: 10),
        SettingTile(
          title: 'more_apps',
          leadingIcon: Icons.apps,
          leadingGradient: const LinearGradient(
            colors: [AppColors.m1, AppColors.m2],
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

