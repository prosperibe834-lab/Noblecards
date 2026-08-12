export const initialTransactions = [
  {
    id: "NC-TX-008492",
    userId: "NC-004829",
    userName: "Prosper Olorunfemi",
    userEmail: "prosper@example.com",
    userAvatar: "https://i.pravatar.cc/150?img=11",
    userPhone: "+234 812 345 6789",
    category: "Deposits",
    type: "Deposit",
    originalAmount: 500000,
    currency: "NGN",
    usdValue: 328.95,
    referenceRate: 1520,
    appliedRate: 1535,
    markup: "1.0%",
    grossAmount: 328.95,
    platformFee: 3.28,
    providerFee: 1.50,
    netAmount: 324.17,
    paymentMethod: "Bank Transfer",
    bankName: "GTBank",
    paymentReference: "DEP-928492",
    status: "Successful",
    source: "Mobile App",
    processingType: "Automatic",
    walletBefore: 1250.00,
    walletAfter: 1574.17,
    riskFlag: "Normal",
    reconciliationStatus: "Reconciled",
    reconciliationDiff: 0.00,
    notifications: { push: true, email: true, inApp: true },
    giftCardDetails: null,
    date: "2026-08-12T10:30:00Z",
    internalNotes: "User verified via Monnify webhook.",
    timeline: [
      { step: "Initiated", time: "10:30:01 AM", status: "completed" },
      { step: "Provider Confirmation", time: "10:30:04 AM", status: "completed" },
      { step: "Wallet Credited", time: "10:30:05 AM", status: "completed" }
    ],
    auditLogs: [
      { action: "Transaction Created", actor: "System Webhook", timestamp: "2026-08-12 10:30:01" },
      { action: "Payment Confirmed", actor: "GTBank API", timestamp: "2026-08-12 10:30:04" }
    ]
  },
  {
    id: "NC-TX-008493",
    userId: "NC-009102",
    userName: "Monica K.",
    userEmail: "monica@example.com",
    userAvatar: "https://i.pravatar.cc/150?img=5",
    userPhone: "+234 803 112 4455",
    category: "Gift Cards",
    type: "Gift Card Sale",
    originalAmount: 100,
    currency: "USD",
    usdValue: 100.00,
    referenceRate: 1.0,
    appliedRate: 1.0,
    markup: "0%",
    grossAmount: 100.00,
    platformFee: 5.00,
    providerFee: 0.00,
    netAmount: 95.00,
    paymentMethod: "Gift Card",
    bankName: null,
    paymentReference: "GC-SELL-1029",
    status: "Successful",
    source: "Web",
    processingType: "Automatic",
    walletBefore: 450.00,
    walletAfter: 545.00,
    riskFlag: "Normal",
    reconciliationStatus: "Reconciled",
    reconciliationDiff: 0.00,
    notifications: { push: true, email: true, inApp: true },
    giftCardDetails: {
      cardName: "Amazon Gift Card",
      cardId: "GC-004829",
      country: "United States",
      buyRate: 85,
      sellRate: 90,
      maskedCode: "AMZN-••••-••••-9821"
    },
    date: "2026-08-12T11:15:00Z",
    internalNotes: "Automated code claim verified.",
    timeline: [
      { step: "Code Submitted", time: "11:15:00 AM", status: "completed" },
      { step: "Partner Verification", time: "11:15:20 AM", status: "completed" },
      { step: "Payout Disbursed", time: "11:15:22 AM", status: "completed" }
    ],
    auditLogs: [
      { action: "Card Verified", actor: "GiftCard Gateway", timestamp: "2026-08-12 11:15:20" }
    ]
  },
  {
    id: "NC-TX-008494",
    userId: "NC-003310",
    userName: "Chidi Eze",
    userEmail: "chidi@example.com",
    userAvatar: "https://i.pravatar.cc/150?img=12",
    userPhone: "+234 701 998 2211",
    category: "Withdrawals",
    type: "Withdrawal",
    originalAmount: 250000,
    currency: "NGN",
    usdValue: 163.40,
    referenceRate: 1530,
    appliedRate: 1530,
    markup: "0%",
    grossAmount: 163.40,
    platformFee: 2.00,
    providerFee: 1.00,
    netAmount: 160.40,
    paymentMethod: "Bank Transfer",
    bankName: "Access Bank",
    paymentReference: "WTH-992104",
    status: "Pending",
    source: "Mobile App",
    processingType: "Automatic",
    walletBefore: 800.00,
    walletAfter: 636.60,
    riskFlag: "Review",
    reconciliationStatus: "Pending",
    reconciliationDiff: 0.00,
    notifications: { push: true, email: false, inApp: true },
    giftCardDetails: null,
    date: "2026-08-12T12:05:00Z",
    internalNotes: "Awaiting provider payout confirmation.",
    timeline: [
      { step: "Withdrawal Requested", time: "12:05:00 PM", status: "completed" },
      { step: "Compliance Check", time: "12:05:02 PM", status: "completed" },
      { step: "Bank Dispatch", time: "12:05:10 PM", status: "current" }
    ],
    auditLogs: [
      { action: "Request Logged", actor: "User App", timestamp: "2026-08-12 12:05:00" }
    ]
  },
  {
    id: "NC-TX-008495",
    userId: "NC-001209",
    userName: "David Beckham",
    userEmail: "david@example.com",
    userAvatar: "https://i.pravatar.cc/150?img=14",
    userPhone: "+1 408 555 0192",
    category: "Deposits",
    type: "Deposit",
    originalAmount: 500,
    currency: "USDT",
    usdValue: 500.00,
    referenceRate: 1.0,
    appliedRate: 1.0,
    markup: "0%",
    grossAmount: 500.00,
    platformFee: 0.00,
    providerFee: 1.00,
    netAmount: 499.00,
    paymentMethod: "USDT",
    bankName: "TRC20 Network",
    paymentReference: "0x7a9...4b12",
    status: "Successful",
    source: "Web",
    processingType: "Automatic",
    walletBefore: 1200.00,
    walletAfter: 1699.00,
    riskFlag: "Normal",
    reconciliationStatus: "Reconciled",
    reconciliationDiff: 0.00,
    notifications: { push: true, email: true, inApp: true },
    giftCardDetails: null,
    date: "2026-08-11T16:20:00Z",
    internalNotes: "Confirmed after 12 block confirmations.",
    timeline: [
      { step: "Tx Broadcast", time: "04:20:00 PM", status: "completed" },
      { step: "Block Confirmation", time: "04:22:15 PM", status: "completed" },
      { step: "Wallet Credited", time: "04:22:18 PM", status: "completed" }
    ],
    auditLogs: [
      { action: "Blockchain Validated", actor: "TronNode Service", timestamp: "2026-08-11 16:22:15" }
    ]
  },
  {
    id: "NC-TX-008496",
    userId: "NC-005511",
    userName: "Sarah Connor",
    userEmail: "sarah@example.com",
    userAvatar: "https://i.pravatar.cc/150?img=9",
    userPhone: "+44 20 7946 0912",
    category: "Gift Cards",
    type: "Gift Card Purchase",
    originalAmount: 200,
    currency: "EUR",
    usdValue: 218.00,
    referenceRate: 1.09,
    appliedRate: 1.09,
    markup: "0%",
    grossAmount: 218.00,
    platformFee: 6.50,
    providerFee: 0.00,
    netAmount: 211.50,
    paymentMethod: "Gift Card",
    bankName: null,
    paymentReference: "GC-BUY-8812",
    status: "Failed",
    source: "Mobile App",
    processingType: "Automatic",
    walletBefore: 300.00,
    walletAfter: 300.00,
    riskFlag: "High Risk",
    reconciliationStatus: "Reconciled",
    reconciliationDiff: 0.00,
    notifications: { push: true, email: true, inApp: true },
    giftCardDetails: {
      cardName: "Steam Gift Card",
      cardId: "GC-009981",
      country: "Eurozone",
      buyRate: 80,
      sellRate: 88,
      maskedCode: "STM-••••-••••-1102"
    },
    date: "2026-08-11T14:10:00Z",
    internalNotes: "Inventory out of stock during processing.",
    timeline: [
      { step: "Order Created", time: "02:10:00 PM", status: "completed" },
      { step: "Inventory Allocation", time: "02:10:05 PM", status: "failed" }
    ],
    auditLogs: [
      { action: "Order Cancelled", actor: "Inventory Engine", timestamp: "2026-08-11 14:10:05" }
    ]
  },
  {
    id: "NC-TX-008497",
    userId: "NC-007742",
    userName: "Emeka Okafor",
    userEmail: "emeka@example.com",
    userAvatar: "https://i.pravatar.cc/150?img=60",
    userPhone: "+234 818 900 1122",
    category: "Refunds",
    type: "Refund",
    originalAmount: 150,
    currency: "USD",
    usdValue: 150.00,
    referenceRate: 1.0,
    appliedRate: 1.0,
    markup: "0%",
    grossAmount: 150.00,
    platformFee: 0.00,
    providerFee: 0.00,
    netAmount: 150.00,
    paymentMethod: "Card",
    bankName: "Visa •••• 4921",
    paymentReference: "REF-00129",
    status: "Refunded",
    source: "Admin",
    processingType: "Manual",
    walletBefore: 100.00,
    walletAfter: 250.00,
    riskFlag: "Normal",
    reconciliationStatus: "Reconciled",
    reconciliationDiff: 0.00,
    notifications: { push: false, email: true, inApp: true },
    giftCardDetails: null,
    date: "2026-08-10T09:45:00Z",
    internalNotes: "Manual refund authorized due to duplicate card purchase error.",
    timeline: [
      { step: "Refund Initiated", time: "09:45:00 AM", status: "completed" },
      { step: "Admin Approval", time: "09:46:12 AM", status: "completed" },
      { step: "Wallet Recredited", time: "09:46:15 AM", status: "completed" }
    ],
    auditLogs: [
      { action: "Refund Issued", actor: "Admin User", timestamp: "2026-08-10 09:46:12" }
    ]
  },
  {
    id: "NC-TX-008498",
    userId: "NC-008819",
    userName: "Alex Thorne",
    userEmail: "alex@example.com",
    userAvatar: "https://i.pravatar.cc/150?img=33",
    userPhone: "+1 212 555 0188",
    category: "Deposits",
    type: "Deposit",
    originalAmount: 1000,
    currency: "USD",
    usdValue: 1000.00,
    referenceRate: 1.0,
    appliedRate: 1.0,
    markup: "0%",
    grossAmount: 1000.00,
    platformFee: 15.00,
    providerFee: 5.00,
    netAmount: 980.00,
    paymentMethod: "Card",
    bankName: "Mastercard •••• 8812",
    paymentReference: "DEP-883910",
    status: "Chargeback",
    source: "Web",
    processingType: "Automatic",
    walletBefore: 980.00,
    walletAfter: -20.00,
    riskFlag: "High Risk",
    reconciliationStatus: "Mismatch",
    reconciliationDiff: -1000.00,
    notifications: { push: true, email: true, inApp: true },
    giftCardDetails: null,
    date: "2026-08-09T18:30:00Z",
    internalNotes: "Bank flagged unauthorized transaction. Dispute open.",
    timeline: [
      { step: "Deposit Processed", time: "06:30:00 PM", status: "completed" },
      { step: "Dispute Flagged", time: "08:12:00 PM", status: "failed" }
    ],
    auditLogs: [
      { action: "Chargeback Received", actor: "Stripe Webhook", timestamp: "2026-08-09 20:12:00" }
    ]
  }
];

export const summaryMetrics = {
  totalVolumeUSD: 8492382.50,
  todayVolumeUSD: 284520.30,
  successfulUSD: 7982420.10,
  pendingUSD: 82490.20,
  failedUSD: 35200.00,
  revenueUSD: 182492.50
};

export const volumeChartData = [
  { label: "00:00", volume: 12400, revenue: 820 },
  { label: "04:00", volume: 8200, revenue: 510 },
  { label: "08:00", volume: 45100, revenue: 2900 },
  { label: "12:00", volume: 98400, revenue: 6400 },
  { label: "16:00", volume: 72300, revenue: 4800 },
  { label: "20:00", volume: 48120, revenue: 3100 }
];

export const statusDistributionData = [
  { name: "Successful", value: 85, color: "var(--primary-green)" },
  { name: "Pending", value: 8, color: "var(--accent-gold)" },
  { name: "Failed", value: 4, color: "var(--error)" },
  { name: "Cancelled/Refunded", value: 3, color: "var(--blue)" }
];

export const typeDistributionData = [
  { name: "Gift Card Sales", value: 4200 },
  { name: "Deposits", value: 3800 },
  { name: "Withdrawals", value: 2900 },
  { name: "Gift Card Purchases", value: 1500 },
  { name: "Refunds/Fees", value: 400 }
];

export const exportTransactionsToCSV = (data) => {
  const headers = [
    "Transaction ID", "User ID", "User Name", "Email", "Category", "Type",
    "Original Amount", "Currency", "USD Value", "Exchange Rate", "NobleCards Rate",
    "Markup", "Platform Fee", "Provider Fee", "Net Amount", "Payment Method",
    "Status", "Source", "Processing Type", "Gift Card", "Country", "Date"
  ];

  const rows = data.map(t => [
    t.id,
    t.userId,
    `"${t.userName}"`,
    t.userEmail,
    t.category,
    t.type,
    t.originalAmount,
    t.currency,
    t.usdValue,
    t.referenceRate,
    t.appliedRate,
    t.markup,
    t.platformFee,
    t.providerFee,
    t.netAmount,
    `"${t.paymentMethod}"`,
    t.status,
    t.source,
    t.processingType,
    t.giftCardDetails ? `"${t.giftCardDetails.cardName}"` : "N/A",
    t.giftCardDetails ? `"${t.giftCardDetails.country}"` : "N/A",
    t.date
  ]);

  const csvContent = [headers.join(","), ...rows.map(e => e.join(","))].join("\n");
  const blob = new Blob([csvContent], { type: "text/csv;charset=utf-8;" });
  const url = URL.createObjectURL(blob);
  const link = document.createElement("a");
  link.setAttribute("href", url);
  link.setAttribute("download", `NobleCards_Transactions_${new Date().toISOString().split("T")[0]}.csv`);
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
};