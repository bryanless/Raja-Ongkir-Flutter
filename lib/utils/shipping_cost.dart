import 'package:raja_ongkir_flutter/models/models.dart';

class ShippingCost {
  Courier? courier;
  String? weight;
  Province? provinceOrigin;
  Province? provinceDestination;
  City? cityOrigin;
  City? cityDestination;

  ShippingCost({
    this.courier,
    this.weight,
    this.provinceOrigin,
    this.provinceDestination,
    this.cityOrigin,
    this.cityDestination,
  });
}

enum Courier {
  jne('JNE'),
  pos('POS'),
  tiki('Tiki');

  const Courier(this.value);
  final String value;
}
