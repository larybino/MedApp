class UserModel {
  final int id;
  final String name;
  final String email;
  final double? weight;
  final String? gender;
  final String? phone;
  final String? birthDate;
  final String? association;
  final String? profilePicture;
  final String role;
  final String? memberCode;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.weight,
    this.gender,
    this.phone,
    this.birthDate,
    this.association,
    this.profilePicture,
    required this.role,
    this.memberCode,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      weight: (json['weight'] as num?)?.toDouble(),
      gender: json['gender'],
      phone: json['phone'],
      birthDate: json['birthDate'],
      association: json['association'],
      profilePicture: json['profilePicture'],
      role: json['role'],
      memberCode: json['memberCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'weight': weight,
      'gender': gender,
      'phone': phone,
      'birthDate': birthDate,
      'association': association,
      'profilePicture': profilePicture,
      'role': role,
      'memberCode': memberCode,
    };
  }
}