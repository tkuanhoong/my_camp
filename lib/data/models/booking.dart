import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Booking extends Equatable {
  final String? id;
  final String userId;
  final int amount;
  final DateTime createdAt;
  final String campsiteEventId;
  const Booking({
    this.id,
    required this.userId,
    required this.amount,
    required this.createdAt,
    required this.campsiteEventId,
  });

  Booking copyWith({
    String? id,
    String? userId,
    int? amount,
    DateTime? createdAt,
    String? campsiteEventId,
  }) {
    return Booking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      campsiteEventId: campsiteEventId ?? this.campsiteEventId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'amount': amount,
      'createdAt': Timestamp.fromDate(createdAt),
      'campsiteEventId': campsiteEventId,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'] != null ? map['id'] as String : null,
      userId: map['userId'] as String,
      amount: map['amount'] as int,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      campsiteEventId: map['campsiteEventId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Booking.fromJson(String source) => Booking.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, userId, amount, createdAt, campsiteEventId];
}
