import 'package:equatable/equatable.dart';

import '../../data/models/partner_model.dart';

enum PartnerStatus { initial, loading, loaded, error }

class PartnerState extends Equatable {
  final PartnerStatus status;
  final String? partnerCode;
  final PartnerCalendarModel? partnerView;
  final String? error;

  const PartnerState({
    this.status = PartnerStatus.initial,
    this.partnerCode,
    this.partnerView,
    this.error,
  });

  PartnerState copyWith({
    PartnerStatus? status,
    String? partnerCode,
    PartnerCalendarModel? partnerView,
    String? error,
  }) {
    return PartnerState(
      status: status ?? this.status,
      partnerCode: partnerCode ?? this.partnerCode,
      partnerView: partnerView ?? this.partnerView,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, partnerCode, partnerView, error];
}
