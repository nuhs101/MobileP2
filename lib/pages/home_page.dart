import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobilep2/models/finnhub_info.dart';
import 'package:mobilep2/services/remote_services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:collection/collection.dart';

class Charts extends StatefulWidget {
  const Charts({super.key});

  @override
  State<Charts> createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {
  late Future<List<EarningsSurprisesData>> _surpriseData;
  late Future<CompanyData> _companyData;
  @override
  void initState() {
    super.initState();
    _surpriseData = RemoteService().getSurprisesData();
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
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  // TODO implement error handling
                  print(snapshot.error);
                  return StockTile();
                }
                List<EarningsSurprisesData> data = snapshot.data!.sorted(
                  (a, b) => a.period.compareTo(b.period),
                );
                return EarningsChart(data);
              } else {
                return Center(child: CircularProgressIndicator());
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Watchlist"),
            StockList(),
            Text("News Feed"),
            NewsGrid(),
          ],
        ),
      ),
    );
  }
}

class StockList extends StatelessWidget {
  const StockList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        itemCount: 4,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => StockTile(),
        separatorBuilder: (context, index) => SizedBox(width: 10),
      ),
    );
  }
}

class StockTile extends StatelessWidget {
  const StockTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          color: Colors.indigo[400],
          child: Text("This is default text"),
        ),
      ),
    );
  }
}

class NewsGrid extends StatelessWidget {
  const NewsGrid({super.key});

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
      itemCount: 16,
      itemBuilder: (context, index) => StockTile(),
    );
  }
}
