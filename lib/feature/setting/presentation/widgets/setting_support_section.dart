import 'package:subscription_manage/core/exported_files/exported_file.dart';

import '../controller/setting_controller.dart';
import 'setting_widgets.dart';

class SettingSupportSection extends StatelessWidget {
  const SettingSupportSection({super.key, required this.controller});

  final SettingController controller;

  @override
  Widget build(BuildContext context) {
    return _SettingSectionBlock(
      title: 'support',
      accentColor: const Color(0xFF4DD4A8),
      cardGradient: const LinearGradient(
        colors: [Color(0xFF15261F), Color(0xFF121B18)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      children: [
        SettingTile(
          title: 'contact_support',
          leadingIcon: Icons.headset_mic_outlined,
          leadingGradient: const LinearGradient(
            colors: [Color(0xFF4DD4A8), Color(0xFF39C6F5)],
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
            colors: [Color(0xFFFFB84D), Color(0xFFFF7AB6)],
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
