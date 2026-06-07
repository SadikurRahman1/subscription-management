import '../../../../core/exported_files/exported_file.dart';
import '../../../../core/models/subscription_model.dart';
import '../../../../core/services/storage_services/subscription_storage_service.dart';

class SubscriptionController extends GetxController {
  final RxString selectedSpendFilter = 'Monthly'.obs;
  final RxBool isLoading = false.obs;
  final RxList<SubscriptionModel> subscriptions = <SubscriptionModel>[].obs;

  final List<String> spendFilters = ['Monthly', 'Yearly'];

  final SubscriptionStorageService _storageService =
      SubscriptionStorageService.instance;

  @override
  void onInit() {
    super.onInit();
    loadSubscriptions();
  }

  void changeSpendFilter(String filter) {
    selectedSpendFilter.value = filter;
  }

  Future<void> loadSubscriptions() async {
    isLoading.value = true;
    try {
      final List<SubscriptionModel> loadedSubscriptions = await _storageService
          .readSubscriptions();
      loadedSubscriptions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      subscriptions.assignAll(loadedSubscriptions);
    } finally {
      isLoading.value = false;
    }
  }

  List<SubscriptionModel> get allSubscriptions => subscriptions;

  List<SubscriptionModel> get monthlySubscriptions => subscriptions
      .where((item) => item.paymentCycle == 'Monthly')
      .toList(growable: false);

  List<SubscriptionModel> get yearlySubscriptions => subscriptions
      .where((item) => item.paymentCycle == 'Yearly')
      .toList(growable: false);

  int _cycleDurationDays(String paymentCycle) {
    switch (paymentCycle) {
      case 'Weekly':
        return 7;
      case 'Monthly':
        return 30;
      case 'Yearly':
        return 365;
      default:
        return 30;
    }
  }

  int remainingDays(SubscriptionModel item) {
    final DateTime today = DateUtils.dateOnly(DateTime.now());
    final DateTime startDate = DateUtils.dateOnly(item.startDate);
    final DateTime expiryDate = startDate.add(
      Duration(days: _cycleDurationDays(item.paymentCycle)),
    );
    return expiryDate.difference(today).inDays;
  }

  List<SubscriptionModel> get upcomingSubscriptions =>
      subscriptions
          .where((item) {
            final int daysLeft = remainingDays(item);
            return daysLeft > 0 && daysLeft <= 4;
          })
          .toList(growable: false)
        ..sort((a, b) => remainingDays(a).compareTo(remainingDays(b)));

  double get monthlySpend => subscriptions.fold(0, (sum, item) {
        double add = 0;
        switch (item.paymentCycle) {
          case 'Weekly':
            // Weekly to monthly: weeks per year / months per year
            add = item.cost * 52.15 / 12.0;
            break;
          case 'Monthly':
            add = item.cost;
            break;
          case 'Yearly':
            add = item.cost / 12.0;
            break;
          default:
            add = item.cost;
        }
        return sum + add;
      });

  double get yearlySpend => subscriptions.fold(0, (sum, item) {
        double add = 0;
        switch (item.paymentCycle) {
          case 'Weekly':
            add = item.cost * 52.15;
            break;
          case 'Monthly':
            add = item.cost * 12.0;
            break;
          case 'Yearly':
            add = item.cost;
            break;
          default:
            add = item.cost * 12.0;
        }
        return sum + add;
      });

  int get subscriptionCount => subscriptions.length;

  double get selectedSpend {
    if (selectedSpendFilter.value == 'Monthly') return monthlySpend;
    if (selectedSpendFilter.value == 'Yearly') return yearlySpend;
    return monthlySpend;
  }

  String get selectedSpendCaption {
    if (selectedSpendFilter.value == 'Monthly') return 'Bills this month';
    if (selectedSpendFilter.value == 'Yearly') return 'Bills this year';
    return 'All subscriptions spend';
  }

  Future<void> deleteSubscription(String id) async {
    await _storageService.deleteSubscription(id);
    await loadSubscriptions();
  }

  Future<void> updateSubscription(SubscriptionModel subscription) async {
    await _storageService.updateSubscription(subscription);
    await loadSubscriptions();
  }
}
