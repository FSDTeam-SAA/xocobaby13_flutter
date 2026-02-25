class RegisterResponseModel {
  final bool success;
  final String message;
  final RegisterUserData? data;

  const RegisterResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? RegisterUserData.fromJson(Map<String, dynamic>.from(json['data']))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'success': success,
      'message': message,
    };
    if (data != null) map['data'] = data!.toJson();
    return map;
  }
}

class RegisterUserData {
  final String id;
  final String name;
  final String email;
  final String role;

  const RegisterUserData({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory RegisterUserData.fromJson(Map<String, dynamic> json) {
    String readString(dynamic value) => value?.toString() ?? '';
    return RegisterUserData(
      id: readString(json['_id']).isNotEmpty
          ? readString(json['_id'])
          : readString(json['id']),
      name: readString(json['name']),
      email: readString(json['email']),
      role: readString(json['role']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
    };
  }
}
