import 'package:subscription_manage/core/exported_files/exported_file.dart';

class SubscriptionDetailsStatusBadge extends StatelessWidget {
  const SubscriptionDetailsStatusBadge({
    super.key,
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: ResponsiveText(
        text: text,
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: color,
      ),
    );
  }
}