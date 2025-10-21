import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:imecehub/core/widgets/buttons/close_button.dart';
import 'package:imecehub/core/widgets/container.dart';
import 'package:imecehub/core/widgets/richText.dart';
import 'package:imecehub/core/widgets/showTemporarySnackBar.dart';
import 'package:imecehub/core/widgets/text.dart';
import 'package:imecehub/core/widgets/buttons/textButton.dart';
import 'package:imecehub/core/widgets/textField.dart';
import 'package:imecehub/core/widgets/category_selector.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:imecehub/models/users.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';
import 'package:imecehub/services/api_service.dart';

part 'widget/add_product_view_body.dart';
part 'widget/add_product_extensions.dart';

class AddProductScreen extends StatelessWidget {
  final User user;

  const AddProductScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: context.addProductBody(user),
    );
  }
}
