class UserModel {
  final int id;
  final String email;
  final String name;
  final String partnerCode;
  final int? partnerId;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.partnerCode,
    this.partnerId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      name: json['name'] as String,
      partnerCode: json['partnerCode'] as String,
      partnerId: json['partnerId'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'partnerCode': partnerCode,
        'partnerId': partnerId,
      };
}
