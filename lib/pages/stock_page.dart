import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobilep2/models/finnhub_info.dart';
import 'package:mobilep2/pages/home_page.dart';
import 'package:mobilep2/services/remote_services.dart';

class StockPage extends StatefulWidget {
  const StockPage(this.symbol, {super.key});
  final String symbol;

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  late final Future<CompanyData> _companyData;
  late final Future<List<NewsData>?> _newsData;
  @override
  void initState() {
    // TODO: implement symbol
    super.initState();
    _companyData = RemoteService().getCompanyData();
    _newsData = RemoteService().getNewsData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([_companyData, _newsData]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text("Waiting...")),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text("Error")),
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text((snapshot.data![0] as CompanyData).name),
            ),
            body: CompanyLayout(
              companyData: (snapshot.data![0] as CompanyData),
              newsData: (snapshot.data![1] as List<NewsData>),
            ),
          );
        }
      },
    );
  }
}

class CompanyLayout extends StatelessWidget {
  CompanyLayout({required this.companyData, required this.newsData, super.key});
  final CompanyData companyData;
  final List<NewsData> newsData;
  late final List<Text> infoList = [
    Text("Country: ${companyData.country}"),
    Text("Currency: ${companyData.currency}"),
    Text("Exchange: ${companyData.exchange}"),
    Text("Ipo: ${companyData.ipo}"),
    Text("MarketCapitalization: ${companyData.marketCapitalization}"),
    Text("Phone: ${companyData.phone}"),
    Text("Outstanding Shares: ${companyData.shareOutstanding}"),
    Text("Web Url: ${companyData.weburl}"),
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text("Charts"),
          ChartGrid(),
          Text("Info"),
          ...infoList,
          Text("News"),
          NewsList(newsData),
        ],
      ),
    );
  }
}

class ChartGrid extends StatelessWidget {
  const ChartGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: 4,
      itemBuilder: (context, index) => StockTile(),
    );
  }
}

class NewsList extends StatelessWidget {
  const NewsList(this.data, {super.key});
  final List<NewsData> data;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: min(data.length, 10),
      itemBuilder:
          (context, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 30,
              color: Colors.blue,
              child: Text(data[index].headline),
            ),
          ),
    );
  }
}
