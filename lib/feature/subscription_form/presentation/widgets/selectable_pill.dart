import 'package:subscription_manage/core/exported_files/exported_file.dart';

class SelectablePill extends StatelessWidget {
  const SelectablePill({super.key, 
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: isSelected
              ? LinearGradient(colors: [AppColors.m1, AppColors.m2])
              : AppColors.surfaceGradient,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
              ? AppColors.m1
              : AppColors.borderColor.withValues(alpha: 0.55),
          ),
        ),
        child: ResponsiveText(
          text: label,
          fontSize: 12.5,
          fontWeight: FontWeight.w800,
          color: isSelected ? Colors.white : AppColors.onMainSecondary,
        ),
      ),
    );
  }
}
