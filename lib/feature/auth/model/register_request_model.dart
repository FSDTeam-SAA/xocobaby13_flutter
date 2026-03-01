class RegisterRequest {
  final String fullName;
  final String email;
  final String password;
  final String role;

  const RegisterRequest({
    required this.fullName,
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'email': email,
    'password': password,
    'role': role,
  };

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      RegisterRequest(
        fullName: json['fullName'] as String? ?? json['name'] as String? ?? '',
        email: json['email'] as String? ?? '',
        password: json['password'] as String? ?? '',
        role: json['role'] as String? ?? '',
      );

  RegisterRequest copyWith({
    String? fullName,
    String? email,
    String? password,
    String? role,
  }) {
    return RegisterRequest(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }

  @override
  String toString() =>
      'RegisterRequest(fullName: $fullName, email: $email, password: ****, role: $role)';
}
