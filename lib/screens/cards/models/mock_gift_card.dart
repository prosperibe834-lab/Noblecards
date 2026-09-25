class MockGiftCard {
  final String id;
  final String brand;
  final String category;
  final String country;
  final String rate;
  final String minDenomination;
  final String maxDenomination;
  final String badge;
  final bool isBuy;
  final bool isSell;

  MockGiftCard({
    required this.id,
    required this.brand,
    required this.category,
    required this.country,
    required this.rate,
    required this.minDenomination,
    required this.maxDenomination,
    required this.badge,
    required this.isBuy,
    required this.isSell,
  });
}

final List<MockGiftCard> mockGiftCards = [
  MockGiftCard(id: '1', brand: 'Amazon', category: 'Shopping', country: 'United States', rate: '82%', minDenomination: '5', maxDenomination: '500', badge: 'Hot', isBuy: true, isSell: true),
  MockGiftCard(id: '2', brand: 'Apple', category: 'Entertainment', country: 'United States', rate: '80%', minDenomination: '10', maxDenomination: '500', badge: 'Trending', isBuy: true, isSell: true),
  MockGiftCard(id: '3', brand: 'Google Play', category: 'Gaming', country: 'United States', rate: '81%', minDenomination: '10', maxDenomination: '200', badge: 'Popular', isBuy: true, isSell: true),
  MockGiftCard(id: '4', brand: 'PlayStation', category: 'Gaming', country: 'United States', rate: '80%', minDenomination: '10', maxDenomination: '100', badge: 'Trending', isBuy: true, isSell: true),
  MockGiftCard(id: '5', brand: 'eBay', category: 'Shopping', country: 'United States', rate: '78%', minDenomination: '10', maxDenomination: '250', badge: 'Popular', isBuy: true, isSell: true),
  MockGiftCard(id: '6', brand: 'Spotify', category: 'Entertainment', country: 'United States', rate: '77%', minDenomination: '10', maxDenomination: '100', badge: 'Top Rate', isBuy: true, isSell: true),
  MockGiftCard(id: '7', brand: 'Uber', category: 'Dining', country: 'United States', rate: '75%', minDenomination: '15', maxDenomination: '200', badge: '', isBuy: true, isSell: false),
  MockGiftCard(id: '8', brand: 'Walmart', category: 'Shopping', country: 'United States', rate: '79%', minDenomination: '5', maxDenomination: '500', badge: '', isBuy: true, isSell: true),
  MockGiftCard(id: '9', brand: 'Netflix', category: 'Entertainment', country: 'United States', rate: '76%', minDenomination: '15', maxDenomination: '200', badge: 'Hot', isBuy: true, isSell: true),
  MockGiftCard(id: '10', brand: 'Steam', category: 'Gaming', country: 'United States', rate: '83%', minDenomination: '20', maxDenomination: '100', badge: 'Top Rate', isBuy: true, isSell: true),
  MockGiftCard(id: '11', brand: 'Razer Gold', category: 'Gaming', country: 'United States', rate: '85%', minDenomination: '10', maxDenomination: '500', badge: 'Hot', isBuy: true, isSell: true),
  MockGiftCard(id: '12', brand: 'Roblox', category: 'Gaming', country: 'United States', rate: '72%', minDenomination: '10', maxDenomination: '100', badge: '', isBuy: true, isSell: false),
];