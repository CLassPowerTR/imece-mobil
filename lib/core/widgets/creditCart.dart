import 'package:flutter/material.dart';
import 'package:u_credit_card/u_credit_card.dart';

class CreditCartWidget extends StatelessWidget {
  final String cardUserName;
  final String cardNumber;
  final String cardLateUseDate;
  final String cardCvv;
  final Color topLeftColor;
  final Color bottomRightColor;
  final CardType cardType;
  final CardProviderLogoPosition cardProviderLogoPosition;
  final bool autoHideBalance;
  final bool enableFlipping;
  final bool doesSupportNfc;
  final bool placeNfcIconAtTheEnd;

  const CreditCartWidget({
    Key? key,
    this.cardUserName = '',
    this.cardNumber = '',
    this.cardLateUseDate = '',
    this.cardCvv = '',
    this.topLeftColor = Colors.blue,
    this.bottomRightColor = Colors.purple,
    this.cardType = CardType.debit,
    this.cardProviderLogoPosition = CardProviderLogoPosition.right,
    this.autoHideBalance = true,
    this.enableFlipping = true,
    this.doesSupportNfc = true,
    this.placeNfcIconAtTheEnd = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CreditCardUi(
      cardHolderFullName:
          cardUserName == '' ? 'Kart sahibinin adı' : cardUserName,
      cardNumber: cardNumber == '' ? '0000 0000 0000 0000' : cardNumber,
      validFrom: '00/00',
      validThru: cardLateUseDate == '' ? '00/00' : cardLateUseDate,
      topLeftColor: topLeftColor,
      doesSupportNfc: doesSupportNfc,
      placeNfcIconAtTheEnd: placeNfcIconAtTheEnd,
      bottomRightColor: bottomRightColor,
      cardType: cardType,
      cardProviderLogoPosition: cardProviderLogoPosition,
      autoHideBalance: autoHideBalance,
      enableFlipping: enableFlipping,
      cvvNumber: cardCvv == '' ? '000' : cardCvv,
    );
  }
}
