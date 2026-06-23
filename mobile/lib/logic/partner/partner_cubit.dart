import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/partner_repository.dart';
import 'partner_state.dart';

class PartnerCubit extends Cubit<PartnerState> {
  final PartnerRepository _repository;

  PartnerCubit(this._repository) : super(const PartnerState());

  Future<void> loadPartnerCode() async {
    emit(state.copyWith(status: PartnerStatus.loading));

    try {
      final code = await _repository.getPartnerCode();
      emit(state.copyWith(
        status: PartnerStatus.loaded,
        partnerCode: code,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PartnerStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> regenerateCode() async {
    emit(state.copyWith(status: PartnerStatus.loading));

    try {
      final code = await _repository.regeneratePartnerCode();
      emit(state.copyWith(
        status: PartnerStatus.loaded,
        partnerCode: code,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PartnerStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> linkToPartner(String code) async {
    emit(state.copyWith(status: PartnerStatus.loading));

    try {
      await _repository.linkToPartner(code);
      emit(state.copyWith(status: PartnerStatus.loaded));
    } catch (e) {
      emit(state.copyWith(
        status: PartnerStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> unlinkPartner() async {
    emit(state.copyWith(status: PartnerStatus.loading));

    try {
      await _repository.unlinkPartner();
      emit(state.copyWith(
        status: PartnerStatus.loaded,
        partnerView: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PartnerStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> loadPartnerView() async {
    emit(state.copyWith(status: PartnerStatus.loading));

    try {
      final view = await _repository.getPartnerView();
      emit(state.copyWith(
        status: PartnerStatus.loaded,
        partnerView: view,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PartnerStatus.error,
        error: e.toString(),
      ));
    }
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }
}
