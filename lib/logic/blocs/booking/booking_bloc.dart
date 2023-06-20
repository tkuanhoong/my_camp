import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_camp/data/models/booking.dart';
import 'package:my_camp/data/models/campsite.dart';
import 'package:my_camp/data/models/campsite_event_model.dart';
import 'package:my_camp/data/repository/booking_repository.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository bookingRepository;
  BookingBloc(this.bookingRepository) : super(BookingInitial()) {
    on<PaymentBookingSuccess>((event, emit) {
      try {
        bookingRepository.addBooking(event.campsiteEvent);
        emit(BookingSuccess(event.campsiteEvent));
      } catch (e) {
        print(e);
      }
    });
    on<UserBookingsRequested>((event, emit) async {
      emit(BookingsLoading());
      try {
        final List<Booking> bookingList = await bookingRepository.fetchUserBookings(event.userId);
        emit(BookingsFetched(bookings: bookingList));
      } catch (e) {
        emit(BookingsFetchError(message: e.toString()));
      }
    });
  }
}
