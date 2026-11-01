class UserModel {
  final String fullName;
  final String academicId;
  final String email;

  UserModel({
    required this.fullName,
    required this.academicId,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'academicId': academicId,
        'email': email,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        fullName: json['fullName'] ?? '',
        academicId: json['academicId'] ?? '',
        email: json['email'] ?? '',
      );
}