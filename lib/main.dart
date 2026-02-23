import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_pigeon/app_pigeon.dart';
import 'package:xocobaby13/core/di/external_service_di.dart';
import 'package:xocobaby13/core/theme/app_theme.dart';
import 'package:xocobaby13/feature/auth/implement/auth_interface_impl.dart';
import 'package:xocobaby13/feature/auth/interface/auth_interface.dart';
import 'package:xocobaby13/feature/auth/presentation/routes/auth_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _initDependencies();
  runApp(const MyApp());
}

void _initDependencies() {
  externalServiceDI();
  if (!Get.isRegistered<AuthInterface>()) {
    Get.put<AuthInterface>(
      AuthInterfaceImpl(appPigeon: Get.find<AuthorizedPigeon>()),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Xocobaby13',
      theme: AppTheme.light,
      initialRoute: AuthRouteNames.onboardingSplash,
      getPages: AuthRoutes.pages,
    );
  }
}
