final class RegisterValidationModel implements Exception {
  final String? name;
  final String? image;
  final String? mobile;
  final int? city;
  final String? password;
  final String? passwordConfirmation;
  final String? message;

  const RegisterValidationModel({
    this.name,
    this.image,
    this.mobile,
    this.city,
    this.password,
    this.passwordConfirmation,
    this.message,
  });

  factory RegisterValidationModel.fromMap(
    Map<String, List> map,
    String message,
  ) {
    return RegisterValidationModel(
      name: map['name']?.join('\n'),
      mobile: map['mobile']?.join('\n'),
      password: map['password']?.join('\n'),
      passwordConfirmation: map['password_confirmation']?.join('\n'),
      message: message,
    );
  }

  Map<String, String> toMap() {
    return {
      'name': name!,
      'mobile': mobile!,
      'city': '$city',
      'password': password!,
      'password_confirmation': passwordConfirmation!,
    };
  }

  Map<String, String> toUserMap() {
    return {
      'user[name]': name!,
      'user[mobile]': mobile!,
      'user[city]': '$city',
      'user[password]': password!,
      'user[password_confirmation]': passwordConfirmation!,
    };
  }
}
