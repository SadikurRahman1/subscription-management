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
              ? const LinearGradient(colors: [Color(0xFF8A7CFF), Color(0xFF4F46E5)])
              : AppColors.surfaceGradient,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFA698FF)
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
