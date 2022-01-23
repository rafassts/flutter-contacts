import 'package:contacts/settings.dart';
import 'package:dio/dio.dart';

class AddressRepository {
  //podemos criar uma model completa também
  Future<dynamic> searchAddress(String address) async {
    try {
      Response response = await Dio().get(URL_API_MAPS + address);

      var city =
          response.data["results"][0]["address_components"][0]["long_name"];
      var adrs = response.data["results"][0]["formatted_address"];
      double posLat =
          response.data["results"][0]["geometry"]["location"]["lat"];
      double posLng =
          response.data["results"][0]["geometry"]["location"]["lng"];

      return {
        'addressLine1': adrs,
        'addressLine2': city,
        'lat': posLat,
        'lng': posLng
      };
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future<dynamic> searchMockAddress(String address) async {
    return {
      'addressLine1': "Rua Mockada, 106, Lar dos Meninos",
      'addressLine2': "Prudente",
      'lat': -22.09870,
      'lng': -51.42256
    };
  }
}
