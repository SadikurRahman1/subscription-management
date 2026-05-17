import 'package:subscription_manage/core/exported_files/exported_file.dart';

class PremiumTextField extends StatelessWidget {
  const PremiumTextField({super.key, 
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.prefixText,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final String? prefixText;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.surfaceGradient,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor.withValues(alpha: 0.55)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: TextStyle(color: AppColors.onMainColor, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.onMainSecondary.withValues(alpha: 0.8)),
          prefixText: prefixText,
          prefixStyle: TextStyle(color: AppColors.onMainColor, fontWeight: FontWeight.w700),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }
}
