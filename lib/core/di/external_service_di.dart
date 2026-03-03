import 'package:app_pigeon/app_pigeon.dart';
import 'package:get/get.dart';
import 'package:xocobaby13/core/constants/api_endpoints.dart';
import 'package:xocobaby13/core/services/auth/xoco_refresh_token_manager.dart';

void externalServiceDI() {
  if (Get.isRegistered<AuthorizedPigeon>()) return;
  Get.put<AuthorizedPigeon>(
    AuthorizedPigeon(
      XocoRefreshTokenManager(ApiEndpoints.refreshToken),
      baseUrl: ApiEndpoints.baseUrl,
    ),
  );
}
