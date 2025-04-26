import 'package:flutter/material.dart';
import 'package:mobilep2/api/api_key.dart';
import 'package:http/http.dart' as http;
import 'package:mobilep2/models/finnhub_info.dart';
import 'package:mobilep2/services/remote_services.dart';

class TempStockData extends StatefulWidget {
  const TempStockData({super.key});

  @override
  State<TempStockData> createState() => _TempStockDataState();
}

class _TempStockDataState extends State<TempStockData> {
  // CompanyData? data;
  // var isLoaded = false;

  // @override
  // void initState() {
  //   super.initState();
  //   getData();
  // }
  // getData() async {
  //   data = await RemoteService().getCompanyData();
  //   if (data != null) {
  //     setState(() {
  //       isLoaded = true;
  //     });
  //   }
  // }

  List<EarningsSurprisesData?>? data;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    data = await RemoteService().getSurprisesData();
    if (data != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Visibility(
        visible: isLoaded,
        replacement: Center(child: CircularProgressIndicator()),
        child: ListView.builder(
          itemCount: data?.length,
          itemBuilder: (context, index) {
            EarningsSurprisesData? dataPoint = data?[index];
            return Column(
              children: [
                Text(dataPoint?.actual.toString() ?? ""),
                Text(dataPoint?.symbol ?? ""),
              ],
            );
          },
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
