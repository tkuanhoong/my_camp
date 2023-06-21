// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:my_camp/data/models/booking.dart';
import 'package:my_camp/data/models/campsite.dart';

class Report extends Equatable {
  static const COMMISSION_RATE = 0.02;
  final Campsite campsite;
  final List<Booking> bookings;
  const Report({
    required this.campsite,
    required this.bookings,
  });

  Report copyWith({
    Campsite? campsite,
    List<Booking>? bookings,
  }) {
    return Report(
      campsite: campsite ?? this.campsite,
      bookings: bookings ?? this.bookings,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'campsite': campsite.toMap(),
      'bookings': bookings.map((x) => x.toMap()).toList(),
    };
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      campsite: Campsite.fromMap(map['campsite'] as Map<String,dynamic>),
      bookings: List<Booking>.from((map['bookings'] as List<int>).map<Booking>((x) => Booking.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory Report.fromJson(String source) => Report.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [campsite, bookings];

  int get totalAmount => bookings.fold<int>(
      0, (previousValue, element) => previousValue + element.amount);
  
  int get commission => (totalAmount * COMMISSION_RATE).toInt();

  double get commissionRate => COMMISSION_RATE;

  int get totalBookings => bookings.length;

  int get totalSales => totalAmount - commission;
  
}
