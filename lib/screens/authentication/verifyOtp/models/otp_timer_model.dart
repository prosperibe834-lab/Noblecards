import 'dart:async';
import 'package:flutter/foundation.dart';

class OtpTimerModel extends ChangeNotifier {
  static const int _initialDuration = 165; // 02:45 in seconds
  int _secondsRemaining = _initialDuration;
  Timer? _timer;
  bool _isExpired = false;

  int get secondsRemaining => _secondsRemaining;
  bool get isExpired => _isExpired;

  String get formattedTime {
    int minutes = _secondsRemaining ~/ 60;
    int seconds = _secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void startTimer() {
    _isExpired = false;
    _secondsRemaining = _initialDuration;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        notifyListeners();
      } else {
        _isExpired = true;
        _timer?.cancel();
        notifyListeners();
      }
    });
    notifyListeners();
  }

  void resetTimer() {
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}