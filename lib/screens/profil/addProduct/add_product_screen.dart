import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:imecehub/models/products.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';
import 'package:imecehub/services/api_service.dart';
import 'package:imecehub/providers/products_provider.dart';
import 'package:http/http.dart' as http;

part 'widget/add_product_view_body.dart';
part 'widget/add_product_extensions.dart';

class AddProductScreen extends StatelessWidget {
  final User? user;
  final Product? product;

  const AddProductScreen({
    super.key,
    this.user,
    this.product,
  });

  @override
  Widget build(BuildContext context) {
    // User null ise, Product'tan satici ID'sini kullan veya hata göster
    final effectiveUser = user ?? (product?.satici != null
        ? User(
            id: product!.satici!,
            isSuperuser: false,
            username: '',
            firstName: '',
            lastName: '',
            email: '',
            isStaff: false,
            isActive: true,
            dateJoined: DateTime.now(),
            rol: 'satici',
            isOnline: false,
            hataYapmaOrani: '0',
            bakiye: '0',
            groups: [],
            userPermissions: [],
          )
        : null);
    
    if (effectiveUser == null) {
      return Scaffold(
        body: Center(
          child: Text('Kullanıcı bilgisi bulunamadı.'),
        ),
      );
    }
    
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: context.addProductBody(effectiveUser, product: product),
    );
  }
}
