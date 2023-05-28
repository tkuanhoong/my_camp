import 'dart:convert';

import 'package:equatable/equatable.dart';

class Campsite extends Equatable {
  final String id;
  final String name;
  final String description;
  final String address;
  final String state;
  final String imagePath;
  // final List<Map?>? faq;
  final bool verified;

  // Constructor
  Campsite({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.state,
    required this.imagePath,
    required this.verified,
  });

  // Edit Campsite
  Campsite copyWith({
    String? id,
    String? name,
    String? description,
    String? address,
    String? state,
    String? imagePath,
    bool? verified,
  }) {
    return Campsite(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      state: state ?? this.state,
      imagePath: imagePath ?? this.imagePath,
      verified: verified ?? this.verified,
    );
  }

  // Convert Campsite attributes to Map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'state': state,
      'imagePath': imagePath,
      'verified': verified,
    };
  }

  // Generate Map structure
  factory Campsite.fromMap(Map<String, dynamic> map) {
    return Campsite(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      address: map['address'] as String,
      state: map['state'] as String,
      imagePath: map['imagePath'] as String,
      verified: map['verified'] as bool,
    );
  }

  // Convert to JSON format
  String toJson() => json.encode(toMap());

  // Decode JSON file into Map using fromMap method
  factory Campsite.fromJson(String source) =>
      Campsite.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  // TODO: implement props
  List<Object> get props {
    return [
      id,
      name,
      description,
      address,
      state,
      imagePath,
      verified,
    ];
  }
}
