import 'package:my_camp/data/models/booking.dart';
import 'package:my_camp/data/models/campsite.dart';
import 'package:my_camp/data/models/campsite_event_model.dart';
import 'package:my_camp/data/services/booking_service.dart';
import 'package:my_camp/data/services/campsite_event_service.dart';
import 'package:my_camp/data/services/campsite_service.dart';

class BookingRepository {
  final BookingService _bookingService = BookingService();
  final CampsiteService _campsiteService = CampsiteService();
  final CampsiteEventService _campsiteEventService = CampsiteEventService();
  Future<void> addBooking(CampsiteEventModel campsiteEvent) async {
    return _bookingService.addBooking(campsiteEvent);
  }

  Future<List<Booking>> fetchUserBookings(String userId) async {
    final List<Booking> bookingList = [];

    final List<Booking> userBookings = await _bookingService.fetchUserBookings(userId);
    for (final booking in userBookings) {
      final CampsiteEventModel campsiteEvent =
          await _campsiteEventService.fetchSingleCampsiteEvent(booking.campsiteEventId);
      final Campsite? campsite = await _campsiteService.fetchSingleCampsiteData(campsiteEvent.campsiteId);
      bookingList.add(booking.copyWith(campsiteEvent: campsiteEvent, campsite: campsite));
    }

    return bookingList;
  }

  Future<List<Campsite>> fetchBookedCampsite(userId) {
    return _campsiteService.fetchUserBookedCampsites(userId);
  }

  Future<List<CampsiteEventModel>> fetchBookedCampsiteEvents(userId) {
    return _campsiteEventService.fetchUserBookedCampsiteEvents(userId);
  }
}
