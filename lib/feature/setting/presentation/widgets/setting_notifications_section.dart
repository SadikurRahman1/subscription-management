import 'package:subscription_manage/core/exported_files/exported_file.dart';

import '../controller/setting_controller.dart';
import 'setting_widgets.dart';

class SettingNotificationsSection extends StatelessWidget {
  const SettingNotificationsSection({super.key, required this.controller});

  final SettingController controller;

  @override
  Widget build(BuildContext context) {
    return _SettingSectionBlock(
      title: 'notifications',
      accentColor: const Color(0xFFFF7AB6),
      cardGradient: AppColors.elevatedSurfaceGradient,
      children: [
        Obx(
          () => SettingTile(
            title: 'payment_reminder',
            leadingIcon: Icons.notifications_active_outlined,
            leadingGradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFFB84D)],
            ),
            trailing: Obx(
              () => Switch.adaptive(
                value: controller.paymentReminderEnabled.value,
                onChanged: controller.setPaymentReminderEnabled,
                activeThumbColor: Colors.white,
                activeTrackColor: const Color(0xFFFF6B6B),
                inactiveTrackColor: const Color(0xFF4A4F60),
                inactiveThumbColor: const Color(0xFF9097A8),
              ),
            ),
            extraContent: SettingChoiceChips(
              options: controller.reminderCadenceOptions,
              selected: controller.selectedReminderCadence.value,
              onSelected: controller.selectReminderCadence,
              enabled: controller.paymentReminderEnabled.value,
              accentColor: const Color(0xFFFF6B6B),
            ),
            onTap: () {},
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () => SettingTile(
            title: 'Reminder Time',
            leadingIcon: Icons.schedule,
            enabled: controller.paymentReminderEnabled.value,
            leadingGradient: const LinearGradient(
              colors: [Color(0xFF3DDC97), Color(0xFF1CB5E0)],
            ),
            subtitle: ResponsiveText(
              text: controller.paymentReminderEnabled.value
                  ? 'selected_time_for_the_reminder'
                  : 'enable_payment_reminder_to_change_time',
              fontSize: 11.2,
              fontWeight: FontWeight.w500,
              color: controller.paymentReminderEnabled.value
                  ? const Color(0xFFB8C1D1)
                  : const Color(0xFF6D7485),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SettingValuePill(
                  text: controller.selectedReminderTime.value,
                  accent: controller.paymentReminderEnabled.value
                      ? const Color(0xFF3DDC97)
                      : const Color(0xFF4A4F60),
                  textColor: controller.paymentReminderEnabled.value
                      ? const Color(0xFF0E1613)
                      : const Color(0xFFA2A9B8),
                ),
                const SizedBox(width: 10),
                Icon(
                  Icons.chevron_right,
                  color: controller.paymentReminderEnabled.value
                      ? const Color(0xFF95A0B6)
                      : const Color(0xFF555C6A),
                  size: 22,
                ),
              ],
            ),
            onTap: controller.openReminderTimeSheet,
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
