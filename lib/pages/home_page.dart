import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobilep2/models/finnhub_info.dart';
import 'package:mobilep2/pages/stock_page.dart' show NewsTile;
import 'package:mobilep2/pages/watchlist_page.dart' show WatchlistScreen;
import 'package:mobilep2/services/remote_services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:collection/collection.dart';

class HomePage extends StatelessWidget {
  const HomePage({this.symbols = const [], super.key});
  final List<String> symbols;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("My Symbols"),
            StockList(symbols),
            Text("News Feed"),
            NewsList(),
          ],
        ),
      ),
    );
  }
}

class StockList extends StatelessWidget {
  const StockList(this.symbols, {super.key});
  final List<String> symbols;
  @override
  Widget build(BuildContext context) {
    if (symbols.isEmpty) {
      return Text(
        "You have no symbols saved in your watchlist. Search symbols using the search bar!",
      );
    } else {
      return SizedBox(
        height: 200,
        child: ListView.separated(
          itemCount: min(4, symbols.length),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            if (index == min(4, symbols.length) - 1) {
              return EndingTile();
            } else {
              return StockTile(symbols[index]);
            }
          },
          separatorBuilder: (context, index) => SizedBox(width: 10),
        ),
      );
    }
  }
}

class StockTile extends StatelessWidget {
  const StockTile(this.symbol, {super.key});
  final String symbol;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          color: Colors.indigo[400],
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                child: Container(
                  alignment: Alignment.topCenter,
                  child: Text(symbol),
                ),
              ),
              Chart(symbol),
            ],
          ),
        ),
      ),
    );
  }
}

class NewsList extends StatefulWidget {
  const NewsList({super.key, this.filters});
  final List<String>? filters;

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  late Future<List<NewsData>?> newsData;
  // TODO: implement FILTERS
  @override
  void initState() {
    super.initState();
    newsData = RemoteService().getNewsData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: newsData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return ErrorTile(snapshot.error!);
        } else {
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: max((snapshot.data as List<NewsData>).length, 20),
            itemBuilder:
                (context, index) =>
                    NewsTile((snapshot.data as List<NewsData>)[index]),
          );
        }
      },
    );
  }
}

class ErrorTile extends StatelessWidget {
  const ErrorTile(this.error, {super.key});
  final Object error;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(color: Colors.red[400], child: Text(error.toString())),
      ),
    );
  }
}

class EndingTile extends StatelessWidget {
  const EndingTile({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WatchlistScreen()),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            color: Colors.blue[400],
            child: Text("See more in your watchlist!"),
          ),
        ),
      ),
    );
  }
}

class Chart extends StatefulWidget {
  const Chart(this.symbol, {super.key});
  final String symbol;
  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  late Future<List<EarningsSurprisesData>?> _surpriseData;
  @override
  void initState() {
    super.initState();
    _surpriseData = RemoteService().getSurprisesData(symbol: widget.symbol);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          FutureBuilder(
            future: _surpriseData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return ErrorTile(snapshot.error!);
              } else {
                List<EarningsSurprisesData> data = snapshot.data!.sorted(
                  (a, b) => a.period.compareTo(b.period),
                );
                return EarningsChart(data);
              }
            },
          ),
        ],
      ),
    );
  }
}

class EarningsChart extends StatelessWidget {
  EarningsChart(this.data, {super.key});
  final List<EarningsSurprisesData> data;
  late final List<FlSpot> points =
      data
          .mapIndexed(
            (index, earnings) => FlSpot(index.toDouble(), earnings.actual),
          )
          .toList();

  late final double verticalChartPadding =
      (points.map((point) => point.y).reduce(max) -
          points.map((point) => point.y).reduce(min)) *
      0.1;

  late final double minX = points.map((point) => point.x).reduce(min);
  late final double maxX = points.map((point) => point.x).reduce(max);
  late final double minY =
      points.map((point) => point.y).reduce(min) - verticalChartPadding;
  late final double maxY =
      points.map((point) => point.y).reduce(max) + verticalChartPadding;

  late final FlTitlesData titlesData = FlTitlesData(
    bottomTitles: AxisTitles(
      axisNameWidget: Text("Quarter"),
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      ),
    ),
    leftTitles: AxisTitles(
      axisNameWidget: Text("Actual Earnings"),
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        interval: 0.37,
        getTitlesWidget: leftTitleWidgets,
        minIncluded: false,
        maxIncluded: false,
      ),
    ),
    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
  );

  Text leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
    String text = meta.formattedValue;
    return Text(text, style: style, textAlign: TextAlign.left);
  }

  Text bottomTitleWidgets(double index, TitleMeta meta) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
    return Text(data[index.toInt()].quarter.toString(), style: style);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: LineChart(
        LineChartData(
          titlesData: titlesData,
          gridData: FlGridData(show: false),
          lineBarsData: [LineChartBarData(spots: points)],
          lineTouchData: LineTouchData(enabled: false),
          minX: minX,
          maxX: maxX,
          maxY: maxY,
          minY: minY,
        ),
      ),
    );
  }
}
