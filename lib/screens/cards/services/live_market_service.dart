import '../models/live_market_model.dart';

class LiveMarketService {
  Future<List<LiveMarketModel>> fetchLiveMarketEvents() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      LiveMarketModel(
        id: '1',
        cardName: 'Apple US',
        logoUrl: 'https://cdn-icons-png.flaticon.com/512/0/747.png',
        countryFlag: '🇺🇸',
        actionType: 'sold',
        timeAgo: '2m ago',
      ),
      LiveMarketModel(
        id: '2',
        cardName: 'Steam UK',
        logoUrl: 'https://cdn-icons-png.flaticon.com/512/220/220223.png',
        countryFlag: '🇬🇧',
        actionType: 'sold',
        timeAgo: '1m ago',
      ),
      LiveMarketModel(
        id: '3',
        cardName: 'Amazon CA',
        logoUrl: 'https://cdn-icons-png.flaticon.com/512/732/732177.png',
        countryFlag: '🇨🇦',
        actionType: 'sold',
        timeAgo: '30s ago',
      ),
      LiveMarketModel(
        id: '4',
        cardName: 'Spotify DE',
        logoUrl: 'https://cdn-icons-png.flaticon.com/512/2111/2111624.png',
        countryFlag: '🇩🇪',
        actionType: 'sold',
        timeAgo: '4m ago',
      ),
    ];
  }
}