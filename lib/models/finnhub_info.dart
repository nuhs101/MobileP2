import 'dart:convert';

CompanyData companyDataFromJson(String str) =>
    CompanyData.fromJson(json.decode(str));

String companyDataToJson(CompanyData data) => json.encode(data.toJson());

class CompanyData {
  String country;
  String currency;
  String exchange;
  DateTime ipo;
  double marketCapitalization;
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

  static CompanyData get defaultData => CompanyData(
    country: "None",
    currency: "None",
    exchange: "None",
    ipo: DateTime.now(),
    marketCapitalization: 0,
    name: "",
    phone: "",
    shareOutstanding: 0,
    ticker: "",
    weburl: "",
    logo: "",
    finnhubIndustry: "",
  );

  factory CompanyData.fromJson(Map<String, dynamic> json) => CompanyData(
    country: json["country"],
    currency: json["currency"],
    exchange: json["exchange"],
    ipo: DateTime.parse(json["ipo"]),
    marketCapitalization: json["marketCapitalization"],
    name: json["name"],
    phone: json["phone"],
    shareOutstanding: json["shareOutstanding"]?.toDouble(),
    ticker: json["ticker"],
    weburl: json["weburl"],
    logo: json["logo"],
    finnhubIndustry: json["finnhubIndustry"],
  );

  Map<String, dynamic> toJson() => {
    "country": country,
    "currency": currency,
    "exchange": exchange,
    "ipo":
        "${ipo.year.toString().padLeft(4, '0')}-${ipo.month.toString().padLeft(2, '0')}-${ipo.day.toString().padLeft(2, '0')}",
    "marketCapitalization": marketCapitalization,
    "name": name,
    "phone": phone,
    "shareOutstanding": shareOutstanding,
    "ticker": ticker,
    "weburl": weburl,
    "logo": logo,
    "finnhubIndustry": finnhubIndustry,
  };
}

List<EarningsSurprisesData> earningsSurprisesDataFromJson(String str) =>
    List<EarningsSurprisesData>.from(
      json.decode(str).map((x) => EarningsSurprisesData.fromJson(x)),
    );

String earningsSurprisesDataToJson(List<EarningsSurprisesData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EarningsSurprisesData {
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

  static EarningsSurprisesData get defaultData => EarningsSurprisesData(
    actual: 0,
    estimate: 0,
    period: DateTime.now(),
    quarter: 0,
    surprise: 0,
    surprisePercent: 0,
    symbol: "",
    year: 1,
  );

  factory EarningsSurprisesData.fromJson(Map<String, dynamic> json) =>
      EarningsSurprisesData(
        actual: json["actual"]?.toDouble(),
        estimate: json["estimate"]?.toDouble(),
        period: DateTime.parse(json["period"]),
        quarter: json["quarter"],
        surprise: json["surprise"]?.toDouble(),
        surprisePercent: json["surprisePercent"]?.toDouble(),
        symbol: json["symbol"],
        year: json["year"],
      );

  Map<String, dynamic> toJson() => {
    "actual": actual,
    "estimate": estimate,
    "period":
        "${period.year.toString().padLeft(4, '0')}-${period.month.toString().padLeft(2, '0')}-${period.day.toString().padLeft(2, '0')}",
    "quarter": quarter,
    "surprise": surprise,
    "surprisePercent": surprisePercent,
    "symbol": symbol,
    "year": year,
  };
}

EarningsCalendarData earningsCalendarDataFromJson(String str) =>
    EarningsCalendarData.fromJson(json.decode(str));

String earningsCalendarDataToJson(EarningsCalendarData data) =>
    json.encode(data.toJson());

class EarningsCalendarData {
  List<EarningsCalendar> earningsCalendar;

  EarningsCalendarData({required this.earningsCalendar});
  static EarningsCalendarData get defaultData => EarningsCalendarData(
    earningsCalendar: [
      EarningsCalendar(
        date: DateTime.now(),
        epsActual: 0,
        epsEstimate: 0,
        hour: Hour.empty,
        quarter: 0,
        revenueActual: 0,
        revenueEstimate: 0,
        symbol: "",
        year: 0,
      ),
    ],
  );
  factory EarningsCalendarData.fromJson(Map<String, dynamic> json) =>
      EarningsCalendarData(
        earningsCalendar: List<EarningsCalendar>.from(
          json["earningsCalendar"].map((x) => EarningsCalendar.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "earningsCalendar": List<dynamic>.from(
      earningsCalendar.map((x) => x.toJson()),
    ),
  };
}

class EarningsCalendar {
  DateTime date;
  double? epsActual;
  double? epsEstimate;
  Hour hour;
  int quarter;
  int? revenueActual;
  int? revenueEstimate;
  String symbol;
  int year;

  EarningsCalendar({
    required this.date,
    required this.epsActual,
    required this.epsEstimate,
    required this.hour,
    required this.quarter,
    required this.revenueActual,
    required this.revenueEstimate,
    required this.symbol,
    required this.year,
  });

  static EarningsCalendar get defaultData => EarningsCalendar(
    date: DateTime.now(),
    epsActual: 0,
    epsEstimate: 0,
    hour: Hour.empty,
    quarter: 0,
    revenueActual: 0,
    revenueEstimate: 0,
    symbol: "",
    year: 0,
  );

  factory EarningsCalendar.fromJson(Map<String, dynamic> json) =>
      EarningsCalendar(
        date: DateTime.parse(json["date"]),
        epsActual: json["epsActual"]?.toDouble(),
        epsEstimate: json["epsEstimate"]?.toDouble(),
        hour: hourValues.map[json["hour"]]!,
        quarter: json["quarter"],
        revenueActual: json["revenueActual"],
        revenueEstimate: json["revenueEstimate"],
        symbol: json["symbol"],
        year: json["year"],
      );

  Map<String, dynamic> toJson() => {
    "date":
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "epsActual": epsActual,
    "epsEstimate": epsEstimate,
    "hour": hourValues.reverse[hour],
    "quarter": quarter,
    "revenueActual": revenueActual,
    "revenueEstimate": revenueEstimate,
    "symbol": symbol,
    "year": year,
  };
}

enum Hour { amc, bmo, dmh, empty }

final hourValues = EnumValues({
  "amc": Hour.amc,
  "bmo": Hour.bmo,
  "dmh": Hour.dmh,
  "": Hour.empty,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

QuoteData quoteDataFromJson(String str) => QuoteData.fromJson(json.decode(str));

String quoteDataToJson(QuoteData data) => json.encode(data.toJson());

class QuoteData {
  double current;
  double high;
  double low;
  double open;
  double previousClose;
  int timestamp;

  QuoteData({
    required this.current,
    required this.high,
    required this.low,
    required this.open,
    required this.previousClose,
    required this.timestamp,
  });
  static QuoteData get defaultData => QuoteData(
    current: 0,
    high: 0,
    low: 0,
    open: 0,
    previousClose: 0,
    timestamp: 0,
  );
  factory QuoteData.fromJson(Map<String, dynamic> json) => QuoteData(
    current: json["c"]?.toDouble(),
    high: json["h"]?.toDouble(),
    low: json["l"]?.toDouble(),
    open: json["o"]?.toDouble(),
    previousClose: json["pc"]?.toDouble(),
    timestamp: json["t"],
  );

  Map<String, dynamic> toJson() => {
    "c": current,
    "h": high,
    "l": low,
    "o": open,
    "pc": previousClose,
    "t": timestamp,
  };
}
