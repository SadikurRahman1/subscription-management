import 'package:subscription_manage/core/exported_files/exported_file.dart';

class CustomLabel extends StatelessWidget {
  const CustomLabel({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return ResponsiveText(
      text: text,
      fontSize: 13,
      fontWeight: FontWeight.w800,
      color: Colors.white,
      letterSpacing: 0.6,
    );
  }
}