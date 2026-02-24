import 'package:get/get.dart';

class NavigationController extends GetxController {
  final RxInt selectedTabIndex = 3.obs;

  void setTabIndex(int index) {
    selectedTabIndex.value = index;
  }

  static NavigationController instance() {
    if (Get.isRegistered<NavigationController>()) {
      return Get.find<NavigationController>();
    }
    return Get.put<NavigationController>(NavigationController());
  }
}
