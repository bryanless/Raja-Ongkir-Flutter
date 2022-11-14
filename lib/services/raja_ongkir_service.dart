part of 'services.dart';

class RajaOngkirService {
  static Future<List<Costs>> getShippingcCost(
      ShippingDetail shippingDetail) async {
    var response = await http.post(
      Uri.https(Const.baseUrl, "/starter/cost"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'key': Const.apiKey,
      },
      body: jsonEncode(<String, dynamic>{
        'origin': shippingDetail.cityOrigin!.cityId,
        'destination': shippingDetail.cityDestination!.cityId,
        'weight': shippingDetail.weight,
        'courier': shippingDetail.courier!.value.toLowerCase(),
      }),
    );

    var job = json.decode(response.body);
    List<Costs> costs = [];
    if (response.statusCode == 200) {
      costs = (job['rajaongkir']['results'][0]['costs'] as List)
          .map((e) => Costs.fromJson(e))
          .toList();
    }

    return costs;
  }
}
