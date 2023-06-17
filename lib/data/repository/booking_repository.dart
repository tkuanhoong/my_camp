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
  Future<List<Booking>> fetchUserBookings(userId) async {
    return _bookingService.fetchUserBookings(userId);
  }
  Future<List<Campsite>> fetchBookedCampsite(userId){
    return _campsiteService.fetchUserBookedCampsites(userId);
  }
  Future<List<CampsiteEventModel>> fetchBookedCampsiteEvents(userId){
    return _campsiteEventService.fetchUserBookedCampsiteEvents(userId);
  }

}