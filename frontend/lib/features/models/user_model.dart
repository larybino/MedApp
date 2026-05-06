class UserModel {
  final int id;
  final String name;
  final String email;
  final String? gender;
  final String? phone;
  final String? birthDate;
  final String? association;
  final String? profilePicture;
  final String role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.gender,
    this.phone,
    this.birthDate,
    this.association,
    this.profilePicture,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      gender: json['gender'],
      phone: json['phone'],
      birthDate: json['birthDate'],
      association: json['association'],
      profilePicture: json['profilePicture'],
      role: json['role'],
    );
  }
}