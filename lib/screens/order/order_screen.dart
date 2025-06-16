import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

part 'order_screen_appBar.dart';
part 'orderScreenBottomNavigationBar.dart';
part 'order_screen_body.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  FocusNode _focusNode = FocusNode();
  String? selectedCard = "Visa Card";
  String? selectedIban = "İban";
  TextEditingController couponController =
      TextEditingController(text: '000000');
  bool _confirm = false;
  @override
  void initState() {
    super.initState();
    // Focus değişimlerini dinleyerek UI'nın güncellenmesini sağlıyoruz
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: OrderScreenAppBar(context),
        bottomNavigationBar: orderScreenBottomNavigationBar(
          context,
          _confirm,
          (bool? newValue) {
            setState(() {
              _confirm = newValue ?? false;
            });
          },
        ),
        body: orderScreenBody(
            context,
            selectedCard,
            (String? newValue) {
              setState(() {
                selectedCard = newValue;
              });
            },
            selectedIban,
            (String? newValue) {
              setState(() {
                selectedIban = newValue;
              });
            },
            _focusNode));
  }
}

Text _appBarHeaderText(String title) {
  return Text(
    title,
    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
  );
}

Text _appBarBodyText(String title) {
  return Text(
    title,
    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
  );
}
