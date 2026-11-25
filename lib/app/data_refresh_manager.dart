import 'dart:async';
import 'package:injectable/injectable.dart';

/// Broadcasts domain-level data mutation events so active cubits
/// (e.g. Home dashboard, Transactions list, Statistics/Reports)
/// refresh immediately without relying on shared singleton cubits.
@lazySingleton
class DataRefreshManager {
  final StreamController<void> _transactionsController =
      StreamController<void>.broadcast();

  Stream<void> get onTransactionsChanged => _transactionsController.stream;

  void notifyTransactionsChanged() {
    if (!_transactionsController.isClosed) {
      _transactionsController.add(null);
    }
  }

  void dispose() => _transactionsController.close();
}
