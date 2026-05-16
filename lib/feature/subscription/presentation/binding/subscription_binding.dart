import 'package:subscription_manage/feature/subscription/presentation/controller/subscription_controller.dart';

import '../../../../core/exported_files/exported_file.dart';

class SubscriptionBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SubscriptionController());
  }
}