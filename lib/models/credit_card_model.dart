import 'package:flutter/material.dart';

class CardInfo {
  final String id;
  final String cardNumber;
  final String cardLateUseDate;
  final String cardCvv;
  final String cardUserName;
  final String cardName;
  final bool isDefault;
  final List<Color>? customColors;

  CardInfo({
    required this.id,
    required this.cardNumber,
    required this.cardLateUseDate,
    required this.cardCvv,
    required this.cardUserName,
    required this.cardName,
    this.isDefault = false,
    this.customColors,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'cardNumber': cardNumber,
        'cardLateUseDate': cardLateUseDate,
        'cardCvv': cardCvv,
        'cardUserName': cardUserName,
        'cardName': cardName,
        'isDefault': isDefault,
      };

  factory CardInfo.fromJson(Map<String, dynamic> json) => CardInfo(
        id: json['id'] ?? '',
        cardNumber: json['cardNumber'] ?? '',
        cardLateUseDate: json['cardLateUseDate'] ?? '',
        cardCvv: json['cardCvv'] ?? '',
        cardUserName: json['cardUserName'] ?? '',
        cardName: json['cardName'] ?? '',
        isDefault: json['isDefault'] ?? false,
      );
}
