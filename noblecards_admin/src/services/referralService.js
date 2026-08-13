import { mockReferrals, initialReferralSettings, initialAuditLogs, mockTopReferrers } from '../data/referralsData';

let currentSettings = { ...initialReferralSettings };
let currentAuditLogs = [...initialAuditLogs];
let referralsList = [...mockReferrals];

export const referralService = {
  // Fetch Referral Data with Filters
  getReferrals: async ({ search, status, country, rewardStatus, dateRange, customStart, customEnd, page = 1, limit = 10 }) => {
    return new Promise((resolve) => {
      setTimeout(() => {
        let filtered = [...referralsList];

        // Search Filter
        if (search) {
          const query = search.toLowerCase().trim();
          filtered = filtered.filter(item => 
            item.referrer.name.toLowerCase().includes(query) ||
            item.referrer.username.toLowerCase().includes(query) ||
            item.referrer.id.toLowerCase().includes(query) ||
            item.referredUser.name.toLowerCase().includes(query) ||
            item.referredUser.username.toLowerCase().includes(query) ||
            item.referredUser.id.toLowerCase().includes(query) ||
            item.codeUsed.toLowerCase().includes(query)
          );
        }

        // Status Filter
        if (status && status !== 'All') {
          filtered = filtered.filter(item => item.status === status);
        }

        // Country Filter
        if (country && country !== 'All') {
          filtered = filtered.filter(item => item.referrer.country === country || item.referredUser.country === country);
        }

        // Reward Status Filter
        if (rewardStatus && rewardStatus !== 'All') {
          filtered = filtered.filter(item => item.rewardStatus === rewardStatus);
        }

        // Date Range Filtering
        if (dateRange && dateRange !== 'All Time') {
          const now = new Date();
          let startDate = new Date();

          if (dateRange === 'Today') {
            startDate.setHours(0,0,0,0);
          } else if (dateRange === 'Yesterday') {
            startDate.setDate(now.getDate() - 1);
            startDate.setHours(0,0,0,0);
          } else if (dateRange === 'Last 7 Days') {
            startDate.setDate(now.getDate() - 7);
          } else if (dateRange === 'Last 30 Days') {
            startDate.setDate(now.getDate() - 30);
          } else if (dateRange === 'Custom' && customStart && customEnd) {
            const cStart = new Date(customStart);
            const cEnd = new Date(customEnd);
            cEnd.setHours(23,59,59,999);
            filtered = filtered.filter(item => {
              const itemDate = new Date(item.joinedDate);
              return itemDate >= cStart && itemDate <= cEnd;
            });
          }

          if (dateRange !== 'Custom') {
            filtered = filtered.filter(item => new Date(item.joinedDate) >= startDate);
          }
        }

        // Pagination
        const totalItems = filtered.length;
        const totalPages = Math.ceil(totalItems / limit) || 1;
        const startIndex = (page - 1) * limit;
        const paginatedData = filtered.slice(startIndex, startIndex + limit);

        // Calculate summary statistics based on current dataset
        const totalReferrals = filtered.length;
        const successfulReferrals = filtered.filter(r => r.status === 'Qualified').length;
        const pendingReferrals = filtered.filter(r => r.status.includes('Pending')).length;
        const suspiciousReferrals = filtered.filter(r => r.riskLevel === 'High Risk' || r.status === 'Suspicious').length;
        const totalRewardsPaid = filtered.filter(r => r.rewardStatus === 'Paid').reduce((sum, r) => sum + r.rewardAmount, 0);
        const pendingRewards = filtered.filter(r => r.rewardStatus === 'Pending').reduce((sum, r) => sum + r.rewardAmount, 0);
        const activeReferrers = new Set(filtered.map(r => r.referrer.id)).size;
        const conversionRate = totalReferrals > 0 ? ((successfulReferrals / totalReferrals) * 100).toFixed(1) : "0.0";

        resolve({
          data: paginatedData,
          pagination: { totalItems, totalPages, currentPage: page, limit },
          summary: {
            totalReferrals,
            successfulReferrals,
            pendingReferrals,
            activeReferrers,
            totalRewardsPaid: `$${totalRewardsPaid.toFixed(2)}`,
            pendingRewards: `$${pendingRewards.toFixed(2)}`,
            conversionRate: `${conversionRate}%`,
            suspiciousReferrals
          }
        });
      }, 500);
    });
  },

  // Get Settings & Audit Logs
  getSettings: async () => {
    return new Promise((resolve) => {
      setTimeout(() => {
        resolve({
          settings: currentSettings,
          auditLogs: currentAuditLogs,
          topReferrers: mockTopReferrers
        });
      }, 300);
    });
  },

  // Update Commission Rate (2-Step Modal confirmation handler)
  updateCommissionRate: async (newRate, reason, adminName = "Admin") => {
    return new Promise((resolve) => {
      setTimeout(() => {
        const oldRate = `${currentSettings.commissionRate}%`;
        currentSettings.commissionRate = parseFloat(newRate);
        
        // Add entry to financial audit log
        const newAuditLog = {
          id: `AUD-${Math.floor(100 + Math.random() * 900)}`,
          admin: adminName,
          action: "Updated Commission Rate",
          previousValue: oldRate,
          newValue: `${newRate}%`,
          reason: reason || "Administrative adjustment",
          timestamp: new Date().toISOString()
        };

        currentAuditLogs.unshift(newAuditLog);
        resolve({ success: true, settings: currentSettings, auditLogs: currentAuditLogs });
      }, 600);
    });
  },

  // Toggle Program Active State
  toggleProgramStatus: async (activeState) => {
    return new Promise((resolve) => {
      setTimeout(() => {
        currentSettings.programActive = activeState;
        resolve({ success: true, active: currentSettings.programActive });
      }, 400);
    });
  },

  // Export CSV
  exportCSV: (records) => {
    const headers = [
      "Referrer Name", "Referrer ID", "Referred User", "User ID", "Country",
      "Deposit ($)", "Required Purchase ($)", "Actual Purchase ($)", "Progress (%)",
      "Status", "Reward ($)", "Reward Status", "Risk Level", "Joined Date"
    ];

    const rows = records.map(r => [
      `"${r.referrer.name}"`, r.referrer.id, `"${r.referredUser.name}"`, r.referredUser.id,
      r.referrer.country, r.depositAmount, r.requiredPurchase, r.actualPurchase,
      `${r.progressPercentage}%`, r.status, r.rewardAmount, r.rewardStatus,
      r.riskLevel, new Date(r.joinedDate).toLocaleDateString()
    ]);

    const csvContent = [headers.join(","), ...rows.map(e => e.join(","))].join("\n");
    const blob = new Blob([csvContent], { type: "text/csv;charset=utf-8;" });
    const url = URL.createObjectURL(blob);
    const link = document.createElement("a");
    link.setAttribute("href", url);
    link.setAttribute("download", `NobleCards_Referrals_Report_${new Date().toISOString().slice(0,10)}.csv`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  }
};