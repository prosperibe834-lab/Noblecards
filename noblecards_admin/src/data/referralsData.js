export const initialReferralSettings = {
  programActive: true,
  commissionRate: 1.5, // 1.5%
  minTargetReferrals: 5,
  qualifyingPurchasePercentage: 10, // 10% of deposit
  maxRewardPerReferral: 50.00, // $50 max reward cap
  rewardType: 'Percentage',
  rewardBalanceType: 'Restricted (Gift Card Purchases Only)'
};

export const initialAuditLogs = [
  {
    id: "AUD-991",
    admin: "SuperAdmin (Alex)",
    action: "Updated Commission Rate",
    previousValue: "2.0%",
    newValue: "1.5%",
    reason: "Standard quarterly marketing yield adjustment",
    timestamp: "2026-07-01T10:15:00Z"
  },
  {
    id: "AUD-812",
    admin: "Admin (Sarah)",
    action: "Updated Min Qualifying Purchase",
    previousValue: "5%",
    newValue: "10%",
    reason: "Aligned deposit-to-spend ratio requirements",
    timestamp: "2026-05-14T14:22:00Z"
  }
];

export const mockReferrals = [
  {
    id: "REF-9921",
    referrer: {
      id: "NC-004829",
      name: "Chidubem Okeke",
      username: "@dubem_v",
      email: "chidubem@example.com",
      phone: "+234 803 111 2222",
      country: "Nigeria",
      avatar: "C",
      totalEarned: "$240.50",
      successfulCount: 12
    },
    referredUser: {
      id: "NC-008123",
      name: "Amina Yusuf",
      username: "@amina_y",
      email: "amina@example.com",
      phone: "+234 809 333 4444",
      country: "Nigeria",
      avatar: "A",
      joinedDate: "2026-08-10T12:00:00Z",
      accountStatus: "Active"
    },
    codeUsed: "DUBEM2026",
    depositAmount: 1000.00,
    requiredPurchase: 100.00, // 10% of $1,000
    actualPurchase: 120.00,
    progressPercentage: 120,
    status: "Qualified",
    rewardAmount: 15.00, // 1.5% of $1,000
    rewardStatus: "Paid",
    riskLevel: "Normal",
    riskReasons: [],
    joinedDate: "2026-08-10T12:00:00Z",
    qualifiedDate: "2026-08-11T09:30:00Z",
    rewardDate: "2026-08-11T09:35:00Z",
    timeline: [
      { step: "Referral Link Used", date: "2026-08-10T11:58:00Z", status: "completed" },
      { step: "User Registered", date: "2026-08-10T12:00:00Z", status: "completed" },
      { step: "Phone & Email Verified", date: "2026-08-10T12:05:00Z", status: "completed" },
      { step: "Deposit Completed ($1,000)", date: "2026-08-10T14:10:00Z", status: "completed" },
      { step: "Gift Card Purchase ($120)", date: "2026-08-11T09:25:00Z", status: "completed" },
      { step: "Referral Qualified", date: "2026-08-11T09:30:00Z", status: "completed" },
      { step: "Fraud & Risk Check Passed", date: "2026-08-11T09:32:00Z", status: "completed" },
      { step: "Restricted Reward Credited ($15.00)", date: "2026-08-11T09:35:00Z", status: "completed" }
    ]
  },
  {
    id: "REF-9922",
    referrer: {
      id: "NC-001204",
      name: "Kwame Mensah",
      username: "@kwame_m",
      email: "kwame@example.com",
      phone: "+233 24 555 6666",
      country: "Ghana",
      avatar: "K",
      totalEarned: "$180.00",
      successfulCount: 9
    },
    referredUser: {
      id: "NC-009941",
      name: "Kofi Annan",
      username: "@kofi_a",
      email: "kofi@example.com",
      phone: "+233 20 777 8888",
      country: "Ghana",
      avatar: "K",
      joinedDate: "2026-08-12T08:15:00Z",
      accountStatus: "Active"
    },
    codeUsed: "KWAMEGH",
    depositAmount: 500.00,
    requiredPurchase: 50.00, // 10% of $500
    actualPurchase: 25.00,
    progressPercentage: 50,
    status: "Qualification Pending",
    rewardAmount: 7.50, // 1.5% of $500
    rewardStatus: "Pending",
    riskLevel: "Normal",
    riskReasons: [],
    joinedDate: "2026-08-12T08:15:00Z",
    qualifiedDate: null,
    rewardDate: null,
    timeline: [
      { step: "Referral Link Used", date: "2026-08-12T08:10:00Z", status: "completed" },
      { step: "User Registered", date: "2026-08-12T08:15:00Z", status: "completed" },
      { step: "Phone & Email Verified", date: "2026-08-12T08:20:00Z", status: "completed" },
      { step: "Deposit Completed ($500)", date: "2026-08-12T10:00:00Z", status: "completed" },
      { step: "Gift Card Purchase ($25 / $50 req)", date: "2026-08-12T11:00:00Z", status: "active" },
      { step: "Referral Qualification", date: null, status: "pending" },
      { step: "Fraud & Risk Check", date: null, status: "pending" },
      { step: "Reward Credited", date: null, status: "pending" }
    ]
  },
  {
    id: "REF-9923",
    referrer: {
      id: "NC-003310",
      name: "David Smith",
      username: "@davesmith",
      email: "dave@example.com",
      phone: "+1 555 019 2831",
      country: "United States",
      avatar: "D",
      totalEarned: "$50.00",
      successfulCount: 2
    },
    referredUser: {
      id: "NC-007782",
      name: "David Smith Jr.",
      username: "@davesmith2",
      email: "dave2@example.com",
      phone: "+1 555 019 2831",
      country: "United States",
      avatar: "D",
      joinedDate: "2026-08-13T02:10:00Z",
      accountStatus: "Under Review"
    },
    codeUsed: "DAVENOW",
    depositAmount: 2000.00,
    requiredPurchase: 200.00,
    actualPurchase: 250.00,
    progressPercentage: 125,
    status: "Suspicious",
    rewardAmount: 30.00,
    rewardStatus: "Held",
    riskLevel: "High Risk",
    riskReasons: ["Same IP Address Detected", "Same Phone Number Detected", "Multiple Accounts on Single Device"],
    joinedDate: "2026-08-13T02:10:00Z",
    qualifiedDate: "2026-08-13T03:00:00Z",
    rewardDate: null,
    timeline: [
      { step: "Referral Link Used", date: "2026-08-13T02:08:00Z", status: "completed" },
      { step: "User Registered", date: "2026-08-13T02:10:00Z", status: "completed" },
      { step: "Deposit Completed ($2,000)", date: "2026-08-13T02:30:00Z", status: "completed" },
      { step: "Gift Card Purchase ($250)", date: "2026-08-13T03:00:00Z", status: "completed" },
      { step: "Referral Qualified", date: "2026-08-13T03:00:00Z", status: "completed" },
      { step: "Fraud & Risk Check Failed", date: "2026-08-13T03:01:00Z", status: "failed" },
      { step: "Reward Placed on Hold", date: "2026-08-13T03:01:00Z", status: "held" }
    ]
  },
  {
    id: "REF-9924",
    referrer: {
      id: "NC-005512",
      name: "Blessing Egbe",
      username: "@blessing_e",
      email: "blessing@example.com",
      phone: "+234 812 888 9999",
      country: "Nigeria",
      avatar: "B",
      totalEarned: "$320.00",
      successfulCount: 16
    },
    referredUser: {
      id: "NC-006611",
      name: "Emeka Egbe",
      username: "@emeka_e",
      email: "emeka@example.com",
      phone: "+234 812 000 1111",
      country: "Nigeria",
      avatar: "E",
      joinedDate: "2026-08-01T15:00:00Z",
      accountStatus: "Active"
    },
    codeUsed: "BLESSINGVIP",
    depositAmount: 800.00,
    requiredPurchase: 80.00,
    actualPurchase: 0.00,
    progressPercentage: 0,
    status: "Deposit Pending",
    rewardAmount: 12.00,
    rewardStatus: "Pending",
    riskLevel: "Normal",
    riskReasons: [],
    joinedDate: "2026-08-01T15:00:00Z",
    qualifiedDate: null,
    rewardDate: null,
    timeline: [
      { step: "Referral Link Used", date: "2026-08-01T14:55:00Z", status: "completed" },
      { step: "User Registered", date: "2026-08-01T15:00:00Z", status: "completed" },
      { step: "Deposit Requirement ($800)", date: null, status: "active" },
      { step: "Gift Card Purchase", date: null, status: "pending" },
      { step: "Reward Credited", date: null, status: "pending" }
    ]
  }
];

export const mockTopReferrers = [
  { rank: 1, id: "NC-004829", name: "Chidubem Okeke", avatar: "C", country: "Nigeria", successfulReferrals: 248, totalEarned: "$1,240.00" },
  { rank: 2, id: "NC-005512", name: "Blessing Egbe", avatar: "B", country: "Nigeria", successfulReferrals: 194, totalEarned: "$970.00" },
  { rank: 3, id: "NC-001204", name: "Kwame Mensah", avatar: "K", country: "Ghana", successfulReferrals: 161, totalEarned: "$805.00" },
  { rank: 4, id: "NC-008821", name: "Sophia Martinez", avatar: "S", country: "United States", successfulReferrals: 120, totalEarned: "$600.00" },
  { rank: 5, id: "NC-003310", name: "David Smith", avatar: "D", country: "United States", successfulReferrals: 98, totalEarned: "$490.00" }
];