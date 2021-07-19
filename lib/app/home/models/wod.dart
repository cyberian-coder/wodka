import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Wod {
  Wod({
    @required this.id,
    this.wodDate,
    this.wodDescription,
    this.myScore,
  });
  final String id;
  final DateTime wodDate;
  final String wodDescription;
  final String myScore;

  factory Wod.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final DateTime wodDate = data['wodDate'].toDate();
    final String wodDescription = data['wodDescription'];
    final String myScore = data['myScore'];
    return Wod(
      id: documentId,
      wodDate: wodDate,
      wodDescription: wodDescription,
      myScore: myScore,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'wodDate': wodDate,
      'wodDescription': wodDescription,
      'myScore': myScore,
    };
  }
}
