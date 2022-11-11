part of 'shared.dart';

class Const {
  static String baseUrl = 'api.rajaongkir.com';
  static String apiKey = dotenv.env['API_KEY']!;

  static RegExp regexNonStartingZero = RegExp(r'^0+(?=.)');
}
