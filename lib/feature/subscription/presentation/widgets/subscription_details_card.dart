import 'package:subscription_manage/core/models/subscription_model.dart';

import 'package:subscription_manage/core/exported_files/exported_file.dart';

import 'subscription_details_info_tile.dart';
import 'subscription_details_status_badge.dart';

class SubscriptionDetailsCard extends StatelessWidget {
  const SubscriptionDetailsCard({
    super.key,
    required this.subscription,
    required this.daysLeft,
    required this.currencySymbol,
  });

  final SubscriptionModel subscription;
  final int daysLeft;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final bool isExpired = daysLeft <= 0;
    final bool isWarning = !isExpired && daysLeft < 4;
    final Color badgeColor = isExpired
      ? AppColors.danger
      : isWarning
        ? AppColors.warning
        : AppColors.success;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.surfaceGradient,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.borderColor.withValues(alpha: 0.55),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: AppColors.isDarkMode ? 0.2 : 0.08,
            ),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResponsiveText(
                      text: subscription.subscriptionName,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.onMainColor,
                    ),
                    const SizedBox(height: 6),
                    ResponsiveText(
                      text: 'subscription_plan'.trParams({
                        'cycle': subscription.paymentCycle,
                      }),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onMainSecondary,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SubscriptionDetailsStatusBadge(
                text: isExpired
                    ? 'expired'.tr
                    : 'days_left'.trParams({'days': daysLeft.toString()}),
                color: badgeColor,
              ),
            ],
          ),
          const SizedBox(height: 18),
          SubscriptionDetailsInfoTile(
            icon: Icons.payments_outlined,
            title: 'cost',
            value: '$currencySymbol ${subscription.cost.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 12),
          SubscriptionDetailsInfoTile(
            icon: Icons.calendar_today_outlined,
            title: 'start_date',
            value: _formatDate(subscription.startDate),
          ),
          const SizedBox(height: 12),
          SubscriptionDetailsInfoTile(
            icon: Icons.event_available_outlined,
            title: 'renewal',
            value: _formatDate(_expiryDate(subscription)),
          ),
          const SizedBox(height: 12),
          SubscriptionDetailsInfoTile(
            icon: Icons.credit_card_outlined,
            title: 'payment_method',
            value: subscription.paymentMethod,
          ),
          if (subscription.note != null &&
              subscription.note!.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            SubscriptionDetailsInfoTile(
              icon: Icons.notes_outlined,
              title: 'note',
              value: subscription.note!.trim(),
              maxLines: 4,
            ),
          ],
        ],
      ),
    );
  }
}

DateTime _expiryDate(SubscriptionModel subscription) {
  final int days = switch (subscription.paymentCycle) {
    'Weekly' => 7,
    'Monthly' => 30,
    'Yearly' => 365,
    _ => 30,
  };

  return DateUtils.dateOnly(subscription.startDate).add(Duration(days: days));
}

String _formatDate(DateTime date) {
  final String day = date.day.toString().padLeft(2, '0');
  final String month = date.month.toString().padLeft(2, '0');
  final String year = date.year.toString();
  return '$day/$month/$year';
}