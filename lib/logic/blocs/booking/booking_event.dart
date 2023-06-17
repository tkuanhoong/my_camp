part of 'booking_bloc.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class PaymentBookingSuccess extends BookingEvent{
  final CampsiteEventModel campsiteEvent;
  const PaymentBookingSuccess(this.campsiteEvent);

  @override
  List<Object> get props => [campsiteEvent];
}

class UserBookingsRequested extends BookingEvent{
  final String userId;
  const UserBookingsRequested(this.userId);

  @override
  List<Object> get props => [userId];
}