import 'package:flutter/material.dart';
import 'package:imecehub/core/constants/app_paddings.dart';
import 'package:imecehub/core/widgets/dropdownBox.dart';
import 'package:imecehub/core/widgets/showTemporarySnackBar.dart';
import 'package:imecehub/core/widgets/textButton.dart';
import 'package:imecehub/core/widgets/textField.dart';
import 'package:imecehub/models/userAdress.dart';
import 'package:imecehub/models/users.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';
import 'package:imecehub/services/api_service.dart';

class AdressAddScreen extends StatefulWidget {
  final User user;
  final UserAdress? adres;
  final bool isUpdate;
  const AdressAddScreen(
      {super.key, required this.user, this.adres, required this.isUpdate});

  @override
  State<AdressAddScreen> createState() => _AdressAddScreenState();
}

class _AdressAddScreenState extends State<AdressAddScreen> {
  late TextEditingController _ulkeController;
  late TextEditingController _ilController;
  late TextEditingController _ilceController;
  late TextEditingController _mahalleController;
  late TextEditingController _postaKoduController;
  late TextEditingController _adresSatir1Controller;
  late TextEditingController _adresSatir2Controller;
  late TextEditingController _baslikController;

  final FocusNode _ulkeFocus = FocusNode();
  final FocusNode _ilFocus = FocusNode();
  final FocusNode _ilceFocus = FocusNode();
  final FocusNode _mahalleFocus = FocusNode();
  final FocusNode _postaKoduFocus = FocusNode();
  final FocusNode _adresSatir1Focus = FocusNode();
  final FocusNode _adresSatir2Focus = FocusNode();
  final FocusNode _baslikFocus = FocusNode();

  late String _adresTipi;
  late bool _varsayilanAdres;

  final Map<String, String> _adresTipleri = {
    'diger': 'Diğer',
    'ev': 'Ev Adresi',
    'is': 'İş Adresi',
    'teslimat': 'Teslimat Adresi',
    'fatura': 'Fatura Adresi',
  };

  @override
  void initState() {
    super.initState();
    _ulkeController =
        TextEditingController(text: widget.adres?.ulke ?? 'Türkiye');
    _ilController = TextEditingController(text: widget.adres?.il);
    _ilceController = TextEditingController(text: widget.adres?.ilce);
    _mahalleController = TextEditingController(text: widget.adres?.mahalle);
    _postaKoduController = TextEditingController(text: widget.adres?.postaKodu);
    _adresSatir1Controller =
        TextEditingController(text: widget.adres?.adresSatiri1);
    _adresSatir2Controller =
        TextEditingController(text: widget.adres?.adresSatiri2);
    _baslikController = TextEditingController(text: widget.adres?.baslik);
    _adresTipi = widget.adres?.adresTipi ?? 'diger';
    _varsayilanAdres = widget.adres?.varsayilanAdres ?? false;
  }

  @override
  void dispose() {
    _ulkeController.dispose();
    _ilController.dispose();
    _ilceController.dispose();
    _mahalleController.dispose();
    _postaKoduController.dispose();
    _adresSatir1Controller.dispose();
    _adresSatir2Controller.dispose();
    _baslikController.dispose();
    _ulkeFocus.dispose();
    _ilFocus.dispose();
    _ilceFocus.dispose();
    _mahalleFocus.dispose();
    _postaKoduFocus.dispose();
    _adresSatir1Focus.dispose();
    _adresSatir2Focus.dispose();
    _baslikFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adres Ekle'),
      ),
      body: Padding(
        padding: AppPaddings.all16,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(_ulkeController, 'Ülke',
                  keyboardType: TextInputType.text,
                  focusNode: _ulkeFocus,
                  textInputAction: TextInputAction.next, onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_ilFocus);
              }),
              const SizedBox(height: 12),
              _buildTextField(_ilController, 'İl',
                  focusNode: _ilFocus,
                  textInputAction: TextInputAction.next, onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_ilceFocus);
              }),
              const SizedBox(height: 12),
              _buildTextField(_ilceController, 'İlçe',
                  focusNode: _ilceFocus,
                  textInputAction: TextInputAction.next, onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_mahalleFocus);
              }),
              const SizedBox(height: 12),
              _buildTextField(_mahalleController, 'Mahalle',
                  focusNode: _mahalleFocus,
                  textInputAction: TextInputAction.next, onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_postaKoduFocus);
              }),
              const SizedBox(height: 12),
              _buildTextField(_postaKoduController, 'Posta Kodu',
                  keyboardType: TextInputType.number,
                  focusNode: _postaKoduFocus,
                  textInputAction: TextInputAction.next, onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_adresSatir1Focus);
              }),
              const SizedBox(height: 12),
              _buildTextField(_adresSatir1Controller, 'Adres Satırı 1',
                  focusNode: _adresSatir1Focus,
                  textInputAction: TextInputAction.next, onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_adresSatir2Focus);
              }),
              const SizedBox(height: 12),
              _buildTextField(_adresSatir2Controller, 'Adres Satırı 2',
                  focusNode: _adresSatir2Focus,
                  textInputAction: TextInputAction.next, onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_baslikFocus);
              }),
              const SizedBox(height: 12),
              _buildTextField(_baslikController, 'Başlık',
                  focusNode: _baslikFocus,
                  textInputAction: TextInputAction.done),
              const SizedBox(height: 12),
              DropdownBox(
                value: _adresTipi,
                items: _adresTipleri.entries.map((e) => e.key).toList(),
                onChanged: (value) {
                  setState(() {
                    _adresTipi = value ?? 'diger';
                  });
                },
                label: 'Adres Tipi',
                itemLabelBuilder: (value) => _adresTipleri[value] ?? '',
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Checkbox(
                    value: _varsayilanAdres,
                    onChanged: (value) {
                      setState(() {
                        _varsayilanAdres = value ?? false;
                      });
                    },
                  ),
                  const Text('Varsayılan adres'),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: textButton(
                      context,
                      buttonColor: HomeStyle(context: context).surface,
                      titleColor: HomeStyle(context: context).primary,
                      border: true,
                      borderColor: HomeStyle(context: context).secondary,
                      borderWidth: 1,
                      elevation: 0,
                      'Vazgeç',
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: textButton(
                      context,
                      widget.isUpdate == true
                          ? 'Adresi Güncelle'
                          : 'Adresi Kaydet',
                      elevation: 0,
                      onPressed: () async {
                        final kullanici = widget.user.id;
                        //print(kullanici);
                        if (widget.isUpdate != true) {
                          // Kaydetme işlemi burada yapılacak
                          try {
                            final response = await ApiService.postUserAdress(
                              _ulkeController.text,
                              _ilController.text,
                              _ilceController.text,
                              _mahalleController.text,
                              _postaKoduController.text,
                              _adresSatir1Controller.text,
                              _adresSatir2Controller.text,
                              _baslikController.text,
                              _adresTipi,
                              _varsayilanAdres,
                              kullanici,
                            );
                            if (response.isNotEmpty) {
                              showTemporarySnackBar(
                                  context, 'Adres Başarıyla kaydedildi',
                                  type: SnackBarType.success);
                              Navigator.of(context).pop();
                            }
                          } catch (e) {
                            showTemporarySnackBar(context, '$e',
                                type: SnackBarType.error);
                            print(e);
                          }
                        } else {
                          try {
                            final response = await ApiService.updateUserAdress(
                              widget.adres!.id,
                              _ulkeController.text,
                              _ilController.text,
                              _ilceController.text,
                              _mahalleController.text,
                              _postaKoduController.text,
                              _adresSatir1Controller.text,
                              _adresSatir2Controller.text,
                              _baslikController.text,
                              _adresTipi,
                              _varsayilanAdres,
                              kullanici,
                            );
                            if (response.isNotEmpty) {
                              showTemporarySnackBar(
                                  context, 'Adres Başarıyla Güncellendi',
                                  type: SnackBarType.success);
                              Navigator.of(context).pop();
                            }
                          } catch (e) {
                            showTemporarySnackBar(context, '$e',
                                type: SnackBarType.error);
                            print(e);
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    void Function(String)? onFieldSubmitted,
  }) {
    return textField(
      context,
      controller: controller,
      keyboardType: keyboardType,
      labelText: label,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
