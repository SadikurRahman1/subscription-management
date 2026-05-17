import 'package:subscription_manage/core/models/subscription_model.dart';
import 'package:subscription_manage/feature/setting/presentation/controller/setting_controller.dart';

import '../../../../core/exported_files/exported_file.dart';
import '../controller/subscription_controller.dart';
import '../../../subscription_form/presentation/screens/subscription_form_screen.dart';
import '../widgets/subscription_details_action_button.dart';
import '../widgets/subscription_details_card.dart';
import '../widgets/subscription_details_header.dart';

class SubscriptionDetailsScreen extends StatelessWidget {
  const SubscriptionDetailsScreen({super.key, required this.subscriptionId});

  final String subscriptionId;

  @override
  Widget build(BuildContext context) {
    final SubscriptionController controller =
        Get.find<SubscriptionController>();

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bgColor, AppColors.mainColor, AppColors.bgColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Obx(() {
            final SubscriptionModel? subscription = _findSubscription(
              controller.subscriptions,
              subscriptionId,
            );

            if (subscription == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ResponsiveText(
                        text: 'subscription_not_found',
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onMainColor,
                      ),
                      const SizedBox(height: 8),
                      ResponsiveText(
                        text: 'it_may_have_been_deleted_already',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onMainSecondary,
                      ),
                      const SizedBox(height: 18),
                      SubscriptionDetailsActionButton(
                        text: 'back',
                        color: const Color(0xFF8A7CFF),
                        onTap: () => Get.back(),
                      ),
                    ],
                  ),
                ),
              );
            }

            final int daysLeft = _remainingDays(subscription);

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SubscriptionDetailsHeader(onBack: Get.back),
                  const SizedBox(height: 18),
                  SubscriptionDetailsCard(
                    subscription: subscription,
                    daysLeft: daysLeft,
                    currencySymbol: _currencySymbol(),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: SubscriptionDetailsActionButton(
                          text: 'update',
                          color: const Color(0xFF8A7CFF),
                          onTap: () => Get.to(
                            () => SubscriptionFormScreen(subscription: subscription),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SubscriptionDetailsActionButton(
                          text: 'delete',
                          color: const Color(0xFFFF6B6B),
                          onTap: () =>
                              _confirmDelete(context, controller, subscription),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  SubscriptionModel? _findSubscription(
    List<SubscriptionModel> subscriptions,
    String id,
  ) {
    for (final SubscriptionModel item in subscriptions) {
      if (item.id == id) {
        return item;
      }
    }

    return null;
  }

  Future<void> _confirmDelete(
    BuildContext context,
    SubscriptionController controller,
    SubscriptionModel subscription,
  ) async {
    await Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.mainColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: ResponsiveText(
          text: 'delete_subscription',
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: AppColors.onMainColor,
        ),
        content: ResponsiveText(
          text: 'this_action_cannot_be_undone',
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.onMainSecondary,
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              foregroundColor: AppColors.white,
            ),
            onPressed: () async {
              Get.back();
              await controller.deleteSubscription(subscription.id);
              Get.back();
            },
            child: Text('delete'.tr),
          ),
        ],
      ),
    );
  }
}

String _currencySymbol() {
  if (Get.isRegistered<SettingController>()) {
    return Get.find<SettingController>().selectedCurrencySymbol;
  }

  return r'$';
}

int _remainingDays(SubscriptionModel subscription) {
  final DateTime today = DateUtils.dateOnly(DateTime.now());
  return _expiryDate(subscription).difference(today).inDays;
}

DateTime _expiryDate(SubscriptionModel subscription) {
  final int days = switch (subscription.paymentCycle) {
    'Weekly' => 7,
    'Monthly' => 30,
    'Yearly' => 365,
    _ => 30,
  };

  return DateUtils.dateOnly(subscription.startDate).add(Duration(days: days));
}
