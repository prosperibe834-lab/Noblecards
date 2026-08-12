import React from 'react';

const formatCurrency = (amount) => {
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
    minimumFractionDigits: 2
  }).format(amount);
};

export const DepositStats = ({ stats, activeStatusFilter, onSelectStatusFilter, onSelectAttention }) => {
  const cards = [
    {
      key: 'All',
      label: 'Total Deposits Volume',
      value: formatCurrency(stats.totalDepositsVolume),
      icon: 'bx-wallet-alt',
      trend: '+14.2%',
      isPositive: true,
      accent: 'primary'
    },
    {
      key: 'Today',
      label: "Today's Deposits",
      value: formatCurrency(stats.todaysDepositsVolume),
      icon: 'bx-time',
      trend: '+5.4%',
      isPositive: true,
      accent: 'info'
    },
    {
      key: 'Pending',
      label: 'Pending Deposits',
      value: formatCurrency(stats.pendingDepositsVolume),
      icon: 'bx-time-five',
      trend: 'Requires Auth',
      isPositive: null,
      accent: 'warning'
    },
    {
      key: 'Processing',
      label: 'Processing Deposits',
      value: formatCurrency(stats.processingDepositsVolume),
      icon: 'bx-loader-circle',
      trend: 'Webhook Active',
      isPositive: null,
      accent: 'info'
    },
    {
      key: 'Completed',
      label: 'Completed Deposits',
      value: formatCurrency(stats.completedDepositsVolume),
      icon: 'bx-check-circle',
      trend: '98.2% Rate',
      isPositive: true,
      accent: 'success'
    },
    {
      key: 'Failed',
      label: 'Failed Deposits',
      value: formatCurrency(stats.failedDepositsVolume),
      icon: 'bx-x-circle',
      trend: '-1.2%',
      isPositive: false,
      accent: 'danger'
    },
    {
      key: 'Revenue',
      label: 'NobleCards Fee Revenue',
      value: formatCurrency(stats.nobleRevenueFees),
      icon: 'bx-dollar-circle',
      trend: 'Earned Margin',
      isPositive: true,
      accent: 'purple',
      badge: 'Platform Income'
    }
  ];

  return (
    <div className="deposit-stats-grid">
      {cards.map((card) => {
        const isActive = activeStatusFilter === card.key;
        return (
          <div
            key={card.key}
            className={`deposit-stat-card ${card.accent} ${isActive ? 'active-filter-card' : ''}`}
            onClick={() => onSelectStatusFilter(card.key)}
            role="button"
            tabIndex={0}
          >
            <div className="stat-card-header">
              <div className={`stat-icon-wrapper ${card.accent}`}>
                <i className={`bx ${card.icon}`}></i>
              </div>
              {card.badge && <span className="stat-card-badge">{card.badge}</span>}
              {card.trend && !card.badge && (
                <span className={`stat-trend ${card.isPositive === true ? 'up' : card.isPositive === false ? 'down' : 'neutral'}`}>
                  {card.isPositive === true && <i className="bx bx-trending-up"></i>}
                  {card.isPositive === false && <i className="bx bx-trending-down"></i>}
                  {card.trend}
                </span>
              )}
            </div>
            <div className="stat-card-body">
              <span className="stat-label">{card.label}</span>
              <h3 className="stat-value">{card.value}</h3>
            </div>
          </div>
        );
      })}

      <div 
        className="deposit-stat-card attention-card"
        onClick={onSelectAttention}
        role="button"
        tabIndex={0}
      >
        <div className="stat-card-header">
          <div className="stat-icon-wrapper danger-glow">
            <i className="bx bx-error-alt"></i>
          </div>
          <span className="attention-pulse-badge">Action Required</span>
        </div>
        <div className="stat-card-body">
          <span className="stat-label">Needs Attention</span>
          <h3 className="stat-value">{stats.needsAttentionCount} Flagged Items</h3>
          <p className="stat-subtext">Mismatches & Delayed Webhooks</p>
        </div>
      </div>
    </div>
  );
};