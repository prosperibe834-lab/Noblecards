import React from 'react';

const TransactionStats = ({ metrics, activeStatusFilter, onSelectStatus }) => {
  const cards = [
    {
      id: 'volume',
      title: 'Total Transaction Volume',
      value: `$${metrics.totalVolumeUSD.toLocaleString(undefined, { minimumFractionDigits: 2 })}`,
      icon: 'bx-line-chart',
      colorClass: 'gc-stat-blue',
      trend: '+12.4% vs last month',
      filterKey: 'All'
    },
    {
      id: 'today',
      title: "Today's Volume",
      value: `$${metrics.todayVolumeUSD.toLocaleString(undefined, { minimumFractionDigits: 2 })}`,
      icon: 'bx-time-five',
      colorClass: 'gc-stat-purple',
      trend: '+5.2% vs yesterday',
      filterKey: 'All'
    },
    {
      id: 'successful',
      title: 'Successful',
      value: `$${metrics.successfulUSD.toLocaleString(undefined, { minimumFractionDigits: 2 })}`,
      icon: 'bx-check-circle',
      colorClass: 'gc-stat-green',
      trend: '94.2% completion rate',
      filterKey: 'Successful'
    },
    {
      id: 'pending',
      title: 'Pending Transactions',
      value: `$${metrics.pendingUSD.toLocaleString(undefined, { minimumFractionDigits: 2 })}`,
      icon: 'bx-loader-circle',
      colorClass: 'gc-stat-gold',
      trend: 'Avg resolution: 4 mins',
      filterKey: 'Pending'
    },
    {
      id: 'failed',
      title: 'Failed Transactions',
      value: `$${metrics.failedUSD.toLocaleString(undefined, { minimumFractionDigits: 2 })}`,
      icon: 'bx-x-circle',
      colorClass: 'gc-stat-red',
      trend: '0.4% failure rate',
      filterKey: 'Failed'
    },
    {
      id: 'revenue',
      title: 'NobleCards Revenue',
      value: `$${metrics.revenueUSD.toLocaleString(undefined, { minimumFractionDigits: 2 })}`,
      icon: 'bx-wallet-alt',
      colorClass: 'gc-stat-green-dark',
      trend: 'Net margin earnings',
      filterKey: 'All'
    }
  ];

  return (
    <div className="tx-stats-grid">
      {cards.map(card => {
        const isActive = activeStatusFilter === card.filterKey && card.filterKey !== 'All';
        return (
          <div 
            key={card.id} 
            className={`tx-stat-card ${card.colorClass} ${isActive ? 'tx-stat-card-active' : ''}`}
            onClick={() => onSelectStatus(card.filterKey)}
          >
            <div className="tx-stat-header">
              <span className="tx-stat-title">{card.title}</span>
              <div className="tx-stat-icon"><i className={`bx ${card.icon}`}></i></div>
            </div>
            <div className="tx-stat-value">{card.value}</div>
            <div className="tx-stat-footer">
              <span className="tx-stat-trend"><i className="bx bx-trending-up"></i> {card.trend}</span>
            </div>
          </div>
        );
      })}
    </div>
  );
};

export default TransactionStats;