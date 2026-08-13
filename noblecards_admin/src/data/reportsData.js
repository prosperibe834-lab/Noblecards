// src/data/reportsData.js

export const generateMockData = (multiplier = 1) => {
  return {
    summary: {
      revenue: 24820 * multiplier,
      revenueChange: 16.3,
      transactionVolume: 182400 * multiplier,
      volumeChange: 11.4,
      netRevenue: 8420 * multiplier,
      netChange: 5.2,
      giftCardRevenue: 14200 * multiplier,
      gcChange: 12.1,
      deposits: 90200 * multiplier,
      depositsChange: 8.2,
      withdrawals: 61300 * multiplier,
      withdrawalsChange: 5.1,
      totalUsers: Math.floor(12500 * multiplier),
      usersChange: 4.5,
      activeUsers: Math.floor(8200 * multiplier),
      activeChange: 2.1,
    },
    insights: [
      "Withdrawal failures decreased by 4% this period.",
      "Gift card sales increased by 12% across Apple and Steam categories.",
      "Nigeria generated 42% of the overall transaction volume.",
      "Support resolution time improved by 1.2 hours on average."
    ],
    financialSummary: [
      { metric: "Revenue", current: 24820 * multiplier, previous: 21400 * multiplier, change: 16 },
      { metric: "Transaction Volume", current: 182400 * multiplier, previous: 164000 * multiplier, change: 11 },
      { metric: "Deposits", current: 90200 * multiplier, previous: 83100 * multiplier, change: 8 },
      { metric: "Withdrawals", current: 61300 * multiplier, previous: 58400 * multiplier, change: 5 },
      { metric: "Fees Collected", current: 4200 * multiplier, previous: 3900 * multiplier, change: 7.6 },
    ],
    revenueChart: [
      { name: "Mon", revenue: 1200 * multiplier, volume: 8000 * multiplier, net: 400 * multiplier },
      { name: "Tue", revenue: 2100 * multiplier, volume: 15000 * multiplier, net: 700 * multiplier },
      { name: "Wed", revenue: 1800 * multiplier, volume: 12000 * multiplier, net: 600 * multiplier },
      { name: "Thu", revenue: 2400 * multiplier, volume: 18000 * multiplier, net: 800 * multiplier },
      { name: "Fri", revenue: 2900 * multiplier, volume: 22000 * multiplier, net: 950 * multiplier },
      { name: "Sat", revenue: 3500 * multiplier, volume: 28000 * multiplier, net: 1200 * multiplier },
      { name: "Sun", revenue: 3100 * multiplier, volume: 24000 * multiplier, net: 1050 * multiplier },
    ],
    statusChart: [
      { name: "Successful", value: 75, fill: "var(--success-color)" },
      { name: "Pending", value: 15, fill: "var(--warning-color)" },
      { name: "Failed", value: 7, fill: "var(--danger-color)" },
      { name: "Refunded", value: 3, fill: "var(--info-color)" },
    ],
    giftCards: [
      { name: "Amazon", category: "Shopping", sold: Math.floor(4829 * multiplier), volume: 82400 * multiplier, revenue: 4200 * multiplier },
      { name: "Apple", category: "Tech", sold: Math.floor(3982 * multiplier), volume: 64300 * multiplier, revenue: 3700 * multiplier },
      { name: "Steam", category: "Gaming", sold: Math.floor(2184 * multiplier), volume: 31200 * multiplier, revenue: 1800 * multiplier },
      { name: "Google Play", category: "Mobile", sold: Math.floor(1840 * multiplier), volume: 22100 * multiplier, revenue: 1100 * multiplier },
      { name: "Razer Gold", category: "Gaming", sold: Math.floor(1250 * multiplier), volume: 15400 * multiplier, revenue: 850 * multiplier },
    ],
    countries: [
      { name: "Nigeria", code: "NG", users: Math.floor(6500 * multiplier), volume: 120000 * multiplier, revenue: 12400 * multiplier },
      { name: "United Kingdom", code: "GB", users: Math.floor(2100 * multiplier), volume: 84200 * multiplier, revenue: 6200 * multiplier },
      { name: "United States", code: "US", users: Math.floor(1800 * multiplier), volume: 76400 * multiplier, revenue: 5800 * multiplier },
      { name: "Ghana", code: "GH", users: Math.floor(1200 * multiplier), volume: 32100 * multiplier, revenue: 2100 * multiplier },
    ],
    currencies: [
      { name: "USD", deposit: 45000 * multiplier, withdrawal: 28000 * multiplier, volume: 95000 * multiplier, revenue: 12000 * multiplier },
      { name: "NGN (in USD)", deposit: 32000 * multiplier, withdrawal: 22000 * multiplier, volume: 65000 * multiplier, revenue: 8500 * multiplier },
      { name: "GBP", deposit: 18000 * multiplier, withdrawal: 11000 * multiplier, volume: 42000 * multiplier, revenue: 4200 * multiplier },
    ]
  };
};