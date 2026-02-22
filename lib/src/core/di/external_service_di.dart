import 'package:app_pigeon/app_pigeon.dart';
import 'package:get/get.dart';
import 'package:xocobaby13/core/constants/api_endpoints.dart';

void externalServiceDI() {
  if (Get.isRegistered<AuthorizedPigeon>()) return;
  Get.put<AuthorizedPigeon>(
    AuthorizedPigeon(
      BasicRefreshTokenManager(ApiEndpoints.refreshToken),
      baseUrl: ApiEndpoints.baseUrl,
    ),
  );
}
