import 'package:subscription_manage/core/exported_files/exported_file.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({
    super.key,
    this.showBackButton = false,
    required this.title,
  });

  final bool? showBackButton;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showBackButton == true) ...[
          InkWell(
            onTap: Get.back,
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
              text: title,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.onMainColor,
            ),
          ),
        ],
      ],
    );
  }
}
