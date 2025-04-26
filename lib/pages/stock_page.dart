import 'package:flutter/material.dart';
import 'package:mobilep2/pages/home_page.dart';

class StockPage extends StatelessWidget {
  const StockPage({super.key, required this.stockSymbol});
  final String stockSymbol;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(stockSymbol)),
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
