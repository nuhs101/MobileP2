import 'dart:convert';

class CompanyData {
  // Expected output from json:
  //   "country": "US",
  //   "currency": "USD",
  //   "exchange": "NASDAQ/NMS (GLOBAL MARKET)",
  //   "ipo": "1980-12-12",
  //   "marketCapitalization": 1415993,
  //   "name": "Apple Inc",
  //   "phone": "14089961010",
  //   "shareOutstanding": 4375.47998046875,
  //   "ticker": "AAPL",
  //   "weburl": "https://www.apple.com/",
  //   "logo": "https://static.finnhub.io/logo/87cb30d8-80df-11ea-8951-00000000092a.png",
  //   "finnhubIndustry":"Technology"
  String country;
  String currency;
  String exchange;
  DateTime ipo;
  int marketCapitalization;
  String name;
  String phone;
  double shareOutstanding;
  String ticker;
  String weburl;
  String logo;
  String finnhubIndustry;

  CompanyData({
    required this.country,
    required this.currency,
    required this.exchange,
    required this.ipo,
    required this.marketCapitalization,
    required this.name,
    required this.phone,
    required this.shareOutstanding,
    required this.ticker,
    required this.weburl,
    required this.logo,
    required this.finnhubIndustry,
  });

  factory CompanyData.fromJson(Map<String, dynamic> json) => CompanyData(
    country: json["country"],
    currency: json["currency"],
    exchange: json["exchange"],
    ipo: json["ipo"],
    marketCapitalization: json["marketCapitalization"],
    name: json["name"],
    phone: json["phone"],
    shareOutstanding: json["shareOutstanding"],
    ticker: json["ticker"],
    weburl: json["weburl"],
    logo: json["logo"],
    finnhubIndustry: json["finnhubIndustry"],
  );
}
List<EarningsSurprisesData> surprisesListFromJson(dynamic jsonList) {
    return List<EarningsSurprisesData>.from(
        jsonDecode(jsonList).map((x) => EarningsSurprisesData.fromJson(x)),
      );
  }
class EarningsSurprisesData {
  // Expected Output from json:
  //   [
  //   {
  //     "actual": 1.88,
  //     "estimate": 1.9744,
  //     "period": "2023-03-31",
  //     "quarter": 1,
  //     "surprise": -0.0944,
  //     "surprisePercent": -4.7812,
  //     "symbol": "AAPL",
  //     "year": 2023
  //   },
  //   {
  //     "actual": 1.29,
  //     "estimate": 1.2957,
  //     "period": "2022-12-31",
  //     "quarter": 4,
  //     "surprise": -0.0057,
  //     "surprisePercent": -0.4399,
  //     "symbol": "AAPL",
  //     "year": 2022
  //   },
  //   {
  //     "actual": 1.2,
  //     "estimate": 1.1855,
  //     "period": "2022-09-30",
  //     "quarter": 3,
  //     "surprise": 0.0145,
  //     "surprisePercent": 1.2231,
  //     "symbol": "AAPL",
  //     "year": 2022
  //   }
  // ]
  double actual;
  double estimate;
  DateTime period;
  int quarter;
  double surprise;
  double surprisePercent;
  String symbol;
  int year;

  EarningsSurprisesData({
    required this.actual,
    required this.estimate,
    required this.period,
    required this.quarter,
    required this.surprise,
    required this.surprisePercent,
    required this.symbol,
    required this.year,
  });


      
  factory EarningsSurprisesData.fromJson(Map<String, dynamic> json) =>
      EarningsSurprisesData(
        actual: json["actual"],
        estimate: json["estimate"],
        period: DateTime.parse(json["period"]),
        quarter: json["quarter"],
        surprise: json["surprise"],
        surprisePercent: json["surprisePercent"],
        symbol: json["symbol"],
        year: json["year"],
      );
}
