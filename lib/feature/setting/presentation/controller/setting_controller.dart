import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:subscription_manage/core/exported_files/exported_file.dart';
import 'package:subscription_manage/core/localization/language_service.dart';

class CurrencyOption {
  const CurrencyOption({
    required this.code,
    required this.name,
    required this.symbol,
  });

  final String code;
  final String name;
  final String symbol;

  String get displayLabel => '$name ($symbol)';
}

class SettingController extends GetxController {
  static const String currencyCodeKey = 'currency_code_key';

  final RxString selectedCurrency = 'USD'.obs;
  final RxString selectedLanguage = 'English'.obs;
  final RxString selectedTheme = 'System'.obs;
  final RxBool paymentReminderEnabled = true.obs;
  final RxString selectedReminderCadence = '1 day'.obs;
  final RxString selectedReminderTime = '10:10 am'.obs;
  final RxInt selectedReminderHour = 10.obs;
  final RxString selectedReminderMinute = '10'.obs;
  final RxString selectedReminderPeriod = 'am'.obs;

  final List<CurrencyOption> currencyOptions = const [
    CurrencyOption(code: 'USD', name: 'US Dollar', symbol: r'$'),
    CurrencyOption(code: 'BDT', name: 'Bangladeshi Taka', symbol: '৳'),
    CurrencyOption(code: 'INR', name: 'Indian Rupee', symbol: '₹'),
    CurrencyOption(code: 'EUR', name: 'Euro', symbol: '€'),
    CurrencyOption(code: 'GBP', name: 'British Pound', symbol: '£'),
    CurrencyOption(code: 'JPY', name: 'Japanese Yen', symbol: '¥'),
    CurrencyOption(code: 'AUD', name: 'Australian Dollar', symbol: r'A$'),
    CurrencyOption(code: 'CAD', name: 'Canadian Dollar', symbol: r'C$'),
    CurrencyOption(code: 'CHF', name: 'Swiss Franc', symbol: 'CHF'),
    CurrencyOption(code: 'CNY', name: 'Chinese Yuan', symbol: '¥'),
  ];
  final List<String> languageOptions = ['English', 'Bangla'];
  final List<String> themeOptions = ['Light', 'System', 'Dark'];
  final List<String> reminderCadenceOptions = [
    'Today',
    '1 day',
    '3 day',
    '1 week',
  ];
  final List<int> reminderHourOptions = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  final List<String> reminderMinuteOptions = [
    '10',
    '20',
    '30',
    '40',
    '50',
    '60',
  ];
  final List<String> reminderPeriodOptions = ['am', 'pm'];

  @override
  void onInit() {
    super.onInit();
    _restoreCurrencyPreference();
    _restoreLanguagePreference();
  }

  void selectCurrency(String value) {
    final String code = _currencyCodeFromLabel(value) ?? value;
    selectedCurrency.value = code;
    STService().saveData(currencyCodeKey, code);
  }

  CurrencyOption get selectedCurrencyOption => currencyOptions.firstWhere(
    (option) => option.code == selectedCurrency.value,
    orElse: () => currencyOptions.first,
  );

  String get selectedCurrencyDisplayLabel =>
      selectedCurrencyOption.displayLabel;

  String get selectedCurrencySymbol => selectedCurrencyOption.symbol;

  String get selectedCurrencyName => selectedCurrencyOption.name;

  void _restoreCurrencyPreference() {
    final String? savedCurrencyCode = STService().getData(currencyCodeKey);
    if (savedCurrencyCode == null) {
      return;
    }

    final bool isKnownCurrency = currencyOptions.any(
      (option) => option.code == savedCurrencyCode,
    );

    if (isKnownCurrency) {
      selectedCurrency.value = savedCurrencyCode;
    }
  }

  void selectLanguage(String value) {
    _applyLanguage(value);
  }

  void selectTheme(String value) => selectedTheme.value = value;

  void selectReminderCadence(String value) =>
      selectedReminderCadence.value = value;

  void selectReminderTime(String value) => selectedReminderTime.value = value;

  void selectReminderHour(int value) {
    selectedReminderHour.value = value;
    _syncReminderTime();
  }

  void selectReminderMinute(String value) {
    selectedReminderMinute.value = value;
    _syncReminderTime();
  }

  void selectReminderPeriod(String value) {
    selectedReminderPeriod.value = value;
    _syncReminderTime();
  }

  void setPaymentReminderEnabled(bool value) =>
      paymentReminderEnabled.value = value;

  Future<void> _restoreLanguagePreference() async {
    final Locale? savedLocale = LanguageService.getSavedLocale();
    if (savedLocale == null) {
      await _applyLanguage('English');
      return;
    }

    selectedLanguage.value = _languageLabelFromLocale(savedLocale);
    Get.updateLocale(savedLocale);
  }

  Future<void> _applyLanguage(String language) async {
    final Locale locale = language == 'Bangla'
        ? const Locale('bn', 'US')
        : const Locale('en', 'US');

    selectedLanguage.value = language;
    Get.updateLocale(locale);
    await LanguageService.saveLocale(locale);
  }

  String _languageLabelFromLocale(Locale locale) {
    if (locale.languageCode == 'bn') {
      return 'Bangla';
    }

    return 'English';
  }

  Future<void> openCurrencySheet() {
    return _openSelectionSheet(
      title: 'choose_currency',
      options: currencyOptions.map((option) => option.displayLabel).toList(),
      selectedValue: selectedCurrencyDisplayLabel,
      onSelected: selectCurrency,
    );
  }

  Future<void> openLanguageSheet() {
    return _openSelectionSheet(
      title: 'choose_language',
      options: languageOptions,
      selectedValue: selectedLanguage.value,
      onSelected: selectLanguage,
    );
  }

  Future<void> openThemeSheet() {
    return _openSelectionSheet(
      title: 'choose_theme',
      options: themeOptions,
      selectedValue: selectedTheme.value,
      onSelected: selectTheme,
    );
  }

  Future<void> openReminderCadenceSheet() {
    return _openSelectionSheet(
      title: 'reminder_schedule',
      options: reminderCadenceOptions,
      selectedValue: selectedReminderCadence.value,
      onSelected: selectReminderCadence,
    );
  }

  Future<void> openReminderTimeSheet() {
    if (!paymentReminderEnabled.value) {
      return Future<void>.value();
    }

    return Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFF14151C),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 46,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                ResponsiveText(
                  text: 'reminder_time',
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Obx(
                  () => ResponsiveText(
                    text:
                        '${selectedReminderHour.value.toString().padLeft(2, '0')}:${selectedReminderMinute.value} ${selectedReminderPeriod.value}',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFB8C1D1),
                  ),
                ),
                const SizedBox(height: 16),
                const ResponsiveText(
                  text: 'hour',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Obx(
                  () => Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: reminderHourOptions
                        .map(
                          (hour) => ChoiceChip(
                            label: Text(hour.toString()),
                            selected: selectedReminderHour.value == hour,
                            selectedColor: const Color(0xFF8A7CFF),
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.05,
                            ),
                            disabledColor: Colors.white.withValues(alpha: 0.05),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: selectedReminderHour.value == hour
                                  ? Colors.white
                                  : const Color.fromARGB(255, 13, 14, 14),
                            ),
                            onSelected: (_) => selectReminderHour(hour),
                            showCheckmark: false,
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 14),
                const ResponsiveText(
                  text: 'minute',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Obx(
                  () => Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: reminderMinuteOptions
                        .map(
                          (minute) => ChoiceChip(
                            label: Text(minute),
                            selected: selectedReminderMinute.value == minute,
                            selectedColor: const Color(0xFF3DDC97),
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.05,
                            ),
                            disabledColor: Colors.white.withValues(alpha: 0.05),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: selectedReminderMinute.value == minute
                                  ? Colors.white
                                  : const Color.fromARGB(255, 13, 14, 14),
                            ),
                            onSelected: (_) => selectReminderMinute(minute),
                            showCheckmark: false,
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 14),
                const ResponsiveText(
                  text: 'am_pm',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Obx(
                  () => Wrap(
                    spacing: 8,
                    children: reminderPeriodOptions
                        .map(
                          (period) => ChoiceChip(
                            label: Text(period),
                            selected: selectedReminderPeriod.value == period,
                            selectedColor: const Color(0xFFFF6B6B),
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.05,
                            ),
                            disabledColor: Colors.white.withValues(alpha: 0.05),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: selectedReminderPeriod.value == period
                                  ? Colors.white
                                  : const Color.fromARGB(255, 13, 14, 14),
                            ),
                            onSelected: (_) => selectReminderPeriod(period),
                            showCheckmark: false,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _syncReminderTime() {
    selectedReminderTime.value =
        '${selectedReminderHour.value.toString().padLeft(2, '0')}:${selectedReminderMinute.value} ${selectedReminderPeriod.value}';
  }

  Future<void> openSupportEmail() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final deviceDetails = await _deviceDetails();

    final body = StringBuffer()
      ..writeln('App name: ${packageInfo.appName}')
      ..writeln(
        'App version: ${packageInfo.version} (${packageInfo.buildNumber})',
      )
      ..writeln('Device model: ${deviceDetails['model']}')
      ..writeln('OS version: ${deviceDetails['os']}')
      ..writeln('Language: ${selectedLanguage.value}')
      ..writeln('Theme: ${selectedTheme.value}')
      ..writeln('Currency: $selectedCurrencyDisplayLabel')
      ..writeln(
        'Reminder: ${paymentReminderEnabled.value ? 'Enabled' : 'Disabled'}',
      )
      ..writeln('Reminder cadence: ${selectedReminderCadence.value}')
      ..writeln('Reminder time: ${selectedReminderTime.value}');

    final mailUri = Uri(
      scheme: 'mailto',
      path: 'sadikur.dev@gmail.com',
      queryParameters: {
        'subject': 'Support request - ${packageInfo.appName}',
        'body': body.toString(),
      },
    );

    await launchUrl(mailUri, mode: LaunchMode.externalApplication);
  }

  Future<void> _openSelectionSheet({
    required String title,
    required List<String> options,
    required String selectedValue,
    required ValueChanged<String> onSelected,
  }) {
    return Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFF14151C),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 46,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              ResponsiveText(
                text: title,
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
              const SizedBox(height: 14),
              ...options.map(
                (option) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      onSelected(option);
                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: option == selectedValue
                            ? const Color(0xFF4F46E5).withValues(alpha: 0.25)
                            : Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: option == selectedValue
                              ? const Color(0xFF8A7CFF)
                              : Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: ResponsiveText(
                              text: option,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          if (option == selectedValue)
                            const Icon(
                              Icons.check_circle,
                              color: Color(0xFF8A7CFF),
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<Map<String, String>> _deviceDetails() async {
    final deviceInfo = DeviceInfoPlugin();

    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final androidInfo = await deviceInfo.androidInfo;
        return {
          'model': '${androidInfo.brand} ${androidInfo.model}',
          'os': 'Android ${androidInfo.version.release}',
        };
      }

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return {
          'model': iosInfo.utsname.machine,
          'os': '${iosInfo.systemName} ${iosInfo.systemVersion}',
        };
      }

      if (defaultTargetPlatform == TargetPlatform.macOS) {
        final macInfo = await deviceInfo.macOsInfo;
        return {'model': macInfo.model, 'os': macInfo.osRelease};
      }

      if (defaultTargetPlatform == TargetPlatform.windows) {
        final windowsInfo = await deviceInfo.windowsInfo;
        return {
          'model': windowsInfo.computerName,
          'os': windowsInfo.majorVersion.toString(),
        };
      }

      if (defaultTargetPlatform == TargetPlatform.linux) {
        final linuxInfo = await deviceInfo.linuxInfo;
        return {
          'model': linuxInfo.prettyName,
          'os': linuxInfo.version ?? 'Linux',
        };
      }
    } catch (_) {
      // Fall through to the generic fallback below.
    }

    return {'model': 'Unknown device', 'os': defaultTargetPlatform.name};
  }

  String? _currencyCodeFromLabel(String value) {
    for (final CurrencyOption option in currencyOptions) {
      if (option.displayLabel == value) {
        return option.code;
      }
    }

    return null;
  }
}
