import 'package:subscription_manage/core/models/subscription_model.dart';
import 'package:subscription_manage/core/wrappers/custom_appbar.dart';
import 'package:subscription_manage/core/wrappers/custom_label.dart';
import 'package:subscription_manage/feature/subscription_form/presentation/widgets/payment_method_chip.dart';
import 'package:subscription_manage/feature/subscription_form/presentation/widgets/premium_text_field.dart';
import 'package:subscription_manage/feature/subscription_form/presentation/widgets/selectable_pill.dart';
import 'package:subscription_manage/feature/subscription_form/presentation/widgets/tap_field.dart';
import '../../../../core/exported_files/exported_file.dart';
import '../../../setting/presentation/controller/setting_controller.dart';
import '../controller/subscription_form_controller.dart';

class SubscriptionFormScreen extends StatelessWidget {
  const SubscriptionFormScreen({
    super.key,
    this.subscription,
    this.showBackButton = true,
    this.onBack,
  });

  final SubscriptionModel? subscription;
  final bool showBackButton;
  final VoidCallback? onBack;

  bool get _isEditing => subscription != null;

  String get _title =>
      _isEditing ? 'Update Subscription' : 'create_subscription';

  String get _saveButtonText => _isEditing ? 'UPDATE' : 'SAVE';

  @override
  Widget build(BuildContext context) {
    final SubscriptionFormController controller =
        Get.find<SubscriptionFormController>();
    final String currencySymbol =
        Get.find<SettingController>().selectedCurrencySymbol;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Container(
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
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 120),
            children: [
              CustomAppbar(showBackButton: true, title: _title),

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
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                prefixText: currencySymbol,
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
                              right: option != controller.cycleOptions.last
                                  ? 8
                                  : 0,
                            ),
                            child: SelectablePill(
                              label: option,
                              isSelected:
                                  controller.selectedCycle.value == option,
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
                () => TapField(
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
                          isSelected:
                              controller.selectedPaymentMethod.value ==
                              method,
                          onTap: () => controller.selectPaymentMethod(method),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 14),
              const CustomLabel(text: 'note_optional'),
              const SizedBox(height: 8),
              PremiumTextField(
                controller: controller.noteController,
                hintText: 'add_any_note'.tr,
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              _SaveButton(
                text: _saveButtonText,
                onTap: controller.saveSubscription,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.text, required this.onTap});

  final String text;
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
            colors: [AppColors.m1, AppColors.m2],
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
        child: ResponsiveText(
          text: text,
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF201100),
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
