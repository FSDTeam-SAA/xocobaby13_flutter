class LoginResponseModel {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final String role;

  LoginResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.role,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    String readString(dynamic value) => value?.toString() ?? '';
    String pickFirstString(List<dynamic> values) {
      for (final value in values) {
        final stringValue = readString(value);
        if (stringValue.isNotEmpty) {
          return stringValue;
        }
      }
      return '';
    }

    final data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'])
        : json;
    final userData = data['user'] is Map
        ? Map<String, dynamic>.from(data['user'])
        : data;

    final accessToken = pickFirstString([
      data['accessToken'],
      data['access_token'],
      data['token'],
      json['accessToken'],
      json['access_token'],
      json['token'],
    ]);
    var refreshToken = pickFirstString([
      data['refreshToken'],
      data['refresh_token'],
      json['refreshToken'],
      json['refresh_token'],
    ]);
    if (refreshToken.isEmpty) {
      refreshToken = accessToken;
    }
    final userId = pickFirstString([
      userData['id'],
      userData['_id'],
      data['userId'],
      data['_id'],
      json['userId'],
      json['_id'],
    ]);
    final role = pickFirstString([
      userData['role'],
      data['role'],
      json['role'],
    ]);

    return LoginResponseModel(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userId: userId,
      role: role,
    );
  }
}
