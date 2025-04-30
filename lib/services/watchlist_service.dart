import 'package:cloud_firestore/cloud_firestore.dart';

class WatchlistService {
  final CollectionReference watchlistCollection = FirebaseFirestore.instance
      .collection('watchlist');

  Future<void> addToWatchlist(String symbol) async {
    final existing =
        await watchlistCollection.where('symbol', isEqualTo: symbol).get();

    if (existing.docs.isEmpty) {
      await watchlistCollection.add({'symbol': symbol});
    }
  }

  Future<void> removeFromWatchlist(String symbol) async {
    final snapshots =
        await watchlistCollection.where('symbol', isEqualTo: symbol).get();

    for (final doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  Future<List<String>> getWatchlist() async {
    final snapshot = await watchlistCollection.get();
    return snapshot.docs.map((doc) => doc['symbol'] as String).toList();
  }
}
