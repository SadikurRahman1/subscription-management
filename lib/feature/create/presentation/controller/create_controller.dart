
import '../../../../core/exported_files/exported_file.dart';

class CreateController extends GetxController {
	final TextEditingController subscriptionNameController = TextEditingController();
	final TextEditingController costController = TextEditingController();
	final TextEditingController noteController = TextEditingController();

	final RxString selectedCycle = 'YEARLY'.obs;
	final RxString selectedStartDate = '11/05/2026'.obs;
	final RxString selectedPaymentMethod = 'Card'.obs;
	final RxBool billingAlertEnabled = true.obs;

	final List<String> cycleOptions = ['Weekly', 'Monthly', 'Yearly'];
	final List<String> paymentMethods = ['Card', 'Bkash', 'Nagad', 'Cash'];

	void selectCycle(String cycle) => selectedCycle.value = cycle;

	void selectPaymentMethod(String method) => selectedPaymentMethod.value = method;

	void setBillingAlert(bool value) => billingAlertEnabled.value = value;

	Future<void> pickStartDate(BuildContext context) async {
		final DateTime initialDate = _safeParseDate(selectedStartDate.value) ?? DateTime.now();

		final DateTime? picked = await showDatePicker(
			context: context,
			initialDate: initialDate,
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

	void saveSubscription() {
		Get.snackbar(
			'Saved',
			'Subscription saved successfully',
			snackPosition: SnackPosition.BOTTOM,
			backgroundColor: const Color(0xFF1D2230),
			colorText: Colors.white,
			margin: const EdgeInsets.all(16),
		);
	}

	@override
	void onClose() {
		subscriptionNameController.dispose();
		costController.dispose();
		noteController.dispose();
		super.onClose();
	}
}