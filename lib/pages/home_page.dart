import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobilep2/models/finnhub_info.dart';
import 'package:mobilep2/pages/stock_page.dart' show NewsTile, StockPage;
import 'package:mobilep2/pages/watchlist_page.dart' show WatchlistScreen;
import 'package:mobilep2/services/remote_services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:collection/collection.dart';
import 'package:mobilep2/services/watchlist_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({this.symbols = const [], super.key});
  final List<String> symbols;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.list_alt),
            tooltip: 'Go to Watchlist',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WatchlistScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            WatchlistProvider(
              child: Builder(
                builder: (context) {
                  final watchlistProvider = WatchlistProvider.of(context);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchableSymbolList(
                        symbols: watchlistProvider.symbols,
                        onWatchlistUpdated: watchlistProvider.refreshWatchlist,
                      ),
                      Text("My Symbols"),
                      StockList(watchlistProvider.symbols),
                    ],
                  );
                },
              ),
            ),
            Text("News Feed"),
            NewsList(),
          ],
        ),
      ),
    );
  }
}

class WatchlistData {
  final List<String> symbols;
  final bool isLoading;
  final Function() refreshWatchlist;

  WatchlistData({
    required this.symbols,
    required this.isLoading,
    required this.refreshWatchlist,
  });
}

class WatchlistProvider extends StatefulWidget {
  final Widget child;

  const WatchlistProvider({super.key, required this.child});

  static WatchlistData of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<_WatchlistInherited>();
    if (provider == null) {
      throw FlutterError('WatchlistProvider not found in context');
    }

    return WatchlistData(
      symbols: provider.data.symbols,
      isLoading: provider.data.isLoading,
      refreshWatchlist: provider.data.refreshWatchlist,
    );
  }

  @override
  State<WatchlistProvider> createState() => _WatchlistProviderState();
}

class _WatchlistProviderState extends State<WatchlistProvider> {
  List<String> symbols = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    refreshWatchlist();
  }

  Future<void> refreshWatchlist() async {
    setState(() {
      isLoading = true;
    });
    try {
      final watchlist = await WatchlistService().getWatchlist();
      setState(() {
        symbols = watchlist;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading watchlist: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _WatchlistInherited(data: this, child: widget.child);
  }
}

class _WatchlistInherited extends InheritedWidget {
  final _WatchlistProviderState data;

  const _WatchlistInherited({required this.data, required super.child});

  @override
  bool updateShouldNotify(_WatchlistInherited oldWidget) {
    return true;
  }
}

class SearchableSymbolList extends StatefulWidget {
  const SearchableSymbolList({
    super.key,
    required this.symbols,
    required this.onWatchlistUpdated,
  });

  final List<String> symbols;
  final Function() onWatchlistUpdated;

  @override
  State<SearchableSymbolList> createState() => _SearchableSymbolListState();
}

class _SearchableSymbolListState extends State<SearchableSymbolList> {
  late TextEditingController searchController;
  List<SymbolSearchResult> searchResults = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> searchSymbols(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final results = await RemoteService().searchSymbols(query);
      setState(() {
        searchResults = results;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        searchResults = [];
        isLoading = false;
      });
      print('Error searching symbols: $e');
    }
  }

  Future<void> addToWatchlist(String symbol) async {
    try {
      await WatchlistService().addToWatchlist(symbol);
      if (!mounted) return;
      {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$symbol added to watchlist')));

        widget.onWatchlistUpdated();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add $symbol: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: "Search stocks...",
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  searchController.clear();
                  searchSymbols("");
                },
              ),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (query) {
              searchSymbols(query);
            },
          ),
          const SizedBox(height: 10),
          if (isLoading)
            CircularProgressIndicator()
          else if (searchResults.isNotEmpty)
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final result = searchResults[index];
                  return ListTile(
                    title: Text('${result.symbol} - ${result.description}'),
                    subtitle: Text(result.type),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => addToWatchlist(result.symbol),
                    ),
                  );
                },
              ),
            )
          else if (searchController.text.isNotEmpty)
            Text("No results found"),
          const SizedBox(height: 10),
          Text(
            "My Watchlist",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
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
      var maxCount = min(4, symbols.length);
      return SizedBox(
        height: 200,
        child: ListView.separated(
          itemCount: maxCount,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            if (index == maxCount - 1) {
              return EndingTile();
            } else {
              print(symbols);
              print(index);
              print(symbols[index]);
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StockPage(symbol)),
        );
      },
      child: ClipRRect(
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
        } else if (!snapshot.hasData) {
          return ErrorTile("No data found?");
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
      body: FutureBuilder(
        future: _surpriseData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return ErrorTile(snapshot.error!);
          } else if (!snapshot.hasData) {
            return ErrorTile("No data for symbol: ${widget.symbol}");
          } else {
            List<EarningsSurprisesData> data = snapshot.data!.sorted(
              (a, b) => a.period.compareTo(b.period),
            );
            return EarningsChart(data);
          }
        },
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
    return LineChart(
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
    );
  }
}
