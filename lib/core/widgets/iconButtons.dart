import 'package:flutter/material.dart';

IconButton settingsIconButton(BuildContext context) {
  return IconButton(onPressed: () {}, icon: Icon(Icons.settings_outlined));
}

IconButton shareIconButton(BuildContext context) {
  return IconButton(onPressed: () {}, icon: Icon(Icons.share_outlined));
}

IconButton shopIconButton(BuildContext context) {
  return IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart_outlined));
}

IconButton favoriIconButton(BuildContext context, Function()? onPressed,
    {bool selected = false}) {
  return IconButton(
      onPressed: onPressed,
      icon: Icon(
        selected ? Icons.favorite : Icons.favorite_border,
        color: Colors.red,
      ));
}
