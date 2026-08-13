import React from 'react';

const ReferralStats = ({ summary }) => {
  const cards = [
    { title: 'Total Referrals', value: summary?.totalReferrals || 0, icon: 'bx-group', color: 'var(--primary-color, #2563eb)', bg: 'rgba(37, 99, 235, 0.1)' },
    { title: 'Successful Referrals', value: summary?.successfulReferrals || 0, icon: 'bx-check-double', color: '#22c55e', bg: 'rgba(34, 197, 94, 0.1)' },
    { title: 'Pending Referrals', value: summary?.pendingReferrals || 0, icon: 'bx-time-five', color: '#f59e0b', bg: 'rgba(245, 158, 11, 0.1)' },
    { title: 'Active Referrers', value: summary?.activeReferrers || 0, icon: 'bx-user-check', color: '#8b5cf6', bg: 'rgba(139, 92, 246, 0.1)' },
    { title: 'Rewards Paid', value: summary?.totalRewardsPaid || '$0.00', icon: 'bx-gift', color: '#10b981', bg: 'rgba(16, 185, 129, 0.1)' },
    { title: 'Pending Rewards', value: summary?.pendingRewards || '$0.00', icon: 'bx-dollar-circle', color: '#3b82f6', bg: 'rgba(59, 130, 246, 0.1)' },
    { title: 'Conversion Rate', value: summary?.conversionRate || '0.0%', icon: 'bx-trending-up', color: '#06b6d4', bg: 'rgba(6, 182, 212, 0.1)' },
    { title: 'Suspicious Referrals', value: summary?.suspiciousReferrals || 0, icon: 'bx-error-circle', color: '#ef4444', bg: 'rgba(239, 68, 68, 0.1)' },
  ];

  return (
    <div className="ref-stats-grid">
      {cards.map((card, idx) => (
        <div key={idx} className="ref-stat-card">
          <div className="ref-stat-icon" style={{ background: card.bg, color: card.color }}>
            <i className={`bx ${card.icon}`}></i>
          </div>
          <div className="ref-stat-info">
            <h4>{card.title}</h4>
            <h2>{card.value}</h2>
          </div>
        </div>
      ))}
    </div>
  );
};

export default ReferralStats;