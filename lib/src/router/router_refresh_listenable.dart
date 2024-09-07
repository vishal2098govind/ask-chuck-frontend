import 'package:flutter/material.dart';

class RouterRefreshListenable extends ChangeNotifier {
  static final RouterRefreshListenable _instance = RouterRefreshListenable._();

  RouterRefreshListenable._();

  static RouterRefreshListenable get instance => _instance;

  void refresh() {
    notifyListeners();
  }
}
