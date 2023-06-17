part of 'booking_bloc.dart';

abstract class BookingState extends Equatable {
  const BookingState();
  
  @override
  List<Object> get props => [];
}

class BookingInitial extends BookingState {}

class BookingSuccess extends BookingState{
  final CampsiteEventModel campsiteEvent;
  const BookingSuccess(this.campsiteEvent);

  @override
  List<Object> get props => [campsiteEvent];
}

class BookingsFetched extends BookingState{
  final List<Booking> bookings;
  final List<Campsite> campsites;
  final List<CampsiteEventModel> campsiteEvents;
  const BookingsFetched({required this.bookings,required this.campsites,required this.campsiteEvents});

  @override
  List<Object> get props => [bookings];
  }
class BookingsLoading extends BookingState{}
class BookingsFetchError extends BookingState{
  final String message;
  const BookingsFetchError({this.message = 'Error fetching bookings'});

  @override
  List<Object> get props => [message];
}