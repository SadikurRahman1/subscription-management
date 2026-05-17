import 'package:subscription_manage/core/exported_files/exported_file.dart';

class PaymentMethodChip extends StatelessWidget {
  const PaymentMethodChip({super.key, 
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
        width: 64,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(colors: [Color(0xFF52D1FF), Color(0xFF1CB5E0)])
              : AppColors.surfaceGradient,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF7CE4FF)
                : AppColors.borderColor.withValues(alpha: 0.55),
          ),
        ),
        child: ResponsiveText(
          text: label,
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          color: isSelected ? const Color(0xFF05151D) : AppColors.onMainSecondary,
        ),
      ),
    );
  }
}
