import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:my_camp/data/models/booking.dart';
import 'package:my_camp/data/models/report.dart';
import 'package:my_camp/data/services/booking_service.dart';
import 'package:my_camp/data/services/campsite_event_service.dart';
import 'package:my_camp/data/services/campsite_service.dart';
import 'package:my_camp/data/services/user_service.dart';

class ReportRepository {
  final CampsiteService _campsiteService = CampsiteService();
  final BookingService _bookingService = BookingService();
  final CampsiteEventService _campsiteEventService = CampsiteEventService();
  final UserService _userService = UserService();

  pw.Widget paddedText(
    final String text, {
    final pw.TextAlign align = pw.TextAlign.left,
  }) =>
      pw.Padding(
        padding: pw.EdgeInsets.all(10),
        child: pw.Text(
          text,
          textAlign: align,
        ),
      );

  String _formatDate(DateTime date) {
    DateFormat formatter = DateFormat('dd/MM/yyyy hh:mm aa');
    return formatter.format(date);
  }

  String _formatEventDate(DateTime date) {
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  FutureOr<Uint8List> makePdf(String campsiteId) async {
    final campsite = await _campsiteService.fetchSingleCampsiteData(campsiteId);
    final List<Booking> bookingList = [];
    final campsiteBookings =
        await _bookingService.fetchCampsiteBookings(campsiteId);

    for (final booking in campsiteBookings) {
      final campsiteEvent = await _campsiteEventService
          .fetchSingleCampsiteEvent(booking.campsiteEventId);
      final user = await _userService.fetchUser(userId: booking.userId);
      bookingList
          .add(booking.copyWith(campsiteEvent: campsiteEvent, user: user));
    }
    final Report report = Report(campsite: campsite!, bookings: bookingList);

    final pdf = pw.Document();
    final imageLogo = pw.MemoryImage(
        (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List());
    final font = await rootBundle.load("assets/fonts/Poppins-Regular.ttf");
    final ttf = pw.Font.ttf(font);
    pdf.addPage(pw.MultiPage(build: (context) {
      return [
        pw.Column(
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  children: [
                    pw.Text('Campsite Report for:',
                        style: pw.TextStyle(font: ttf)),
                    pw.Text(report.campsite.name,
                        style: pw.TextStyle(font: ttf, fontSize: 20)),
                    pw.Text(campsite.address, style: pw.TextStyle(font: ttf)),
                  ],
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                ),
                pw.SizedBox(
                  height: 150,
                  width: 150,
                  child: pw.Image(imageLogo),
                )
              ],
            ),
            pw.Container(height: 50),
            pw.Row(
              children: [
                pw.Text('Bookings',
                    style: pw.TextStyle(font: ttf, fontSize: 16)),
              ],
            ),
            pw.Container(height: 25),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.black),
              children: [
                // The first row just contains a phrase 'INVOICE FOR PAYMENT'
                pw.TableRow(
                  children: [
                    pw.Padding(
                      child: pw.Text(
                        '#',
                        style: pw.Theme.of(context).header4,
                        textAlign: pw.TextAlign.center,
                      ),
                      padding: pw.EdgeInsets.all(10),
                    ),
                    pw.Padding(
                      child: pw.Text(
                        'Email Address',
                        style: pw.Theme.of(context).header4,
                        textAlign: pw.TextAlign.center,
                      ),
                      padding: pw.EdgeInsets.all(10),
                    ),
                    pw.Padding(
                      child: pw.Text(
                        'Campsite Event',
                        style: pw.Theme.of(context).header4,
                        textAlign: pw.TextAlign.center,
                      ),
                      padding: pw.EdgeInsets.all(10),
                    ),
                    pw.Padding(
                      child: pw.Text(
                        'Event Date',
                        style: pw.Theme.of(context).header4,
                        textAlign: pw.TextAlign.center,
                      ),
                      padding: pw.EdgeInsets.all(10),
                    ),
                    pw.Padding(
                      child: pw.Text(
                        'Amount paid',
                        style: pw.Theme.of(context).header4,
                        textAlign: pw.TextAlign.center,
                      ),
                      padding: pw.EdgeInsets.all(10),
                    ),
                    pw.Padding(
                      child: pw.Text(
                        'Booked on',
                        style: pw.Theme.of(context).header4,
                        textAlign: pw.TextAlign.center,
                      ),
                      padding: pw.EdgeInsets.all(10),
                    ),
                  ],
                ),
                if (report.bookings.isNotEmpty)
                  // The remaining rows contain each item from the bookings, and uses the
                  // map operator (the ...) to include these items in the list
                  ...report.bookings.mapIndexed(
                      // Each new line item for the invoice should be rendered on a new TableRow
                      (index, booking) {
                    return pw.TableRow(
                      children: [
                        pw.Expanded(
                          child: paddedText((index + 1).toString()),
                          flex: 1,
                        ),
                        pw.Expanded(
                          child: paddedText("${booking.user!.email}"),
                          flex: 2,
                        ),
                        pw.Expanded(
                          child: paddedText(booking.campsiteEvent!.name),
                          flex: 2,
                        ),
                        pw.Expanded(
                          child: paddedText('From\n${_formatEventDate(booking.campsiteEvent!.startDate)}\nTo\n${_formatEventDate(booking.campsiteEvent!.endDate)}'),
                          flex: 2,
                        ),
                        pw.Expanded(
                          child: paddedText("RM ${booking.amount / 100}"),
                          flex: 2,
                        ),
                        pw.Expanded(
                          child: paddedText(_formatDate(booking.createdAt)),
                          flex: 2,
                        )
                      ],
                    );
                  }),
              ],
            ),
            pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
              pw.Container(height: 50),
              pw.Text('Summary Details',
                  style: pw.TextStyle(font: ttf, fontSize: 20)),
              pw.Text('Total Bookings: ${report.totalBookings}',
                  style: pw.TextStyle(font: ttf, fontSize: 16)),
                  pw.Text('Total Amount: RM ${report.totalAmount / 100}',
                  style: pw.TextStyle(font: ttf, fontSize: 16)),
                  pw.Text('Commission rate: ${report.commissionRate * 100} %',
                  style: pw.TextStyle(font: ttf, fontSize: 16)),
                  pw.Text('Commission amount: RM ${report.commission / 100}',
                  style: pw.TextStyle(font: ttf, fontSize: 16)),
                  pw.Text('Total Sales: RM ${report.totalSales / 100}',
                  style: pw.TextStyle(font: ttf, fontSize: 16)),
            ]),
            pw.Center(
              child: pw.Padding(
                child: pw.Text(
                  "END OF CAMPSITE REPORT",
                  style: pw.Theme.of(context).header4,
                  textAlign: pw.TextAlign.center,
                  softWrap: true,
                ),
                padding: pw.EdgeInsets.all(20),
              ),
            )
          ],
        )
      ];
    }));
    return pdf.save();
  }
}
