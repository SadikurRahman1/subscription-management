
import 'package:subscription_manage/core/wrappers/custom_label.dart';
import 'package:subscription_manage/feature/setting/presentation/controller/setting_controller.dart';
import 'package:subscription_manage/feature/create/presentation/widgets/payment_method_chip.dart';
import 'package:subscription_manage/feature/create/presentation/widgets/premium_text_field.dart';
import 'package:subscription_manage/feature/create/presentation/widgets/selectable_pill.dart';
import '../../../../core/exported_files/exported_file.dart';
import '../controller/create_controller.dart';

class CreateScreen extends StatelessWidget {
  CreateScreen({super.key});

  final CreateController controller = Get.isRegistered<CreateController>()
      ? Get.find<CreateController>()
      : Get.put(CreateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0F16),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0C0F16), Color(0xFF121722), Color(0xFF0C0F16)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 120),
            children: [
              const CustomTitle(title: 'create_subscription'),
              const SizedBox(height: 16),
              const CustomLabel(text: 'subscription_name'),
              const SizedBox(height: 8),
              PremiumTextField(
                controller: controller.subscriptionNameController,
                hintText: 'netflix_premium'.tr,
              ),
              const SizedBox(height: 14),
              const CustomLabel(text: 'cost'),
              const SizedBox(height: 8),
              PremiumTextField(
                controller: controller.costController,
                hintText: '00.00',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                prefixText: Get.find<SettingController>().selectedCurrencySymbol,
              ),
              const SizedBox(height: 14),
              const CustomLabel(text: 'payment_cycle'),
              const SizedBox(height: 10),
              Obx(
                () => Row(
                  children: controller.cycleOptions
                      .map(
                        (option) => Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: option != controller.cycleOptions.last ? 8 : 0,
                            ),
                            child: SelectablePill(
                              label: option,
                              isSelected: controller.selectedCycle.value == option,
                              onTap: () => controller.selectCycle(option),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 14),
              const CustomLabel(text: 'start_date'),
              const SizedBox(height: 8),
              Obx(
                () => _TapField(
                  value: controller.selectedStartDate.value,
                  icon: Icons.calendar_today,
                  onTap: () => controller.pickStartDate(context),
                ),
              ),
              const SizedBox(height: 14),
              const CustomLabel(text: 'payment_method'),
              const SizedBox(height: 10),
              Obx(
                () => Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: controller.paymentMethods
                      .map(
                        (method) => PaymentMethodChip(
                          label: method,
                          isSelected: controller.selectedPaymentMethod.value == method,
                          onTap: () => controller.selectPaymentMethod(method),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 14),
              // CustomLabel(text: 'Notification'),
              // const SizedBox(height: 8),
              // Obx(
              //   () => _NotificationTile(
              //     enabled: controller.billingAlertEnabled.value,
              //     onChanged: controller.setBillingAlert,
              //   ),
              // ),
              const SizedBox(height: 14),
              const CustomLabel(text: 'note_optional'),
              const SizedBox(height: 8),
              PremiumTextField(
                controller: controller.noteController,
                hintText: 'add_any_note'.tr,
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              _SaveButton(onTap: controller.saveSubscription),
            ],
          ),
        ),
      ),
    );
  }
}


class _TapField extends StatelessWidget {
  const _TapField({
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF171C27), Color(0xFF121722)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
        ),
        child: Row(
          children: [
            Expanded(
              child: ResponsiveText(
                text: value,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFE0E5F2),
              ),
            ),
            Icon(icon, color: const Color(0xFF8A7CFF), size: 20),
          ],
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFC857), Color(0xFFFF8A00)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF8A00).withValues(alpha: 0.33),
              blurRadius: 18,
              offset: const Offset(0, 9),
            ),
          ],
        ),
        child: const ResponsiveText(
          text: 'SAVE',
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Color(0xFF201100),
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
