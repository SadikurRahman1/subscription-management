import 'package:subscription_manage/core/exported_files/exported_file.dart';
import 'package:subscription_manage/feature/setting/presentation/controller/setting_controller.dart';
import '../controller/subscription_controller.dart';

String _currencySymbol() {
  if (Get.isRegistered<SettingController>()) {
    return Get.find<SettingController>().selectedCurrencySymbol;
  }

  return r'$';
}

class ToggleSummaryCard extends StatelessWidget {
  const ToggleSummaryCard({super.key, required this.controller});

  final SubscriptionController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isYearly = controller.selectedSpendFilter.value == 'Yearly';
      final title = isYearly ? 'yearly_spend' : 'monthly_spend';
      final value =
          '${_currencySymbol()} ${controller.selectedSpend.toStringAsFixed(0)}';
      final accent = isYearly
          ? const Color(0xFFFFC857)
          : const Color(0xFF52D1FF);

      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: AppColors.surfaceGradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderColor.withValues(alpha: 0.55)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: AppColors.isDarkMode ? 0.16 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ResponsiveText(
                    text: title,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onMainSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    controller.changeSpendFilter(
                      isYearly ? 'Monthly' : 'Yearly',
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedRotation(
                    turns: isYearly ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: accent.withOpacity(0.26)),
                      ),
                      child: Icon(Icons.swap_horiz, size: 18, color: accent),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ResponsiveText(
              text: value,
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: AppColors.onMainSecondary,
            ),
            const SizedBox(height: 12),
            // Active subscriptions pill (styled to match app)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.onMainSecondary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.onMainSecondary.withValues(alpha: 0.03)),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, size: 18, color: accent),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ResponsiveText(
                      text: 'saved_subscriptions_count'.trParams({
                        'count': controller.subscriptionCount.toString(),
                      }),
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onMainSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
