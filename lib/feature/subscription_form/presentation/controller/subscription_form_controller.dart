import '../../../../core/exported_files/exported_file.dart';
import '../../../../core/models/subscription_model.dart';
import '../../../../core/services/storage_services/subscription_storage_service.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../../../subscription/presentation/controller/subscription_controller.dart';

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

class SubscriptionFormController extends GetxController {
  SubscriptionFormController({this.editingSubscription});

  final SubscriptionModel? editingSubscription;

  final TextEditingController subscriptionNameController =
      TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  final RxString selectedCycle = 'Monthly'.obs;
  final RxString selectedStartDate = _formatDate(DateTime.now()).obs;
  final RxString selectedPaymentMethod = 'Cash'.obs;
  final RxBool billingAlertEnabled = true.obs;
  final RxList<SubscriptionModel> savedSubscriptions =
      <SubscriptionModel>[].obs;

  final List<String> cycleOptions = ['Weekly', 'Monthly', 'Yearly'];
  final List<String> paymentMethods = ['Card', 'Bkash', 'Nagad', 'Cash'];

  final SubscriptionStorageService _storageService =
      SubscriptionStorageService.instance;

  bool get isEditing => editingSubscription != null;

  @override
  void onInit() {
    super.onInit();
    if (editingSubscription != null) {
      _loadEditingSubscription(editingSubscription!);
    }
  }

  void _loadEditingSubscription(SubscriptionModel subscription) {
    subscriptionNameController.text = subscription.subscriptionName;
    costController.text = subscription.cost.toStringAsFixed(2);
    noteController.text = subscription.note ?? '';
    selectedCycle.value = subscription.paymentCycle;
    selectedStartDate.value = _formatDate(subscription.startDate);
    selectedPaymentMethod.value = subscription.paymentMethod;
  }

  void selectCycle(String cycle) => selectedCycle.value = cycle;

  void selectPaymentMethod(String method) =>
      selectedPaymentMethod.value = method;

  void setBillingAlert(bool value) => billingAlertEnabled.value = value;

  Future<void> loadSavedSubscriptions() async {
    savedSubscriptions.assignAll(await _storageService.readSubscriptions());
  }

  Future<void> pickStartDate(BuildContext context) async {
    final DateTime initialDate =
        _safeParseDate(selectedStartDate.value) ?? DateTime.now();

    final bool useDarkPicker = Theme.of(context).brightness == Brightness.dark;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: (useDarkPicker ? ThemeData.dark() : ThemeData.light()).copyWith(
            colorScheme: ColorScheme(
              brightness: useDarkPicker ? Brightness.dark : Brightness.light,
              primary: AppColors.purple,
              onPrimary: AppColors.white,
              secondary: AppColors.primary,
              onSecondary: AppColors.white,
              error: AppColors.danger,
              onError: AppColors.white,
              surface:
                  useDarkPicker ? AppColors.darkMainColor : AppColors.lightMainColor,
              onSurface: useDarkPicker
                  ? AppColors.darkPrimaryText
                  : AppColors.lightPrimaryText,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor:
                  useDarkPicker ? AppColors.darkMainColor : AppColors.lightMainColor,
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

  Future<void> saveSubscription() async {
    final String subscriptionName = subscriptionNameController.text.trim();
    final String rawCost = costController.text.trim();
    final double? cost = double.tryParse(rawCost);
    final DateTime? startDate = _safeParseDate(selectedStartDate.value);

    if (subscriptionName.isEmpty) {
      Get.snackbar(
        'Validation error',
        'Please enter a subscription name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1D2230),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    if (cost == null) {
      Get.snackbar(
        'Validation error',
        'Please enter a valid cost',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1D2230),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    if (isEditing) {
      final SubscriptionModel updated = SubscriptionModel(
        id: editingSubscription!.id,
        subscriptionName: subscriptionName,
        cost: cost,
        paymentCycle: selectedCycle.value,
        startDate: startDate ?? editingSubscription!.startDate,
        paymentMethod: selectedPaymentMethod.value,
        note: noteController.text.trim().isEmpty
            ? null
            : noteController.text.trim(),
        createdAt: editingSubscription!.createdAt,
      );

      await _storageService.updateSubscription(updated);
      if (Get.isRegistered<SubscriptionController>()) {
        await Get.find<SubscriptionController>().loadSubscriptions();
      }
      Get.back();
      return;
    }

    final SubscriptionModel subscription = SubscriptionModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      subscriptionName: subscriptionName,
      cost: cost,
      paymentCycle: selectedCycle.value,
      startDate: startDate ?? DateTime.now(),
      paymentMethod: selectedPaymentMethod.value,
      note: noteController.text.trim().isEmpty
          ? null
          : noteController.text.trim(),
      createdAt: DateTime.now(),
    );

    await _storageService.saveSubscription(subscription);
    savedSubscriptions.add(subscription);

    // Reschedule reminders when a new subscription is added
    try {
      await NotificationService.rescheduleAll();
    } catch (_) {}

    if (Get.isRegistered<SubscriptionController>()) {
      await Get.find<SubscriptionController>().loadSubscriptions();
    }

    subscriptionNameController.clear();
    costController.clear();
    noteController.clear();
    selectedCycle.value = 'Monthly';
    selectedStartDate.value = _formatDate(DateTime.now());
    selectedPaymentMethod.value = 'Card';

    Get.snackbar(
      'Saved',
      'Subscription saved locally',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1D2230),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );

    Get.offAllNamed(AppRoutes.mainBottomNavScreen, arguments: 0);
  }

  @override
  void onClose() {
    subscriptionNameController.dispose();
    costController.dispose();
    noteController.dispose();
    super.onClose();
  }
}