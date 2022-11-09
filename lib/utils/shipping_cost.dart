import 'package:raja_ongkir_flutter/models/models.dart';

class ShippingCost {
  Courier? courier;
  Province? province;
  City? city;

  ShippingCost({
    this.courier,
    this.province,
    this.city,
  });
}

enum Courier {
  jne('jne'),
  posIndonesia('pos'),
  tikit('tiki');

  const Courier(this.value);
  final String value;
}
