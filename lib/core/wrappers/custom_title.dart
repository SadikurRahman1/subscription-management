import 'package:subscription_manage/core/exported_files/exported_file.dart';

class CustomTitle extends StatelessWidget {
  const CustomTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF52D1FF), Color(0xFF8A7CFF)],
            ),
          ),
        ),
        const SizedBox(width: 8),
        ResponsiveText(
          text: title,
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: AppColors.onMainColor,
          letterSpacing: 0.5,
        ),
      ],
    );
  }
}
