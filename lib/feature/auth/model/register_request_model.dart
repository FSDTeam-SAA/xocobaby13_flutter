class RegisterRequest {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;

  const RegisterRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
    'password': password,
    'confirmPassword': confirmPassword,
  };

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      RegisterRequest(
        name: json['name'] as String? ?? '',
        email: json['email'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        password: json['password'] as String? ?? '',
        confirmPassword: json['confirmPassword'] as String? ?? '',
      );

  RegisterRequest copyWith({
    String? name,
    String? email,
    String? phone,
    String? password,
    String? confirmPassword,
  }) {
    return RegisterRequest(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }

  @override
  String toString() =>
      'RegisterRequest(name: $name, email: $email, phone: $phone, password: ****, confirmPassword: ****)';
}
