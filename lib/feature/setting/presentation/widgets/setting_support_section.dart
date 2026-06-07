import 'package:subscription_manage/core/exported_files/exported_file.dart';
import '../controller/setting_controller.dart';
import 'setting_widgets.dart';

class SettingSupportSection extends StatelessWidget {
  const SettingSupportSection({super.key, required this.controller});

  final SettingController controller;

  @override
  Widget build(BuildContext context) {
    return SettingSectionBlock(
      title: 'support',
      accentColor: AppColors.m1,
      cardGradient: AppColors.elevatedSurfaceGradient,
      children: [
        SettingTile(
          title: 'contact_support',
          leadingIcon: Icons.headset_mic_outlined,
          leadingGradient: const LinearGradient(
            colors: [AppColors.m1, AppColors.m2],
          ),
          subtitle: const ResponsiveText(
            text: 'send_app_version_device_and_os_details',
            fontSize: 11.2,
            fontWeight: FontWeight.w500,
            color: Color(0xFFB8C1D1),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: Color(0xFF95A0B6),
            size: 22,
          ),
          onTap: controller.openSupportEmail,
        ),
        const SizedBox(height: 10),
        SettingTile(
          title: 'rate_us',
          leadingIcon: Icons.star_border,
          leadingGradient: const LinearGradient(
            colors: [AppColors.m1, AppColors.m2],
          ),
          subtitle: const ResponsiveText(
            text: 'tell_us_how_the_app_feels',
            fontSize: 11.2,
            fontWeight: FontWeight.w500,
            color: Color(0xFFB8C1D1),
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
