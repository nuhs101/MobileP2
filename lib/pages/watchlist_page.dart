import 'package:flutter/material.dart';
import 'package:mobilep2/pages/stock_page.dart';
import 'package:mobilep2/services/watchlist_service.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  List<String> watchlist = [];

  Future<void> fetchWatchlist() async {
    final result = await WatchlistService().getWatchlist();
    setState(() {
      watchlist = result;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchWatchlist();
  }

  void removeStock(String stock) async {
    await WatchlistService().removeFromWatchlist(stock);
    fetchWatchlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Watchlist")),
      body: ListView.builder(
        itemCount: watchlist.length,
        itemBuilder: (context, index) {
          final stock = watchlist[index];
          return ListTile(
            title: Text(stock),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => removeStock(stock),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StockPage(stock)),
              );
            },
          );
        },
      ),
    );
  }
}
