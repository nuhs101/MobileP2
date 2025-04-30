import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobilep2/api/api_key.dart';
import 'package:mobilep2/models/finnhub_info.dart';

class RemoteService {
  // TODO have error handling when response isn't collected.
  Future<CompanyData> getCompanyData({String symbol = "AAPL"}) async {
    var client = http.Client();
    var uri = Uri.parse(
      "https://finnhub.io/api/v1/stock/profile2?symbol=$symbol&token=$finnHubApiKey",
    );
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      return companyDataFromJson(response.body);
    } else {
      return CompanyData.defaultData;
    }
  }

  Future<List<EarningsSurprisesData>> getSurprisesData({
    String symbol = "AAPL",
  }) async {
    var client = http.Client();
    var uri = Uri.parse(
      "https://finnhub.io/api/v1/stock/earnings?symbol=$symbol&token=$finnHubApiKey",
    );
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      return earningsSurprisesDataFromJson(response.body);
    } else {
      return [EarningsSurprisesData.defaultData];
    }
  }

  Future<EarningsCalendarData> getCalendarData({String symbol = "AAPL"}) async {
    var client = http.Client();
    var uri = Uri.parse(
      "https://finnhub.io/api/v1/calendar/earnings?symbol=$symbol&from=2025-04-01&to=2025-04-28&token=$finnHubApiKey",
    );
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      return earningsCalendarDataFromJson(response.body);
    } else {
      return EarningsCalendarData.defaultData;
    }
  }

  Future<QuoteData> getQuoteData({String symbol = "AAPL"}) async {
    var client = http.Client();
    var uri = Uri.parse(
      "https://finnhub.io/api/v1/quote?symbol=$symbol&token=$finnHubApiKey",
    );
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      return quoteDataFromJson(response.body);
    } else {
      return QuoteData.defaultData;
    }
  }
}
