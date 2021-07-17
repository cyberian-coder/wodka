import 'package:flutter/foundation.dart';

class Wod {
  Wod({
    @required this.id,
    this.name,
    this.ratePerHour,
    this.wodDescription,
    this.myScore,
  });
  final String id;
  final String name;
  final String wodDescription;
  final String myScore;
  final int ratePerHour;

  factory Wod.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final int ratePerHour = data['ratePerHour'];
    final String wodDescription = data['wodDescription'];
    final String myScore = data['myScore'];
    return Wod(
      id: documentId,
      name: name,
      ratePerHour: ratePerHour,
      wodDescription: wodDescription,
      myScore: myScore,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ratePerHour': ratePerHour,
      'wodDescription': wodDescription,
      'myScore': myScore,
    };
  }
}
