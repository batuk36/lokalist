import 'package:flutter/material.dart';

class TemaYonetici extends ChangeNotifier {
  bool _karanlikMod = true;

  bool get karanlikMod => _karanlikMod;

  void degistir(bool deger) {
    _karanlikMod = deger;
    notifyListeners();
  }
}