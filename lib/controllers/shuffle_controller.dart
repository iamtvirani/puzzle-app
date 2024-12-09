import 'package:flutter/material.dart';
import 'package:puzzle_app/enums/shuffle_action.dart';

class ShuffleController extends ChangeNotifier {

  bool isSomeOneAnimating = false;

  ShuffleAction shuffleAction = ShuffleAction.noChange;

  void doAnimate(ShuffleAction action) {
    shuffleAction = action;
    notifyListeners();
  }
}