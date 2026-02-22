class ResetPasswordRequestModel {
  final String email;
  final String otp;
  final String password;

  ResetPasswordRequestModel({
    required this.email,
    required this.otp,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {'email': email, 'otp': otp, 'password': password};
  }

  // Convert a Map to a ResetPasswordRequestModel object
  factory ResetPasswordRequestModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordRequestModel(
      email: json['email'],
      otp: json['otp'],
      password: json['password'],
    );
  }
}
