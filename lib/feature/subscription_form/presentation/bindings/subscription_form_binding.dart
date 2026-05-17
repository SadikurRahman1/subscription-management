import '../../../../core/exported_files/exported_file.dart';
import '../controller/subscription_form_controller.dart';

class SubscriptionFormBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SubscriptionFormController());
  }
}