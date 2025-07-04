import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';

enum SnackBarType { error, info, success, warning, none }

void showTemporarySnackBar(
  BuildContext context,
  String message, {
  TextStyle? style,
  int duration = 1,
  Color? color,
  SnackBarType? type,
}) {
  // Tip ve renk/ikon eşleştirmesi
  ContentType? icon;
  Color? backgroundColor = color;
  String Message = '';

  switch (type) {
    case SnackBarType.error:
      icon = ContentType.failure;
      backgroundColor ??= Colors.red;
      Message = 'Hata';
      break;
    case SnackBarType.info:
      icon = ContentType.help;
      backgroundColor ??= Colors.blue;
      Message = 'Bilgi';
      break;
    case SnackBarType.success:
      icon = ContentType.success;
      backgroundColor ??= Colors.green;
      Message = 'Başarılı';
      break;
    case SnackBarType.warning:
      icon = ContentType.warning;
      backgroundColor ??= Colors.orange;
      Message = 'Uyarı';
      break;
    case SnackBarType.none:
    case null:
      icon = null;
      backgroundColor ??= Colors.grey;
      Message = 'Bilinmiyor';
      break;
  }

  final snackBar = SnackBar(
    backgroundColor: Colors.transparent,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.75),
    elevation: 0,
    content: AwesomeSnackbarContent(
      title: Message,
      message: message,
      contentType: icon ?? ContentType.failure,
    ),
    duration: Duration(seconds: duration),
  );

  // SnackBar'ı ekranın en üstünde göstermek için mevcut SnackBar'ı kapatıp yenisini gösteriyoruz
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
