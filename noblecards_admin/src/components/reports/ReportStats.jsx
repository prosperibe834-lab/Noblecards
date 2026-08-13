// src/components/reports/ReportStats.jsx
import React from 'react';

const formatCurrency = (value) => {
  return new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(value);
};

const formatNumber = (value) => {
  return new Intl.NumberFormat('en-US').format(value);
};

const StatCard = ({ title, value, change, icon, isCurrency, colorPrefix, loading }) => {
  const isPositive = change >= 0;
  const displayValue = isCurrency ? formatCurrency(value) : formatNumber(value);

  if (loading) {
    return <div className="stat-card shimmer" style={{ height: '140px' }}></div>;
  }

  return (
    <div className="stat-card">
      <div className="stat-header">
        <span className="stat-title">{title}</span>
        <div 
          className="stat-icon" 
          style={{ 
            backgroundColor: `rgba(var(--${colorPrefix}-rgb, 37, 99, 235), 0.1)`, 
            color: `var(--${colorPrefix}-color, var(--primary-color))` 
          }}
        >
          <i className={`bx ${icon}`}></i>
        </div>
      </div>
      <div className="stat-value">{displayValue}</div>
      <div className={`stat-change ${isPositive ? 'positive' : 'negative'}`}>
        <i className={`bx ${isPositive ? 'bx-up-arrow-alt' : 'bx-down-arrow-alt'}`}></i>
        {Math.abs(change)}% from last period
      </div>
    </div>
  );
};

const ReportStats = ({ summary, loading }) => {
  if (!summary) return null;

  return (
    <div className="stats-grid">
      <StatCard title="Total Revenue" value={summary.revenue} change={summary.revenueChange} icon="bx-dollar-circle" isCurrency colorPrefix="primary" loading={loading} />
      <StatCard title="Transaction Volume" value={summary.transactionVolume} change={summary.volumeChange} icon="bx-transfer" isCurrency colorPrefix="info" loading={loading} />
      <StatCard title="Net Revenue" value={summary.netRevenue} change={summary.netChange} icon="bx-line-chart" isCurrency colorPrefix="success" loading={loading} />
      <StatCard title="Gift Card Revenue" value={summary.giftCardRevenue} change={summary.gcChange} icon="bx-gift" isCurrency colorPrefix="warning" loading={loading} />
      <StatCard title="Deposit Volume" value={summary.deposits} change={summary.depositsChange} icon="bx-down-arrow-circle" isCurrency colorPrefix="success" loading={loading} />
      <StatCard title="Withdrawal Volume" value={summary.withdrawals} change={summary.withdrawalsChange} icon="bx-up-arrow-circle" isCurrency colorPrefix="danger" loading={loading} />
      <StatCard title="Total Users" value={summary.totalUsers} change={summary.usersChange} icon="bx-group" isCurrency={false} colorPrefix="primary" loading={loading} />
      <StatCard title="Active Users" value={summary.activeUsers} change={summary.activeChange} icon="bx-user-check" isCurrency={false} colorPrefix="success" loading={loading} />
    </div>
  );
};

export default ReportStats;