import 'package:subscription_manage/core/exported_files/exported_file.dart';
import 'package:subscription_manage/feature/setting/presentation/controller/setting_controller.dart';
import 'package:subscription_manage/feature/setting/presentation/widgets/setting_widgets.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});

  final SettingController controller = Get.isRegistered<SettingController>()
      ? Get.find<SettingController>()
      : Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0F16),
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        foregroundColor: Colors.white,
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF151824), Color(0xFF0C0F16)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: RepaintBoundary(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0C0F16), Color(0xFF10131C), Color(0xFF0C0F16)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
              children: [
              const SettingSectionHeader(title: 'GENERAL', accentColor: Color(0xFF52D1FF)),
              const SizedBox(height: 12),
              SettingCard(
                gradient: const LinearGradient(
                  colors: [Color(0xFF182233), Color(0xFF121826)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                children: [
                  Obx(
                    () => SettingTile(
                      title: 'Currency',
                      leadingIcon: Icons.currency_exchange,
                      leadingGradient: const LinearGradient(
                        colors: [Color(0xFFFF8A00), Color(0xFFFFC533)],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SettingValuePill(
                            text: controller.selectedCurrency.value,
                            accent: const Color(0xFFFFC857),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.chevron_right, color: Color(0xFF95A0B6), size: 22),
                        ],
                      ),
                      onTap: controller.openCurrencySheet,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => SettingTile(
                      title: 'Language',
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
                          const Icon(Icons.chevron_right, color: Color(0xFF95A0B6), size: 22),
                        ],
                      ),
                      onTap: controller.openLanguageSheet,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => SettingTile(
                      title: 'Theme',
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
                          const Icon(Icons.chevron_right, color: Color(0xFF95A0B6), size: 22),
                        ],
                      ),
                      onTap: controller.openThemeSheet,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const SettingSectionHeader(title: 'NOTIFICATIONS', accentColor: Color(0xFFFF7AB6)),
              const SizedBox(height: 12),
              SettingCard(
                gradient: const LinearGradient(
                  colors: [Color(0xFF281A2F), Color(0xFF141A29)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                children: [
                  Obx(
                    () => SettingTile(
                      title: 'Payment Reminder',
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
                            ? 'Selected time for the reminder'
                            : 'Enable payment reminder to change time',
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
              ),
              const SizedBox(height: 18),
              const SettingSectionHeader(title: 'SUPPORT', accentColor: Color(0xFF4DD4A8)),
              const SizedBox(height: 12),
              SettingCard(
                gradient: const LinearGradient(
                  colors: [Color(0xFF15261F), Color(0xFF121B18)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                children: [
                  SettingTile(
                    title: 'Contact Support',
                    leadingIcon: Icons.headset_mic_outlined,
                    leadingGradient: const LinearGradient(
                      colors: [Color(0xFF4DD4A8), Color(0xFF39C6F5)],
                    ),
                    subtitle: const ResponsiveText(
                      text: 'Send app, version, device, and OS details',
                      fontSize: 11.2,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFB8C1D1),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Color(0xFF95A0B6), size: 22),
                    onTap: controller.openSupportEmail,
                  ),
                  const SizedBox(height: 10),
                  SettingTile(
                    title: 'Rate Us',
                    leadingIcon: Icons.star_border,
                    leadingGradient: const LinearGradient(
                      colors: [Color(0xFFFFB84D), Color(0xFFFF7AB6)],
                    ),
                    subtitle: const ResponsiveText(
                      text: 'Tell us how the app feels',
                      fontSize: 11.2,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFB8C1D1),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Color(0xFF95A0B6), size: 22),
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const SettingSectionHeader(title: 'ABOUT', accentColor: Color(0xFF9C8CFF)),
              const SizedBox(height: 12),
              SettingCard(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E1631), Color(0xFF141724)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                children: [
                  SettingTile(
                    title: 'Privacy Policy',
                    leadingIcon: Icons.privacy_tip_outlined,
                    leadingGradient: const LinearGradient(
                      colors: [Color(0xFF9C8CFF), Color(0xFF62D0FF)],
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Color(0xFF95A0B6), size: 22),
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  SettingTile(
                    title: 'Terms and Conditions',
                    leadingIcon: Icons.description_outlined,
                    leadingGradient: const LinearGradient(
                      colors: [Color(0xFF8A7CFF), Color(0xFFFF7AB6)],
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Color(0xFF95A0B6), size: 22),
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const SettingSectionHeader(title: 'MORE INFO', accentColor: Color(0xFFFFC857)),
              const SizedBox(height: 12),
              SettingCard(
                gradient: const LinearGradient(
                  colors: [Color(0xFF241D14), Color(0xFF14171F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                children: [
                  SettingTile(
                    title: 'Version',
                    leadingIcon: Icons.info_outline,
                    leadingGradient: const LinearGradient(
                      colors: [Color(0xFFFFC857), Color(0xFFFF8A00)],
                    ),
                    trailing: SettingValuePill(
                      text: const String.fromEnvironment('APP_VERSION', defaultValue: '1.0.0'),
                      accent: const Color(0xFFFFC857),
                    ),
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  SettingTile(
                    title: 'More Apps',
                    leadingIcon: Icons.apps,
                    leadingGradient: const LinearGradient(
                      colors: [Color(0xFF52D1FF), Color(0xFF9C8CFF)],
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Color(0xFF95A0B6), size: 22),
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
