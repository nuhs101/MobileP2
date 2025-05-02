import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobilep2/api/api_key.dart';
import 'package:mobilep2/models/finnhub_info.dart';

class RemoteService {
  // TODO have error handling when response isn't collected.
  Future<CompanyData?> getCompanyData({String symbol = "AAPL"}) async {
    var client = http.Client();
    var uri = Uri.parse(
      "https://finnhub.io/api/v1/stock/profile2?symbol=$symbol&token=$finnHubApiKey",
    );
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      return companyDataFromJson(response.body);
    }
    return null;
  }

  Future<List<EarningsSurprisesData>?> getSurprisesData({
    String symbol = "AAPL",
  }) async {
    var client = http.Client();
    var uri = Uri.parse(
      "https://finnhub.io/api/v1/stock/earnings?symbol=$symbol&token=$finnHubApiKey",
    );
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      return earningsSurprisesDataFromJson(response.body);
    }
    return null;
  }

  Future<EarningsCalendarData?> getCalendarData({
    String symbol = "AAPL",
  }) async {
    var client = http.Client();
    var uri = Uri.parse(
      "https://finnhub.io/api/v1/calendar/earnings?symbol=$symbol&from=2025-04-01&to=2025-04-28&token=$finnHubApiKey",
    );
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      return earningsCalendarDataFromJson(response.body);
    }
    return null;
  }

  Future<QuoteData?> getQuoteData({String symbol = "AAPL"}) async {
    var client = http.Client();
    var uri = Uri.parse(
      "https://finnhub.io/api/v1/quote?symbol=$symbol&token=$finnHubApiKey",
    );
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      return quoteDataFromJson(response.body);
    }
    return null;
  }

  Future<List<NewsData>?> getNewsData({
    String symbol = "AAPL",
    DateTime? from,
    DateTime? to,
  }) async {
    to ??= DateTime.now();
    from ??= DateTime.now().subtract(Duration(days: 30));
    String symbolString = "symbol=$symbol";
    String toString =
        "${to.year}-${to.month.toStringAsFormatted()}-${to.day.toStringAsFormatted()}";
    String fromString =
        "${from.year}-${from.month.toStringAsFormatted()}-${from.day.toStringAsFormatted()}";
    var client = http.Client();
    var uri = Uri.parse(
      "https://finnhub.io/api/v1/company-news?$symbolString&from=$fromString&to=$toString&token=$finnHubApiKey",
    );
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      return newsDataFromJson(response.body);
    }
    return null;
  }

  Future<List<SymbolSearchResult>> searchSymbols(String query) async {
    if (query.isEmpty) return [];

    var client = http.Client();
    var uri = Uri.parse(
      "https://finnhub.io/api/v1/search?q=$query&token=$finnHubApiKey",
    );

    var response = await client.get(uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> results = data['result'] ?? [];
      return results.map((item) => SymbolSearchResult.fromJson(item)).toList();
    }
    return [];
  }
}

extension on int {
  String toStringAsFormatted() {
    if (this < 10) {
      return "0$this";
    }
    return toString();
  }
}

class SymbolSearchResult {
  final String description;
  final String displaySymbol;
  final String symbol;
  final String type;

  SymbolSearchResult({
    required this.description,
    required this.displaySymbol,
    required this.symbol,
    required this.type,
  });

  factory SymbolSearchResult.fromJson(Map<String, dynamic> json) {
    return SymbolSearchResult(
      description: json['description'] ?? '',
      displaySymbol: json['displaySymbol'] ?? '',
      symbol: json['symbol'] ?? '',
      type: json['type'] ?? '',
    );
  }
}
