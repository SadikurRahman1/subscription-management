import 'package:subscription_manage/core/wrappers/custom_label.dart';
import 'package:subscription_manage/feature/subscription/presentation/widgets/subscription_tile.dart';
import 'package:subscription_manage/feature/subscription/presentation/widgets/toggle_summary_card.dart';
import '../../../../core/exported_files/exported_file.dart';
import '../controller/subscription_controller.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SubscriptionController controller = Get.find<SubscriptionController>();

    return Scaffold(
      backgroundColor: const Color(0xFF0C0F16),
      body: RepaintBoundary(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0C0F16), Color(0xFF121722), Color(0xFF0C0F16)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
              children: [
                const CustomTitle(title: 'Subscription Dashboard'),
                const SizedBox(height: 12),
                // Single toggleable summary card (monthly <-> yearly)
                ToggleSummaryCard(controller: controller),
                const SizedBox(height: 18),
                const CustomLabel(text: 'Subscriptions'),
                const SizedBox(height: 8),
                Column(
                  children: controller.subscriptions
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: SubscriptionTile(item: item),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


