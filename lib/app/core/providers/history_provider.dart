import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
import '../models/qr_code_model.dart';

class HistoryProvider with ChangeNotifier {
  List<QRCodeModel> _history = [];
  bool _isLoading = false;

  List<QRCodeModel> get history => _history;
  bool get isLoading => _isLoading;

  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      final db = DatabaseHelper.instance;
      final List<Map<String, dynamic>> maps = await db.queryAllRows();
      _history = List.generate(maps.length, (i) {
        return QRCodeModel.fromMap(maps[i]);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading history: $e');
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addToHistory(QRCodeModel qrCode) async {
    try {
      final db = DatabaseHelper.instance;
      final id = await db.insert(qrCode.toMap());
      qrCode.id = id;
      _history.insert(0, qrCode);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error adding to history: $e');
      }
    }
  }

  Future<void> deleteFromHistory(int id) async {
    try {
      final db = DatabaseHelper.instance;
      await db.delete(id);
      _history.removeWhere((qr) => qr.id == id);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting from history: $e');
      }
    }
  }

  Future<void> clearHistory() async {
    try {
      final db = DatabaseHelper.instance;
      await db.deleteAll();
      _history.clear();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing history: $e');
      }
    }
  }
}
