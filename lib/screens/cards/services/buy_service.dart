class BuyService {
  // Mock service for current buy rate
  Future<double> fetchCurrentRate() async {
    await Future.delayed(const Duration(seconds: 1));
    return 93.20;
  }
}
