import 'package:raja_ongkir_flutter/models/models.dart';

class ShippingDetail {
  Courier? courier;
  int? weight;
  Province? provinceOrigin;
  Province? provinceDestination;
  City? cityOrigin;
  City? cityDestination;

  ShippingDetail({
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
