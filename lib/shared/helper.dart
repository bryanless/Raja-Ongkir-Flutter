part of 'shared.dart';

class Helper {
  static String toIdr(String number) {
    final currencyFormatter = NumberFormat.simpleCurrency(locale: 'id_ID');
    return currencyFormatter.format(number);
  }
}
