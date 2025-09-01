import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  String dataUrl =
      'https://api.coingecko.com/api/v3/simple/price?ids={IDS}&vs_currencies={CURRENCIES}';
  String? currencies;
  var Data;

  Future<void> _fetchDetails(List<String> coins, currency) async {
    http.Response response = await http.get(
      Uri.parse(
        dataUrl
            .replaceAll('{IDS}', coins.join(','))
            .replaceAll('{CURRENCIES}', currency),
      ),
    );
    Data = jsonDecode(response.body);
  }

  Future getData(List<String> coins, String currency) async {
    await _fetchDetails(coins, currency);
    return Data;
  }
}
