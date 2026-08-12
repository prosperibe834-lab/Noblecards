export const initialDeposits = [
  {
    id: "NC-DP-004829",
    userId: "NC-004829",
    userName: "Chidi Emmanuel",
    userTag: "@chidi_dev",
    email: "chidi.emmanuel@example.com",
    phone: "+234 803 123 4567",
    avatar: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80",
    originalAmount: 500000,
    currency: "NGN",
    usdValue: 325.73,
    exchangeRate: 1535,
    nobleRate: 1535,
    markup: 15,
    fee: 3.25,
    providerFee: 1.50,
    netAmount: 320.98,
    method: "Bank Transfer",
    provider: "GTBank",
    providerRef: "GTB-TXN-9948201",
    paymentRef: "PAY-NGN-8829102",
    bankDetails: {
      bankName: "Guaranty Trust Bank",
      accountName: "NobleCards Financial / Chidi Emmanuel",
      maskedAccount: "••••4921"
    },
    status: "Completed",
    reconciliation: {
      providerAmount: 325.73,
      ledgerAmount: 325.73,
      difference: 0,
      status: "Reconciled"
    },
    walletSnapshot: {
      balanceBefore: 950.00,
      depositAmount: 320.98,
      balanceAfter: 1270.98
    },
    createdAt: "2026-08-12T14:22:00Z",
    updatedAt: "2026-08-12T14:23:15Z",
    completedAt: "2026-08-12T14:23:15Z",
    timeline: [
      { step: "Deposit Request Created", time: "14:22:00", completed: true },
      { step: "Payment Initiated", time: "14:22:10", completed: true },
      { step: "Provider Webhook Received", time: "14:23:00", completed: true },
      { step: "Webhook Signature Verified", time: "14:23:05", completed: true },
      { step: "Wallet Ledger Credited", time: "14:23:15", completed: true }
    ],
    auditTrail: [
      { event: "Created", description: "Deposit initiated via GTBank Transfer", time: "2026-08-12 14:22:00", actor: "User" },
      { event: "Webhook Verified", description: "HMAC signature matched GTBank payload", time: "2026-08-12 14:23:05", actor: "System Webhook" },
      { event: "Completed", description: "Credited $320.98 USD to user wallet", time: "2026-08-12 14:23:15", actor: "System Ledger" }
    ]
  },
  {
    id: "NC-DP-004828",
    userId: "NC-001928",
    userName: "Monica Anya",
    userTag: "@monica_a",
    email: "monica.a@example.com",
    phone: "+234 812 987 6543",
    avatar: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80",
    originalAmount: 500,
    currency: "USDT",
    usdValue: 500.00,
    exchangeRate: 1.00,
    nobleRate: 1.00,
    markup: 0,
    fee: 5.00,
    providerFee: 2.00,
    netAmount: 493.00,
    method: "Crypto",
    provider: "Tron Network (TRC20)",
    providerRef: "0x7a8f89c2b1e4a3d...98e2",
    paymentRef: "PAY-USDT-991823",
    cryptoDetails: {
      asset: "USDT",
      network: "TRC20",
      walletAddress: "TYu89a...K92lxP",
      txHash: "0x7a8f89c2b1e4a3d891c02e482910398e2"
    },
    status: "Pending",
    reconciliation: {
      providerAmount: 500.00,
      ledgerAmount: 0,
      difference: 500.00,
      status: "Mismatch"
    },
    walletSnapshot: {
      balanceBefore: 120.00,
      depositAmount: 493.00,
      balanceAfter: 120.00
    },
    createdAt: "2026-08-12T13:45:00Z",
    updatedAt: "2026-08-12T13:45:00Z",
    completedAt: null,
    timeline: [
      { step: "Deposit Request Created", time: "13:45:00", completed: true },
      { step: "Awaiting Blockchain Confirmations", time: "In Progress", completed: false },
      { step: "Wallet Ledger Credited", time: "Pending", completed: false }
    ],
    auditTrail: [
      { event: "Created", description: "Generated deposit TRC20 address", time: "2026-08-12 13:45:00", actor: "User" }
    ]
  },
  {
    id: "NC-DP-004827",
    userId: "NC-007211",
    userName: "David Olatunji",
    userTag: "@dave_ola",
    email: "david.o@example.com",
    phone: "+234 705 443 2109",
    avatar: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80",
    originalAmount: 250,
    currency: "EUR",
    usdValue: 272.50,
    exchangeRate: 1.09,
    nobleRate: 1.09,
    markup: 0.02,
    fee: 2.72,
    providerFee: 1.20,
    netAmount: 268.58,
    method: "Card",
    provider: "Stripe",
    providerRef: "ch_3N8xY2Lkd901Klz0192",
    paymentRef: "PAY-EUR-773821",
    cardDetails: {
      brand: "Mastercard",
      maskedCard: "•••• 8821",
      expDate: "12/28"
    },
    status: "Completed",
    reconciliation: {
      providerAmount: 272.50,
      ledgerAmount: 272.50,
      difference: 0,
      status: "Reconciled"
    },
    walletSnapshot: {
      balanceBefore: 45.00,
      depositAmount: 268.58,
      balanceAfter: 313.58
    },
    createdAt: "2026-08-12T11:10:00Z",
    updatedAt: "2026-08-12T11:11:02Z",
    completedAt: "2026-08-12T11:11:02Z",
    timeline: [
      { step: "Deposit Request Created", time: "11:10:00", completed: true },
      { step: "Stripe Charge Authorized", time: "11:10:45", completed: true },
      { step: "Wallet Ledger Credited", time: "11:11:02", completed: true }
    ],
    auditTrail: [
      { event: "Created", description: "Card intent initialized", time: "2026-08-12 11:10:00", actor: "User" },
      { event: "Completed", description: "Stripe 3D Secure passed", time: "2026-08-12 11:11:02", actor: "System" }
    ]
  },
  {
    id: "NC-DP-004826",
    userId: "NC-003419",
    userName: "Amina Yusuf",
    userTag: "@amina_y",
    email: "amina.yusuf@example.com",
    phone: "+234 802 334 1122",
    avatar: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150&auto=format&fit=crop&q=80",
    originalAmount: 150000,
    currency: "NGN",
    usdValue: 97.71,
    exchangeRate: 1535,
    nobleRate: 1535,
    markup: 15,
    fee: 1.50,
    providerFee: 0.80,
    netAmount: 95.41,
    method: "Bank Transfer",
    provider: "Flutterwave",
    providerRef: "FLW-88392019",
    paymentRef: "PAY-NGN-001928",
    bankDetails: {
      bankName: "Access Bank",
      accountName: "NobleCards / Amina Yusuf",
      maskedAccount: "•••• 3102"
    },
    status: "Failed",
    reconciliation: {
      providerAmount: 0,
      ledgerAmount: 0,
      difference: 0,
      status: "Reconciled"
    },
    walletSnapshot: {
      balanceBefore: 300.00,
      depositAmount: 0,
      balanceAfter: 300.00
    },
    createdAt: "2026-08-12T09:30:00Z",
    updatedAt: "2026-08-12T09:35:00Z",
    completedAt: null,
    failureReason: "Insufficient funds / Transaction declined by issuing bank",
    timeline: [
      { step: "Deposit Request Created", time: "09:30:00", completed: true },
      { step: "Bank Auth Failed", time: "09:35:00", completed: true, failed: true }
    ],
    auditTrail: [
      { event: "Failed", description: "Issuing bank responded with 51: Insufficient Funds", time: "2026-08-12 09:35:00", actor: "Flutterwave Webhook" }
    ]
  },
  {
    id: "NC-DP-004825",
    userId: "NC-009102",
    userName: "Victor Kalu",
    userTag: "@vkalu",
    email: "victor.k@example.com",
    phone: "+234 818 000 9988",
    avatar: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&auto=format&fit=crop&q=80",
    originalAmount: 1200,
    currency: "USD",
    usdValue: 1200.00,
    exchangeRate: 1.00,
    nobleRate: 1.00,
    markup: 0,
    fee: 12.00,
    providerFee: 4.50,
    netAmount: 1183.50,
    method: "Card",
    provider: "Paystack",
    providerRef: "PST-99201928",
    paymentRef: "PAY-USD-554123",
    cardDetails: {
      brand: "Visa",
      maskedCard: "•••• 1102",
      expDate: "05/27"
    },
    status: "Processing",
    reconciliation: {
      providerAmount: 1200.00,
      ledgerAmount: 0,
      difference: 1200.00,
      status: "Mismatch"
    },
    walletSnapshot: {
      balanceBefore: 80.00,
      depositAmount: 0,
      balanceAfter: 80.00
    },
    createdAt: "2026-08-12T15:05:00Z",
    updatedAt: "2026-08-12T15:05:00Z",
    completedAt: null,
    timeline: [
      { step: "Deposit Request Created", time: "15:05:00", completed: true },
      { step: "Awaiting Provider Settlement Confirmation", time: "In Progress", completed: false }
    ],
    auditTrail: [
      { event: "Processing", description: "Awaiting Paystack webhook callback", time: "2026-08-12 15:05:00", actor: "Paystack SDK" }
    ]
  },
  {
    id: "NC-DP-004824",
    userId: "NC-001004",
    userName: "Grace Edet",
    userTag: "@grace_e",
    email: "grace.edet@example.com",
    phone: "+234 901 223 3445",
    avatar: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&auto=format&fit=crop&q=80",
    originalAmount: 150,
    currency: "GBP",
    usdValue: 190.50,
    exchangeRate: 1.27,
    nobleRate: 1.27,
    markup: 0,
    fee: 1.90,
    providerFee: 0.90,
    netAmount: 187.70,
    method: "Payment Providers",
    provider: "Wise",
    providerRef: "WISE-7718293",
    paymentRef: "PAY-GBP-110293",
    status: "Cancelled",
    reconciliation: {
      providerAmount: 0,
      ledgerAmount: 0,
      difference: 0,
      status: "Reconciled"
    },
    walletSnapshot: {
      balanceBefore: 500.00,
      depositAmount: 0,
      balanceAfter: 500.00
    },
    createdAt: "2026-08-11T16:20:00Z",
    updatedAt: "2026-08-11T16:35:00Z",
    completedAt: null,
    timeline: [
      { step: "Deposit Request Created", time: "16:20:00", completed: true },
      { step: "Cancelled by User", time: "16:35:00", completed: true, failed: true }
    ],
    auditTrail: [
      { event: "Cancelled", description: "Deposit session expired/cancelled by user", time: "2026-08-11 16:35:00", actor: "User" }
    ]
  },
  {
    id: "NC-DP-004823",
    userId: "NC-008291",
    userName: "Emeka Nwosu",
    userTag: "@emeka_nw",
    email: "emeka.nwosu@example.com",
    phone: "+234 813 445 6677",
    avatar: "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=150&auto=format&fit=crop&q=80",
    originalAmount: 800000,
    currency: "NGN",
    usdValue: 521.17,
    exchangeRate: 1535,
    nobleRate: 1535,
    markup: 15,
    fee: 5.21,
    providerFee: 2.10,
    netAmount: 513.86,
    method: "Bank Transfer",
    provider: "Zenith Bank",
    providerRef: "ZBN-992019",
    paymentRef: "PAY-NGN-773812",
    bankDetails: {
      bankName: "Zenith Bank",
      accountName: "NobleCards / Emeka Nwosu",
      maskedAccount: "•••• 9012"
    },
    status: "Reversed",
    reconciliation: {
      providerAmount: 521.17,
      ledgerAmount: 0,
      difference: 0,
      status: "Reconciled"
    },
    walletSnapshot: {
      balanceBefore: 513.86,
      depositAmount: -513.86,
      balanceAfter: 0.00
    },
    createdAt: "2026-08-10T10:15:00Z",
    updatedAt: "2026-08-10T14:00:00Z",
    completedAt: "2026-08-10T10:16:00Z",
    timeline: [
      { step: "Deposit Request Created", time: "10:15:00", completed: true },
      { step: "Wallet Credited", time: "10:16:00", completed: true },
      { step: "Bank Chargeback / Reversal", time: "14:00:00", completed: true, failed: true }
    ],
    auditTrail: [
      { event: "Completed", description: "Deposit credited automatically", time: "2026-08-10 10:16:00", actor: "System" },
      { event: "Reversed", description: "Zenith Bank reported fraudulent claim. Funds clawed back.", time: "2026-08-10 14:00:00", actor: "Admin: Sarah Jenkins" }
    ]
  }
];

export const depositStatsSummary = {
  totalDepositsVolume: 8492382.50,
  todaysDepositsVolume: 284520.30,
  pendingDepositsVolume: 82490.20,
  processingDepositsVolume: 42100.00,
  completedDepositsVolume: 7982420.10,
  failedDepositsVolume: 35200.00,
  nobleRevenueFees: 84923.82, // ~1% revenue from rate markups & fees
  needsAttentionCount: 3
};

export const depositChartData = {
  volumeOverTime: [
    { date: "Aug 06", volume: 320000, count: 180 },
    { date: "Aug 07", volume: 410000, count: 210 },
    { date: "Aug 08", volume: 290000, count: 165 },
    { date: "Aug 09", volume: 530000, count: 280 },
    { date: "Aug 10", volume: 480000, count: 240 },
    { date: "Aug 11", volume: 620000, count: 310 },
    { date: "Aug 12", volume: 284520, count: 142 }
  ],
  statusBreakdown: [
    { name: "Completed", value: 7982420.10, color: "var(--success-color, #10b981)" },
    { name: "Pending", value: 82490.20, color: "var(--warning-color, #f59e0b)" },
    { name: "Processing", value: 42100.00, color: "var(--info-color, #3b82f6)" },
    { name: "Failed", value: 35200.00, color: "var(--danger-color, #ef4444)" }
  ],
  methodBreakdown: [
    { method: "Bank Transfer", amount: 4850000 },
    { method: "Crypto / USDT", amount: 2100000 },
    { method: "Card", amount: 1120000 },
    { method: "Providers", amount: 422382.50 }
  ]
};