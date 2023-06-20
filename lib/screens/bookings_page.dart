import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_camp/data/models/booking.dart';
import 'package:my_camp/data/models/campsite.dart';
import 'package:my_camp/data/models/campsite_event_model.dart';
import 'package:my_camp/logic/blocs/booking/booking_bloc.dart';
import 'package:my_camp/logic/cubits/session/session_cubit.dart';

class BookingsPage extends StatelessWidget {
  const BookingsPage({Key? key}) : super(key: key);

  String _formatDate(DateTime date) {
    DateFormat formatter = DateFormat('dd/MM/yyyy hh:mm aa');
    return formatter.format(date);
  }

  String _formatEventDate(DateTime date) {
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<BookingBloc>(context)
        .add(UserBookingsRequested(context.read<SessionCubit>().state.id!));
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Bookings"),
      ),
      body: SafeArea(
        child: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            if (state is BookingsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is BookingsFetched) {
              if (state.bookings.isEmpty) {
                return const Center(
                  child: Text("No booking records found"),
                );
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.bookings.length,
                      itemBuilder: (context, index) {
                        return _buildBookingListView(state.bookings[index]);
                      },
                    ),
                  ),
                ],
              );
            }
            return const Center(child: Text("Something went wrong"));
          },
        ),
      ),
    );
  }

  Widget _buildBookingListView(Booking booking) {
    final Campsite campsite = booking.campsite!;
    final CampsiteEventModel campsiteEvent = booking.campsiteEvent!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[600]!,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SizedBox(
        height: 200.0,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0), // Add desired padding
                child: ListTile(
                  contentPadding: const EdgeInsets.all(
                      8.0), // Set the same padding value for the text content
                  title: Row(
                    children: [
                      Text(
                        'Campsite name: ${campsite.name}\nEvent: ${campsiteEvent.name}\nAmount paid: RM ${booking.amount / 100}\nAddress: ${campsite.address}\nStart Date: ${_formatEventDate(campsiteEvent.startDate)}\nEnd Date: ${_formatEventDate(campsiteEvent.endDate)}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight
                                .bold // Replace with your desired color
                            ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(height: 5.0),
                      Text("Booked on ${_formatDate(booking.createdAt)}"),
                      const SizedBox(height: 5.0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
