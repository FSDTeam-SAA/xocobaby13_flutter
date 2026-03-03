import 'package:app_pigeon/app_pigeon.dart';

class XocoRefreshTokenManager implements RefreshTokenManagerInterface {
  XocoRefreshTokenManager(this.url);

  @override
  final String url;

  @override
  Future<bool> shouldRefresh(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final int? statusCode = err.response?.statusCode;
    final bool isUnauthorized = statusCode == 401;
    final bool looksLikeExpiredToken403 =
        statusCode == 403 && _looksLikeExpiredTokenMessage(err.response?.data);
    if (!isUnauthorized && !looksLikeExpiredToken403) return false;

    final String path = err.requestOptions.path.toLowerCase();
    if (path.contains('/auth/login') || path.contains('/auth/refresh-token')) {
      return false;
    }
    return true;
  }

  bool _looksLikeExpiredTokenMessage(dynamic data) {
    final String text;
    if (data is Map && data['message'] != null) {
      text = data['message'].toString().toLowerCase();
    } else {
      text = data?.toString().toLowerCase() ?? '';
    }
    return (text.contains('expired') || text.contains('expire')) &&
        (text.contains('token') || text.contains('jwt'));
  }

  @override
  Future<RefreshTokenResponse> refreshToken({
    required String refreshToken,
    required Dio dio,
  }) async {
    final Response<dynamic> res = await dio.post(
      url,
      data: <String, dynamic>{
        'refreshToken': refreshToken,
        'refresh_token': refreshToken,
      },
    );

    final Map<String, dynamic> body = res.data is Map
        ? Map<String, dynamic>.from(res.data)
        : <String, dynamic>{};
    final dynamic rawData = body['data'];
    final Map<String, dynamic> payload = rawData is Map
        ? Map<String, dynamic>.from(rawData)
        : body;

    String readString(dynamic value) => value?.toString().trim() ?? '';

    String pickFirstString(List<dynamic> values) {
      for (final dynamic value in values) {
        final String text = readString(value);
        if (text.isNotEmpty) return text;
      }
      return '';
    }

    final String nextAccessToken = pickFirstString(<dynamic>[
      payload['accessToken'],
      payload['access_token'],
      payload['token'],
      body['accessToken'],
      body['access_token'],
      body['token'],
    ]);
    if (nextAccessToken.isEmpty) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
        error: 'Refresh endpoint did not return an access token.',
      );
    }

    final String nextRefreshToken = pickFirstString(<dynamic>[
      payload['refreshToken'],
      payload['refresh_token'],
      body['refreshToken'],
      body['refresh_token'],
      refreshToken,
    ]);

    Map<String, dynamic>? nextUserData;
    final dynamic user = payload['user'];
    if (user is Map) {
      nextUserData = Map<String, dynamic>.from(user);
    } else if (payload['id'] != null ||
        payload['_id'] != null ||
        payload['role'] != null) {
      nextUserData = Map<String, dynamic>.from(payload);
    }

    return RefreshTokenResponse(
      accessToken: nextAccessToken,
      refreshToken: nextRefreshToken,
      data: nextUserData,
    );
  }
}
