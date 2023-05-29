// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Campsite extends Equatable {
  final String id;
  final String name;
  final String description;
  final String address;
  final String state;
  final String imagePath;
  final List? faq;
  final bool verified;

  // Constructor
  const Campsite({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.state,
    required this.imagePath,
    this.faq,
    required this.verified,
  });

  Campsite copyWith({
    String? id,
    String? name,
    String? description,
    String? address,
    String? state,
    String? imagePath,
    List? faq,
    bool? verified,
  }) {
    return Campsite(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      state: state ?? this.state,
      imagePath: imagePath ?? this.imagePath,
      faq: faq ?? this.faq,
      verified: verified ?? this.verified,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'state': state,
      'imagePath': imagePath,
      'faq': faq,
      'verified': verified,
    };
  }

  factory Campsite.fromMap(Map<String, dynamic> map) {
    return Campsite(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      address: map['address'] as String,
      state: map['state'] as String,
      imagePath: map['imagePath'] as String,
      faq: map['faq'] != null ? List.from((map['faq'] as List).map((x) => x),) : null,
      verified: map['verified'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Campsite.fromJson(String source) => Campsite.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      name,
      description,
      address,
      state,
      imagePath,
      faq,
      verified,
    ];
  }
}
