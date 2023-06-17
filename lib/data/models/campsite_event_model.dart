// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CampsiteEventModel extends Equatable {
  final String? id;
  final String name;
  final int price;
  final DateTime startDate;
  final DateTime endDate;
  final String campsiteId;
  final DateTime? deletedAt;
  const CampsiteEventModel({
    this.id,
    required this.name,
    required this.price,
    required this.startDate,
    required this.endDate,
    required this.campsiteId,
    this.deletedAt
  });

  CampsiteEventModel copyWith({
    String? id,
    String? name,
    int? price,
    DateTime? startDate,
    DateTime? endDate,
    String? campsiteId,
    DateTime? deletedAt,
  }) {
    return CampsiteEventModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      campsiteId: campsiteId ?? this.campsiteId,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'price': price,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'campsiteId': campsiteId,
      'deletedAt': deletedAt != null ? Timestamp.fromDate(deletedAt!) : null,
    };
  }

  factory CampsiteEventModel.fromMap(Map<String, dynamic> map) {
    return CampsiteEventModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
      price: map['price'] as int,
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      campsiteId: map['campsiteId'] as String,
      deletedAt: map['deletedAt'] != null ? (map['deletedAt'] as Timestamp).toDate() : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CampsiteEventModel.fromJson(String source) => CampsiteEventModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      name,
      price,
      startDate,
      endDate,
      campsiteId,
      deletedAt
    ];
  }
}
