import 'package:subscription_manage/core/models/subscription_model.dart';
import 'package:subscription_manage/core/wrappers/custom_label.dart';
import 'package:subscription_manage/feature/create/presentation/widgets/payment_method_chip.dart';
import 'package:subscription_manage/feature/create/presentation/widgets/premium_text_field.dart';
import 'package:subscription_manage/feature/create/presentation/widgets/selectable_pill.dart';

import '../../../../core/exported_files/exported_file.dart';
import '../controller/subscription_controller.dart';

class SubscriptionUpdateController extends GetxController {
  SubscriptionUpdateController(this.initialSubscription);

  final SubscriptionModel initialSubscription;

  late final TextEditingController subscriptionNameController;
  late final TextEditingController costController;
  late final TextEditingController noteController;

  final RxString selectedCycle = ''.obs;
  final RxString selectedStartDate = ''.obs;
  final RxString selectedPaymentMethod = ''.obs;

  final List<String> cycleOptions = ['Weekly', 'Monthly', 'Yearly'];
  final List<String> paymentMethods = ['Card', 'Bkash', 'Nagad', 'Cash'];

  @override
  void onInit() {
    super.onInit();
    subscriptionNameController = TextEditingController(
      text: initialSubscription.subscriptionName,
    );
    costController = TextEditingController(
      text: initialSubscription.cost.toStringAsFixed(2),
    );
    noteController = TextEditingController(
      text: initialSubscription.note ?? '',
    );
    selectedCycle.value = initialSubscription.paymentCycle;
    selectedStartDate.value = _formatDate(initialSubscription.startDate);
    selectedPaymentMethod.value = initialSubscription.paymentMethod;
  }

  void selectCycle(String cycle) => selectedCycle.value = cycle;

  void selectPaymentMethod(String method) =>
      selectedPaymentMethod.value = method;

  Future<void> pickStartDate(BuildContext context) async {
    final DateTime current =
        _safeParseDate(selectedStartDate.value) ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF8A7CFF),
              surface: Color(0xFF171A22),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedStartDate.value = _formatDate(picked);
    }
  }

  Future<void> saveChanges() async {
    final String subscriptionName = subscriptionNameController.text.trim();
    final double? cost = double.tryParse(costController.text.trim());
    final DateTime? startDate = _safeParseDate(selectedStartDate.value);

    if (subscriptionName.isEmpty || cost == null) {
      Get.snackbar(
        'Validation error',
        'Please fill all required fields correctly',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1D2230),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    final SubscriptionModel updated = SubscriptionModel(
      id: initialSubscription.id,
      subscriptionName: subscriptionName,
      cost: cost,
      paymentCycle: selectedCycle.value,
      startDate: startDate ?? initialSubscription.startDate,
      paymentMethod: selectedPaymentMethod.value,
      note: noteController.text.trim().isEmpty
          ? null
          : noteController.text.trim(),
      createdAt: initialSubscription.createdAt,
    );

    await Get.find<SubscriptionController>().updateSubscription(updated);
    Get.back();
  }

  @override
  void onClose() {
    subscriptionNameController.dispose();
    costController.dispose();
    noteController.dispose();
    super.onClose();
  }
}

class SubscriptionUpdateScreen extends GetView<SubscriptionUpdateController> {
  const SubscriptionUpdateScreen({super.key});

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
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: ResponsiveText(
                      text: 'Update Subscription',
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomLabel(text: 'Subscription name'),
              const SizedBox(height: 8),
              PremiumTextField(
                controller: controller.subscriptionNameController,
                hintText: 'Netflix Premium',
              ),
              const SizedBox(height: 14),
              CustomLabel(text: 'Cost'),
              const SizedBox(height: 8),
              PremiumTextField(
                controller: controller.costController,
                hintText: '00.00',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                prefixText: '\$',
              ),
              const SizedBox(height: 14),
              CustomLabel(text: 'Payment cycle'),
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
              CustomLabel(text: 'Start Date'),
              const SizedBox(height: 8),
              Obx(
                () => _TapField(
                  value: controller.selectedStartDate.value,
                  icon: Icons.calendar_today,
                  onTap: () => controller.pickStartDate(context),
                ),
              ),
              const SizedBox(height: 14),
              CustomLabel(text: 'Payment Method'),
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
                              controller.selectedPaymentMethod.value == method,
                          onTap: () => controller.selectPaymentMethod(method),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 14),
              CustomLabel(text: 'Note (Optional)'),
              const SizedBox(height: 8),
              PremiumTextField(
                controller: controller.noteController,
                hintText: 'Add any note...',
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              _SaveButton(onTap: controller.saveChanges),
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
          text: 'UPDATE',
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Color(0xFF201100),
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  final String day = date.day.toString().padLeft(2, '0');
  final String month = date.month.toString().padLeft(2, '0');
  final String year = date.year.toString();
  return '$day/$month/$year';
}

DateTime? _safeParseDate(String value) {
  final List<String> parts = value.split('/');
  if (parts.length != 3) {
    return null;
  }

  final int? day = int.tryParse(parts[0]);
  final int? month = int.tryParse(parts[1]);
  final int? year = int.tryParse(parts[2]);

  if (day == null || month == null || year == null) {
    return null;
  }

  return DateTime(year, month, day);
}
