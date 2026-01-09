import 'package:flutter/material.dart';
import 'package:u_credit_card/u_credit_card.dart';

class CreditCartWidget extends StatelessWidget {
  final String cardUserName;
  final String cardNumber;
  final String cardLateUseDate;
  final String cardCvv;
  final String? cardName;
  final Color topLeftColor;
  final Color bottomRightColor;
  final CardType cardType;
  final CardProviderLogoPosition cardProviderLogoPosition;
  final bool autoHideBalance;
  final bool enableFlipping;
  final bool doesSupportNfc;
  final bool placeNfcIconAtTheEnd;
  final bool showActions;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CreditCartWidget({
    Key? key,
    this.cardUserName = '',
    this.cardNumber = '',
    this.cardLateUseDate = '',
    this.cardCvv = '',
    this.cardName,
    this.topLeftColor = Colors.blue,
    this.bottomRightColor = Colors.purple,
    this.cardType = CardType.debit,
    this.cardProviderLogoPosition = CardProviderLogoPosition.right,
    this.autoHideBalance = true,
    this.enableFlipping = true,
    this.doesSupportNfc = true,
    this.placeNfcIconAtTheEnd = true,
    this.showActions = false,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardWidget = CreditCardUi(
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

    if (!showActions) {
      return cardWidget;
    }

    return Stack(
      children: [
        cardWidget,
        Positioned(
          top: 12,
          right: 12,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onEdit != null)
                _ActionButton(
                  icon: Icons.edit,
                  onTap: onEdit!,
                  color: Colors.white,
                ),
              if (onDelete != null) ...[
                const SizedBox(width: 8),
                _ActionButton(
                  icon: Icons.delete_outline,
                  onTap: onDelete!,
                  color: Colors.red.shade300,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
    );
  }
}
