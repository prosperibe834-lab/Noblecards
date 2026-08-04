import 'package:flutter/material.dart';
import '../models/submission_model.dart';
import '../services/submission_service.dart';

enum SubmissionState { loading, success, error }

class SubmissionProvider extends ChangeNotifier {
  final SubmissionService _service = SubmissionService();
  
  SubmissionState _state = SubmissionState.loading;
  SubmissionModel? _submissionData;
  String _errorMessage = '';

  SubmissionState get state => _state;
  SubmissionModel? get submissionData => _submissionData;
  String get errorMessage => _errorMessage;

  void fetchDetails(String transactionId) async {
    _state = SubmissionState.loading;
    notifyListeners();

    try {
      _submissionData = await _service.fetchSubmissionDetails(transactionId);
      _state = SubmissionState.success;
    } catch (e) {
      _errorMessage = e.toString();
      _state = SubmissionState.error;
    }
    notifyListeners();
  }
}