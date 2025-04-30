import 'package:flutter/material.dart';
import 'package:mobilep2/models/finnhub_info.dart';
import 'package:mobilep2/pages/home_page.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key, required this.stockSymbol});
  final String stockSymbol;

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  late final Future<CompanyData> _companyData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.stockSymbol)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("Charts"),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: 16,
              itemBuilder: (context, index) => StockTile(),
            ),
            Text("Info"),
            Text("News"),
          ],
        ),
      ),
    );
  }
}
