import 'package:subscription_manage/core/exported_files/exported_file.dart';

class SubscriptionDetailsInfoTile extends StatelessWidget {
  const SubscriptionDetailsInfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.maxLines = 1,
  });

  final IconData icon;
  final String title;
  final String value;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.overlayColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderColor.withValues(alpha: 0.55),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.purple, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveText(
                  text: title,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onMainSecondary,
                ),
                const SizedBox(height: 4),
                ResponsiveText(
                  text: value,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onMainColor,
                  maxLines: maxLines,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}