import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class BookingFunnelState {
  const BookingFunnelState({
    this.salonId,
    this.serviceId,
    this.serviceName,
    this.servicePrice,
    this.serviceDurationMinutes,
    this.employeeId,
    this.employeeName,
    this.slotDate,
    this.slotTime,
    this.depositAmount,
  });

  final String? salonId;
  final String? serviceId;
  final String? serviceName;
  final int? servicePrice;
  final int? serviceDurationMinutes;
  final String? employeeId;
  final String? employeeName;
  final String? slotDate;
  final String? slotTime;
  final int? depositAmount;

  bool get canReview =>
      salonId != null &&
      serviceId != null &&
      slotDate != null &&
      slotTime != null;

  BookingFunnelState copyWith({
    String? salonId,
    String? serviceId,
    String? serviceName,
    int? servicePrice,
    int? serviceDurationMinutes,
    String? employeeId,
    String? employeeName,
    String? slotDate,
    String? slotTime,
    int? depositAmount,
    bool clearEmployee = false,
    bool clearSlot = false,
  }) {
    return BookingFunnelState(
      salonId: salonId ?? this.salonId,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      servicePrice: servicePrice ?? this.servicePrice,
      serviceDurationMinutes:
          serviceDurationMinutes ?? this.serviceDurationMinutes,
      employeeId: clearEmployee ? null : (employeeId ?? this.employeeId),
      employeeName: clearEmployee ? null : (employeeName ?? this.employeeName),
      slotDate: clearSlot ? null : (slotDate ?? this.slotDate),
      slotTime: clearSlot ? null : (slotTime ?? this.slotTime),
      depositAmount: depositAmount ?? this.depositAmount,
    );
  }
}

class BookingFunnelNotifier extends StateNotifier<BookingFunnelState> {
  BookingFunnelNotifier() : super(const BookingFunnelState());

  void startFunnel(String salonId) {
    state = BookingFunnelState(salonId: salonId);
  }

  void selectService({
    required String serviceId,
    required String serviceName,
    required int price,
    required int durationMinutes,
  }) {
    state = state.copyWith(
      serviceId: serviceId,
      serviceName: serviceName,
      servicePrice: price,
      serviceDurationMinutes: durationMinutes,
      clearEmployee: true,
      clearSlot: true,
    );
  }

  void selectEmployee({String? employeeId, String? employeeName}) {
    state = state.copyWith(
      employeeId: employeeId,
      employeeName: employeeName,
      clearSlot: true,
    );
  }

  void selectSlot({required String date, required String time}) {
    state = state.copyWith(slotDate: date, slotTime: time);
  }

  void setDepositAmount(int amount) {
    state = state.copyWith(depositAmount: amount);
  }

  void reset() {
    state = const BookingFunnelState();
  }
}

final bookingFunnelProvider =
    StateNotifierProvider<BookingFunnelNotifier, BookingFunnelState>(
        (ref) => BookingFunnelNotifier());
