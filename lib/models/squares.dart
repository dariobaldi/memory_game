import 'dart:math';

import 'package:flutter/material.dart';

class Squares extends ChangeNotifier {
  int _size = 2;
  List<int> _series = List<int>.empty();
  List<int> _seriesHidden = List<int>.empty();
  final List<int> _selected = List<int>.empty(growable: true);

  Squares();

  int get size => _size;
  List<int> get series => _series;
  List<int> get seriesHidden => _seriesHidden;
  List<int> get selected => _selected;

  void generateSeries() {
    // Create a list containing numbers from 0 to X^2
    List<int> numbers = List.generate(_size * _size, (i) => i);

    // Create a Random object
    Random random = Random();

    // Fisher-Yates shuffle
    for (int i = numbers.length - 1; i > 0; i--) {
      int j = random.nextInt(i + 1);
      int temp = numbers[i];
      numbers[i] = numbers[j];
      numbers[j] = temp;
    }
    _seriesHidden = numbers.sublist(0, _size);
    notifyListeners();
  }

  void nextLevel() {
    _size += 1;
    selected.clear();
    notifyListeners();
  }

  void previousLevel() {
    if (_size == 2) return;
    _size -= 1;
    selected.clear();
    notifyListeners();
  }

  void show(bool show) {
    if (show) {
      _series = _seriesHidden;
    } else {
      _series = List.empty();
    }
    notifyListeners();
  }

  void select(int i) {
    if (selected.contains(i)) {
      _selected.remove(i);
    } else {
      _selected.add(i);
    }
    notifyListeners();
  }

  Future<void> play() async {
    selected.clear();
    generateSeries();
    for (var i in _seriesHidden) {
      _series = [i];
      notifyListeners();
      await Future.delayed(const Duration(seconds: 1));
    }
    _series = List.empty();
    notifyListeners();
  }
}
