export const initialWithdrawalData = [
  {
    id: "NC-WD-008492",
    userId: "NC-004829",
    userName: "Chidi Eze",
    userEmail: "chidi.eze@example.com",
    userPhone: "+234 803 123 4567",
    username: "@chidieze",
    avatar: "https://i.pravatar.cc/150?u=NC-004829",
    originalAmount: 500000,
    currency: "NGN",
    usdValue: 325.73,
    referenceRate: 1520,
    nobleCardsRate: 1535,
    rateMarkup: "1.0%",
    grossAmountUsd: 325.73,
    nobleCardsFee: 3.25,
    providerFee: 1.50,
    netAmountUsd: 320.98,
    method: "Bank Transfer",
    provider: "Paystack",
    providerReference: "PST-849201-NGN",
    destination: {
      bankName: "GTBank",
      accountHolder: "Chidi Eze",
      accountNumber: "•••• 4921",
    },
    status: "Pending",
    risk: "Review",
    riskReason: "Unusually large withdrawal for user profile",
    date: "2026-08-12T10:30:00Z",
    updatedDate: "2026-08-12T10:30:00Z",
    completedDate: null,
    walletBefore: 1250.00,
    walletAfter: 924.27,
    reconciliation: {
      providerAmount: 325.73,
      ledgerAmount: 325.73,
      difference: 0.00,
      status: "Reconciled"
    },
    timeline: [
      { status: "Withdrawal Created", time: "10:30 AM", date: "Aug 12, 2026", source: "User App" },
      { status: "Security Verification Pass", time: "10:31 AM", date: "Aug 12, 2026", source: "System Rules" },
      { status: "Flagged for Admin Review", time: "10:31 AM", date: "Aug 12, 2026", source: "Risk Engine" }
    ],
    auditTrail: [
      { event: "Withdrawal Request Received", timestamp: "2026-08-12T10:30:00Z", actor: "User" },
      { event: "High Volume Threshold Flag", timestamp: "2026-08-12T10:31:00Z", actor: "System Guard" }
    ]
  },
  {
    id: "NC-WD-001928",
    userId: "NC-009182",
    userName: "Sarah Jenkins",
    userEmail: "s.jenkins@example.com",
    userPhone: "+1 415 555 0192",
    username: "@sarahj",
    avatar: "https://i.pravatar.cc/150?u=NC-009182",
    originalAmount: 1500,
    currency: "USDT",
    usdValue: 1500.00,
    referenceRate: 1.00,
    nobleCardsRate: 1.00,
    rateMarkup: "0.0%",
    grossAmountUsd: 1500.00,
    nobleCardsFee: 7.50,
    providerFee: 2.50,
    netAmountUsd: 1490.00,
    method: "USDT",
    provider: "Binance Pay",
    providerReference: "TX-USDT-99182931",
    destination: {
      asset: "USDT",
      network: "TRC20",
      walletAddress: "TYx2r8...8291PqL",
      txHash: "0x7a8f...99bc12"
    },
    status: "Completed",
    risk: "Normal",
    riskReason: "Standard operational parameters",
    date: "2026-08-12T09:15:00Z",
    updatedDate: "2026-08-12T09:18:00Z",
    completedDate: "2026-08-12T09:18:00Z",
    walletBefore: 3000.00,
    walletAfter: 1500.00,
    reconciliation: {
      providerAmount: 1500.00,
      ledgerAmount: 1500.00,
      difference: 0.00,
      status: "Reconciled"
    },
    timeline: [
      { status: "Withdrawal Created", time: "09:15 AM", date: "Aug 12, 2026", source: "User App" },
      { status: "Security Verification Pass", time: "09:15 AM", date: "Aug 12, 2026", source: "System Rules" },
      { status: "Provider Processing", time: "09:16 AM", date: "Aug 12, 2026", source: "Binance API" },
      { status: "Wallet Ledger Updated", time: "09:18 AM", date: "Aug 12, 2026", source: "Laravel Webhook" },
      { status: "Completed", time: "09:18 AM", date: "Aug 12, 2026", source: "System" }
    ],
    auditTrail: [
      { event: "Created", timestamp: "2026-08-12T09:15:00Z", actor: "User" },
      { event: "Dispatched to Binance API", timestamp: "2026-08-12T09:16:00Z", actor: "System" },
      { event: "Webhook Confirmed Success", timestamp: "2026-08-12T09:18:00Z", actor: "Binance" }
    ]
  },
  {
    id: "NC-WD-004821",
    userId: "NC-002193",
    userName: "Michael Chen",
    userEmail: "m.chen@example.com",
    userPhone: "+44 20 7946 0912",
    username: "@mchen_dev",
    avatar: "https://i.pravatar.cc/150?u=NC-002193",
    originalAmount: 2500,
    currency: "EUR",
    usdValue: 2750.20,
    referenceRate: 1.08,
    nobleCardsRate: 1.10,
    rateMarkup: "1.8%",
    grossAmountUsd: 2750.20,
    nobleCardsFee: 27.50,
    providerFee: 8.00,
    netAmountUsd: 2714.70,
    method: "Card",
    provider: "Checkout.com",
    providerReference: "CHK-ERR-90821",
    destination: {
      cardBrand: "Visa",
      cardNumber: "•••• 8829",
      expDate: "11/28"
    },
    status: "Failed",
    risk: "High Risk",
    riskReason: "Provider returned card decline code: 51 Insufficient Funds in Clearing Pool",
    date: "2026-08-11T16:45:00Z",
    updatedDate: "2026-08-11T16:47:00Z",
    completedDate: null,
    walletBefore: 5000.00,
    walletAfter: 5000.00,
    reconciliation: {
      providerAmount: 0.00,
      ledgerAmount: 2750.20,
      difference: 2750.20,
      status: "Mismatch"
    },
    timeline: [
      { status: "Withdrawal Created", time: "04:45 PM", date: "Aug 11, 2026", source: "User App" },
      { status: "Provider Processing", time: "04:46 PM", date: "Aug 11, 2026", source: "Checkout.com" },
      { status: "Provider Rejected", time: "04:47 PM", date: "Aug 11, 2026", source: "Checkout.com Webhook" },
      { status: "Funds Unlocked", time: "04:47 PM", date: "Aug 11, 2026", source: "Ledger Rollback" }
    ],
    auditTrail: [
      { event: "Withdrawal Created", timestamp: "2026-08-11T16:45:00Z", actor: "User" },
      { event: "API Error Response Received", timestamp: "2026-08-11T16:47:00Z", actor: "Checkout.com" }
    ]
  },
  {
    id: "NC-WD-009472",
    userId: "NC-007712",
    userName: "Aisha Bello",
    userEmail: "aisha.bello@example.com",
    userPhone: "+234 812 987 6543",
    username: "@aishab",
    avatar: "https://i.pravatar.cc/150?u=NC-007712",
    originalAmount: 120000,
    currency: "NGN",
    usdValue: 78.17,
    referenceRate: 1520,
    nobleCardsRate: 1535,
    rateMarkup: "1.0%",
    grossAmountUsd: 78.17,
    nobleCardsFee: 1.00,
    providerFee: 0.35,
    netAmountUsd: 76.82,
    method: "Bank Transfer",
    provider: "Flutterwave",
    providerReference: "FLW-NGN-99210",
    destination: {
      bankName: "Access Bank",
      accountHolder: "Aisha Bello",
      accountNumber: "•••• 6543"
    },
    status: "Processing",
    risk: "Normal",
    riskReason: "Standard payout batch",
    date: "2026-08-12T13:10:00Z",
    updatedDate: "2026-08-12T13:12:00Z",
    completedDate: null,
    walletBefore: 400.00,
    walletAfter: 321.83,
    reconciliation: {
      providerAmount: 78.17,
      ledgerAmount: 78.17,
      difference: 0.00,
      status: "Reconciled"
    },
    timeline: [
      { status: "Withdrawal Created", time: "01:10 PM", date: "Aug 12, 2026", source: "User App" },
      { status: "Sent to Flutterwave", time: "01:12 PM", date: "Aug 12, 2026", source: "System" }
    ],
    auditTrail: [
      { event: "Request Received", timestamp: "2026-08-12T13:10:00Z", actor: "User" },
      { event: "Dispatched to Provider API", timestamp: "2026-08-12T13:12:00Z", actor: "System" }
    ]
  },
  {
    id: "NC-WD-005112",
    userId: "NC-003319",
    userName: "David O'Connor",
    userEmail: "d.oconnor@example.com",
    userPhone: "+353 87 123 4567",
    username: "@doconnor",
    avatar: "https://i.pravatar.cc/150?u=NC-003319",
    originalAmount: 850,
    currency: "GBP",
    usdValue: 1088.00,
    referenceRate: 1.26,
    nobleCardsRate: 1.28,
    rateMarkup: "1.5%",
    grossAmountUsd: 1088.00,
    nobleCardsFee: 10.88,
    providerFee: 3.50,
    netAmountUsd: 1073.62,
    method: "Wise",
    provider: "Wise Business",
    providerReference: "WISE-UK-881920",
    destination: {
      accountHolder: "David O'Connor",
      sortCode: "40-02-11",
      accountNumber: "•••• 9102"
    },
    status: "Cancelled",
    risk: "Normal",
    riskReason: "User cancelled request prior to execution",
    date: "2026-08-10T11:20:00Z",
    updatedDate: "2026-08-10T11:25:00Z",
    completedDate: null,
    walletBefore: 1500.00,
    walletAfter: 1500.00,
    reconciliation: {
      providerAmount: 0.00,
      ledgerAmount: 0.00,
      difference: 0.00,
      status: "Reconciled"
    },
    timeline: [
      { status: "Withdrawal Created", time: "11:20 AM", date: "Aug 10, 2026", source: "User App" },
      { status: "User Cancelled", time: "11:25 AM", date: "Aug 10, 2026", source: "User App" }
    ],
    auditTrail: [
      { event: "Withdrawal Created", timestamp: "2026-08-10T11:20:00Z", actor: "User" },
      { event: "Cancellation Initiated", timestamp: "2026-08-10T11:25:00Z", actor: "User" }
    ]
  },
  {
    id: "NC-WD-003194",
    userId: "NC-008221",
    userName: "Emmanuel Nnamdi",
    userEmail: "e.nnamdi@example.com",
    userPhone: "+234 701 112 2334",
    username: "@nnamdie",
    avatar: "https://i.pravatar.cc/150?u=NC-008221",
    originalAmount: 2500000,
    currency: "NGN",
    usdValue: 1628.66,
    referenceRate: 1520,
    nobleCardsRate: 1535,
    rateMarkup: "1.0%",
    grossAmountUsd: 1628.66,
    nobleCardsFee: 16.28,
    providerFee: 4.50,
    netAmountUsd: 1607.88,
    method: "Bank Transfer",
    provider: "Paystack",
    providerReference: "PST-REJ-00129",
    destination: {
      bankName: "Zenith Bank",
      accountHolder: "Emmanuel Nnamdi",
      accountNumber: "•••• 1109"
    },
    status: "Rejected",
    risk: "High Risk",
    riskReason: "Account holder name mismatch with verified KYC documentation",
    date: "2026-08-09T14:00:00Z",
    updatedDate: "2026-08-09T14:30:00Z",
    completedDate: null,
    walletBefore: 2000.00,
    walletAfter: 2000.00,
    reconciliation: {
      providerAmount: 0.00,
      ledgerAmount: 0.00,
      difference: 0.00,
      status: "Reconciled"
    },
    timeline: [
      { status: "Withdrawal Created", time: "02:00 PM", date: "Aug 09, 2026", source: "User App" },
      { status: "Compliance Review Flagged", time: "02:05 PM", date: "Aug 09, 2026", source: "Compliance Engine" },
      { status: "Admin Rejected", time: "02:30 PM", date: "Aug 09, 2026", source: "Admin (Compliance Officer)" }
    ],
    auditTrail: [
      { event: "Created", timestamp: "2026-08-09T14:00:00Z", actor: "User" },
      { event: "Rejected by Admin - Name Mismatch", timestamp: "2026-08-09T14:30:00Z", actor: "Admin" }
    ]
  },
  {
    id: "NC-WD-007182",
    userId: "NC-005521",
    userName: "Elena Rostova",
    userEmail: "elena.r@example.com",
    userPhone: "+49 30 123456",
    username: "@elena_r",
    avatar: "https://i.pravatar.cc/150?u=NC-005521",
    originalAmount: 400,
    currency: "PayPal",
    usdValue: 400.00,
    referenceRate: 1.00,
    nobleCardsRate: 1.00,
    rateMarkup: "0.0%",
    grossAmountUsd: 400.00,
    nobleCardsFee: 8.00,
    providerFee: 2.00,
    netAmountUsd: 390.00,
    method: "PayPal",
    provider: "PayPal Payouts",
    providerReference: "PP-PAYOUT-90218",
    destination: {
      paypalEmail: "el***@example.com"
    },
    status: "Reversed",
    risk: "Review",
    riskReason: "Destination PayPal account unconfirmed by provider",
    date: "2026-08-08T08:10:00Z",
    updatedDate: "2026-08-08T10:15:00Z",
    completedDate: null,
    walletBefore: 800.00,
    walletAfter: 800.00,
    reconciliation: {
      providerAmount: 0.00,
      ledgerAmount: 400.00,
      difference: 400.00,
      status: "Mismatch"
    },
    timeline: [
      { status: "Withdrawal Created", time: "08:10 AM", date: "Aug 08, 2026", source: "User App" },
      { status: "Provider Processing", time: "08:11 AM", date: "Aug 08, 2026", source: "PayPal API" },
      { status: "Reversal Received", time: "10:15 AM", date: "Aug 08, 2026", source: "PayPal Webhook" }
    ],
    auditTrail: [
      { event: "Created", timestamp: "2026-08-08T08:10:00Z", actor: "User" },
      { event: "PayPal Reversal Webhook Triggered", timestamp: "2026-08-08T10:15:00Z", actor: "PayPal" }
    ]
  }
];