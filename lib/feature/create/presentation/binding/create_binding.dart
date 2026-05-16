
import '../../../../core/exported_files/exported_file.dart';
import '../controller/create_controller.dart';

class CreateBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateController());
  }
}