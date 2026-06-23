class CycleDayModel {
  final int id;
  final String date;
  final bool isPeriod;
  final bool isIntercourse;
  final String flow;
  final String notes;

  const CycleDayModel({
    required this.id,
    required this.date,
    required this.isPeriod,
    required this.isIntercourse,
    this.flow = '',
    this.notes = '',
  });

  factory CycleDayModel.fromJson(Map<String, dynamic> json) {
    return CycleDayModel(
      id: json['id'] as int,
      date: json['date'] as String,
      isPeriod: json['isPeriod'] as bool? ?? false,
      isIntercourse: json['isIntercourse'] as bool? ?? false,
      flow: json['flow'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'isPeriod': isPeriod,
        'isIntercourse': isIntercourse,
        'flow': flow,
        'notes': notes,
      };

  CycleDayModel copyWith({
    int? id,
    String? date,
    bool? isPeriod,
    bool? isIntercourse,
    String? flow,
    String? notes,
  }) {
    return CycleDayModel(
      id: id ?? this.id,
      date: date ?? this.date,
      isPeriod: isPeriod ?? this.isPeriod,
      isIntercourse: isIntercourse ?? this.isIntercourse,
      flow: flow ?? this.flow,
      notes: notes ?? this.notes,
    );
  }
}
