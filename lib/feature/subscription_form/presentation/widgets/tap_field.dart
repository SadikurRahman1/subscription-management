import 'package:subscription_manage/core/exported_files/exported_file.dart';

class TapField extends StatelessWidget {
  const TapField({super.key, 
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          gradient: AppColors.surfaceGradient,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.borderColor.withValues(alpha: 0.55),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: ResponsiveText(
                text: value,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.onMainColor,
              ),
            ),
            Icon(icon, color: AppColors.purple, size: 20),
          ],
        ),
      ),
    );
  }
}