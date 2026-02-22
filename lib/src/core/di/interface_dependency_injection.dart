import 'package:app_pigeon/app_pigeon.dart';
import 'package:get/get.dart';
import 'package:xocobaby13/feature/auth/implement/auth_interface_impl.dart';
import 'package:xocobaby13/feature/auth/interface/auth_interface.dart';

void initInterfaces() {
  Get.put<AuthInterface>(
    AuthInterfaceImpl(appPigeon: Get.find<AuthorizedPigeon>()),
  );
}
