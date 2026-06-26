class UserModel {
  final int id;
  final String email;
  final String name;
  final String partnerCode;
  final int? partnerId;
  final DateTime? termsAcceptedAt;
  final DateTime? privacyAcceptedAt;
  final DateTime? consentGrantedAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.partnerCode,
    this.partnerId,
    this.termsAcceptedAt,
    this.privacyAcceptedAt,
    this.consentGrantedAt,
  });

  bool get hasAcceptedAll =>
      termsAcceptedAt != null &&
      privacyAcceptedAt != null &&
      consentGrantedAt != null;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      name: json['name'] as String,
      partnerCode: json['partnerCode'] as String,
      partnerId: json['partnerId'] as int?,
      termsAcceptedAt: json['termsAcceptedAt'] != null
          ? DateTime.tryParse(json['termsAcceptedAt'] as String)
          : null,
      privacyAcceptedAt: json['privacyAcceptedAt'] != null
          ? DateTime.tryParse(json['privacyAcceptedAt'] as String)
          : null,
      consentGrantedAt: json['consentGrantedAt'] != null
          ? DateTime.tryParse(json['consentGrantedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'partnerCode': partnerCode,
        'partnerId': partnerId,
        'termsAcceptedAt': termsAcceptedAt?.toIso8601String(),
        'privacyAcceptedAt': privacyAcceptedAt?.toIso8601String(),
        'consentGrantedAt': consentGrantedAt?.toIso8601String(),
      };
}
