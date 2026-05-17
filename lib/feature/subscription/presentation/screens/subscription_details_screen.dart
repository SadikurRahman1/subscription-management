import 'package:subscription_manage/core/models/subscription_model.dart';
import 'package:subscription_manage/feature/setting/presentation/controller/setting_controller.dart';

import '../../../../core/exported_files/exported_file.dart';
import '../controller/subscription_controller.dart';
import 'subscription_update_screen.dart';

class SubscriptionDetailsScreen extends StatelessWidget {
  const SubscriptionDetailsScreen({super.key, required this.subscriptionId});

  final String subscriptionId;

  @override
  Widget build(BuildContext context) {
    final SubscriptionController controller =
        Get.find<SubscriptionController>();

    return Scaffold(
      backgroundColor: const Color(0xFF0C0F16),
      body: SafeArea(
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
                    const ResponsiveText(
                      text: 'subscription_not_found',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    const ResponsiveText(
                      text: 'it_may_have_been_deleted_already',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFB8C1D1),
                    ),
                    const SizedBox(height: 18),
                    _ActionButton(
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
          final bool isExpired = daysLeft <= 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => Get.back(),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: ResponsiveText(
                        text: 'subscription_details',
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF171C27), Color(0xFF121722)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.07),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ResponsiveText(
                                  text: subscription.subscriptionName,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 6),
                                ResponsiveText(
                                  text: 'subscription_plan'.trParams({
                                    'cycle': subscription.paymentCycle,
                                  }),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFB8C1D1),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          _StatusBadge(
                            text: isExpired ? 'expired'.tr : 'days_left'.trParams({'days': daysLeft.toString()}),
                            color: isExpired
                                ? const Color(0xFFFF6B6B)
                                : const Color(0xFF52D1FF),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _InfoTile(
                        icon: Icons.payments_outlined,
                        title: 'cost',
                        value:
                            '${_currencySymbol()} ${subscription.cost.toStringAsFixed(2)}',
                      ),
                      const SizedBox(height: 12),
                      _InfoTile(
                        icon: Icons.calendar_today_outlined,
                        title: 'start_date',
                        value: _formatDate(subscription.startDate),
                      ),
                      const SizedBox(height: 12),
                      _InfoTile(
                        icon: Icons.event_available_outlined,
                        title: 'renewal',
                        value: _formatDate(_expiryDate(subscription)),
                      ),
                      const SizedBox(height: 12),
                      _InfoTile(
                        icon: Icons.credit_card_outlined,
                        title: 'payment_method',
                        value: subscription.paymentMethod,
                      ),
                      if (subscription.note != null &&
                          subscription.note!.trim().isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _InfoTile(
                          icon: Icons.notes_outlined,
                          title: 'note',
                          value: subscription.note!.trim(),
                          maxLines: 4,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        text: 'update',
                        color: const Color(0xFF8A7CFF),
                        onTap: () => Get.to(
                          () => const SubscriptionUpdateScreen(),
                          binding: BindingsBuilder(() {
                            Get.put(SubscriptionUpdateController(subscription));
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionButton(
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
        backgroundColor: const Color(0xFF171C27),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const ResponsiveText(
          text: 'delete_subscription',
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
        content: const ResponsiveText(
          text: 'this_action_cannot_be_undone',
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFFB8C1D1),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              foregroundColor: Colors.white,
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

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
    this.maxLines = 1,
  });

  final IconData icon;
  final String title;
  final String value;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF8A7CFF), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveText(
                  text: title,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF8F99AB),
                ),
                const SizedBox(height: 4),
                ResponsiveText(
                  text: value,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  maxLines: maxLines,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.text, required this.color});

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

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.text,
    required this.color,
    required this.onTap,
  });

  final String text;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withValues(alpha: 0.82)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.26),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ResponsiveText(
          text: text,
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }
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

int _remainingDays(SubscriptionModel subscription) {
  final DateTime today = DateUtils.dateOnly(DateTime.now());
  return _expiryDate(subscription).difference(today).inDays;
}

String _formatDate(DateTime date) {
  final String day = date.day.toString().padLeft(2, '0');
  final String month = date.month.toString().padLeft(2, '0');
  final String year = date.year.toString();
  return '$day/$month/$year';
}
