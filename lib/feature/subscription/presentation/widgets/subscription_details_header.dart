import 'package:subscription_manage/core/exported_files/exported_file.dart';

class SubscriptionDetailsHeader extends StatelessWidget {
  const SubscriptionDetailsHeader({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onBack,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.overlayColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.borderColor.withValues(alpha: 0.55),
              ),
            ),
            child: Icon(Icons.arrow_back, color: AppColors.onMainColor),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ResponsiveText(
            text: 'subscription_details',
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: AppColors.onMainColor,
          ),
        ),
      ],
    );
  }
}