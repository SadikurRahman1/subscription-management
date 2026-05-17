import 'package:subscription_manage/core/wrappers/custom_label.dart';
import 'package:subscription_manage/core/models/subscription_model.dart';
import 'package:subscription_manage/feature/subscription/presentation/widgets/subscription_tile.dart';
import 'package:subscription_manage/feature/subscription/presentation/widgets/toggle_summary_card.dart';
import '../../../../core/exported_files/exported_file.dart';
import '../controller/subscription_controller.dart';
import 'subscription_details_screen.dart';

class SubscriptionScreen extends GetView<SubscriptionController> {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: RepaintBoundary(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.bgColor,
                AppColors.mainColor,
                AppColors.bgColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
              children: [
                const CustomTitle(title: 'subscription_dashboard'),
                const SizedBox(height: 12),
                // Single toggleable summary card (monthly <-> yearly)
                ToggleSummaryCard(controller: controller),
                const SizedBox(height: 18),
                Obx(() {
                  final List<SubscriptionModel> upcoming =
                      controller.upcomingSubscriptions;

                  if (upcoming.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(child: CustomLabel(text: 'upcoming')),
                          ResponsiveText(
                            text: 'upcoming_items'.trParams({
                              'count': upcoming.length.toString(),
                            }),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF8F99AB),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 114,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: upcoming.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final item = upcoming[index];
                            return SizedBox(
                              width: 280,
                              child: SubscriptionTile(
                                item: item,
                                onTap: () => Get.to(
                                  () => SubscriptionDetailsScreen(
                                    subscriptionId: item.id,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],
                  );
                }),
                const CustomLabel(text: 'subscriptions'),
                const SizedBox(height: 8),
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 28),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF8A7CFF),
                        ),
                      ),
                    );
                  }

                  if (controller.subscriptions.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: AppColors.surfaceGradient,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.borderColor.withValues(alpha: 0.55),
                        ),
                      ),
                      child: const ResponsiveText(
                        text:
                            'no_saved_subscriptions_yet_create_one_to_see_it_here',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFB8C1D1),
                      ),
                    );
                  }

                  return Column(
                    children: controller.subscriptions
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: SubscriptionTile(
                              item: item,
                              onTap: () => Get.to(
                                () => SubscriptionDetailsScreen(
                                  subscriptionId: item.id,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
