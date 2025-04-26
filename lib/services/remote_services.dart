import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobilep2/api/api_key.dart';
import 'package:mobilep2/models/finnhub_info.dart';
import 'package:mobilep2/pages/home_page.dart';

class RemoteService {
  // TODO add symbol parameter for all functions.
  // TODO have error handling when response isn't collected.
  Future<CompanyData?> getCompanyData() async {
    var client = http.Client();
    var uri = Uri.parse(
      "https://finnhub.io/api/v1/stock/profile2?symbol=AAPL&token=$finnHubApiKey",
    );
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return CompanyData.fromJson(json);
    } else {
      return null;
    }
  }
  Future<List<EarningsSurprisesData?>?> getSurprisesData() async {
    var client = http.Client();
    var uri = Uri.parse("https://finnhub.io/api/v1/stock/earnings?symbol=AAPL&token=$finnHubApiKey");
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var jsonList = jsonDecode(response.body);
      print(jsonList);
      return List<EarningsSurprisesData>.from(
        jsonList.map((x) => EarningsSurprisesData.fromJson(x)),
      );
    } else {
      return null;
    }
  }
}