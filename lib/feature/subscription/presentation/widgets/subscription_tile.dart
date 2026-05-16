import 'package:subscription_manage/core/exported_files/exported_file.dart';
import 'package:subscription_manage/feature/subscription/presentation/controller/subscription_controller.dart';

class SubscriptionTile extends StatelessWidget {
  const SubscriptionTile({super.key, required this.item});

  final SubscriptionItem item;

  @override
  Widget build(BuildContext context) {
    final bool isExpired = item.status == SubscriptionStatus.expired;
    final bool isUpcoming = item.status == SubscriptionStatus.upcoming;

    final String badgeText = isExpired
        ? 'Expired'
        : isUpcoming
            ? '${item.daysLeft} days'
            : '${item.daysLeft} left';

    final Color badgeColor = isExpired
        ? const Color(0xFFFF6B6B)
        : isUpcoming
            ? const Color(0xFFFFC857)
            : const Color(0xFF52D1FF);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF171C27), Color(0xFF121722)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveText(
                  text: item.name,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
                const SizedBox(height: 3),
                ResponsiveText(
                  text: '${item.cycle} - ${item.nextBilling}',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFB8C1D1),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ResponsiveText(
                text: '\$ ${item.amount.toStringAsFixed(0)}',
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: badgeColor.withValues(alpha: 0.48)),
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
    );
  }
}
