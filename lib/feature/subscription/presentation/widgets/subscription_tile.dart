import 'package:subscription_manage/core/exported_files/exported_file.dart';
import 'package:subscription_manage/core/models/subscription_model.dart';
import 'package:subscription_manage/feature/setting/presentation/controller/setting_controller.dart';

String _formatDate(DateTime date) {
  final String day = date.day.toString().padLeft(2, '0');
  final String month = date.month.toString().padLeft(2, '0');
  final String year = date.year.toString();
  return '$day/$month/$year';
}

String _formatAmount(double amount) {
  if (amount == amount.roundToDouble()) {
    return amount.toStringAsFixed(0);
  }

  return amount.toStringAsFixed(2);
}

String _localizedDaysLeft(int daysLeft) {
  if (daysLeft <= 0) {
    return 'expired'.tr;
  }

  if (daysLeft == 1) {
    return 'day_left'.tr;
  }

  return 'days_left'.trParams({'days': daysLeft.toString()});
}

String _currencySymbol() {
  if (Get.isRegistered<SettingController>()) {
    return Get.find<SettingController>().selectedCurrencySymbol;
  }

  return r'$';
}

class SubscriptionTile extends StatelessWidget {
  const SubscriptionTile({super.key, required this.item, this.onTap});

  final SubscriptionModel item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final String subtitle =
        '${item.paymentCycle} • ${_formatDate(item.startDate)}';
    final int daysLeft = controllerDaysLeft(item);
    final bool isExpired = daysLeft <= 0;
    final bool isWarning = !isExpired && daysLeft < 4;
    final String badgeText = _localizedDaysLeft(daysLeft);
        final Color badgeColor = isExpired
            ? AppColors.danger
            : isWarning
            ? AppColors.warning
            : AppColors.success;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: AppColors.surfaceGradient,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.borderColor.withValues(alpha: 0.55)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: AppColors.isDarkMode ? 0.14 : 0.08),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.m1, AppColors.m2],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.subscriptions,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResponsiveText(
                      text: item.subscriptionName,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: AppColors.onMainColor,
                    ),
                    const SizedBox(height: 3),
                    ResponsiveText(
                      text: subtitle,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onMainSecondary,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ResponsiveText(
                    text: '${_currencySymbol()} ${_formatAmount(item.cost)}',
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: AppColors.onMainColor,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: badgeColor.withValues(alpha: 0.48),
                      ),
                    ),
                    child: ResponsiveText(
                      text: badgeText,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: badgeColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

int controllerDaysLeft(SubscriptionModel item) {
  final DateTime today = DateUtils.dateOnly(DateTime.now());
  final DateTime startDate = DateUtils.dateOnly(item.startDate);
  final int durationDays = switch (item.paymentCycle) {
    'Weekly' => 7,
    'Monthly' => 30,
    'Yearly' => 365,
    _ => 30,
  };

  final DateTime expiryDate = startDate.add(Duration(days: durationDays));
  return expiryDate.difference(today).inDays;
}
