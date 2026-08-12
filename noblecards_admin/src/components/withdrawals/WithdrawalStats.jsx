import React from 'react';

const WithdrawalStats = ({ data, currentStatusFilter, onSelectStatusFilter }) => {
  const totalVolume = data.reduce((sum, item) => sum + item.usdValue, 0);
  const todayVolume = data
    .filter(item => new Date(item.date).toDateString() === new Date("2026-08-12").toDateString())
    .reduce((sum, item) => sum + item.usdValue, 0);

  const pendingVolume = data.filter(item => item.status === 'Pending').reduce((sum, item) => sum + item.usdValue, 0);
  const processingVolume = data.filter(item => item.status === 'Processing').reduce((sum, item) => sum + item.usdValue, 0);
  const completedVolume = data.filter(item => item.status === 'Completed').reduce((sum, item) => sum + item.usdValue, 0);
  const failedVolume = data.filter(item => item.status === 'Failed').reduce((sum, item) => sum + item.usdValue, 0);
  const totalFeesEarned = data.reduce((sum, item) => sum + item.nobleCardsFee, 0);

  const stats = [
    {
      label: "Total Volume",
      value: `$${totalVolume.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`,
      icon: "bx-dollar-circle",
      filter: "All",
      color: "var(--primary-green)",
      bg: "rgba(16, 185, 129, 0.1)",
      footer: "Lifetime processed"
    },
    {
      label: "Today's Volume",
      value: `$${todayVolume.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`,
      icon: "bx-calendar",
      filter: "All",
      color: "var(--blue)",
      bg: "rgba(37, 99, 235, 0.1)",
      footer: "Aug 12, 2026"
    },
    {
      label: "Pending Volume",
      value: `$${pendingVolume.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`,
      icon: "bx-time-five",
      filter: "Pending",
      color: "var(--warning)",
      bg: "rgba(245, 158, 11, 0.15)",
      footer: "Requires approval"
    },
    {
      label: "Processing",
      value: `$${processingVolume.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`,
      icon: "bx-loader-alt",
      filter: "Processing",
      color: "var(--info)",
      bg: "rgba(59, 130, 246, 0.15)",
      footer: "In provider queue"
    },
    {
      label: "Completed",
      value: `$${completedVolume.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`,
      icon: "bx-check-circle",
      filter: "Completed",
      color: "var(--success)",
      bg: "rgba(34, 197, 94, 0.15)",
      footer: "Settled successfully"
    },
    {
      label: "Failed Volume",
      value: `$${failedVolume.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`,
      icon: "bx-x-circle",
      filter: "Failed",
      color: "var(--error)",
      bg: "rgba(239, 68, 68, 0.15)",
      footer: "Needs attention"
    },
    {
      label: "NobleCards Fees",
      value: `$${totalFeesEarned.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`,
      icon: "bx-wallet",
      filter: "All",
      color: "var(--accent-gold)",
      bg: "rgba(245, 158, 11, 0.1)",
      footer: "Platform revenue"
    }
  ];

  return (
    <div className="nc-stats-grid">
      {stats.map((item, idx) => {
        const isActive = currentStatusFilter === item.filter && item.filter !== "All";
        return (
          <div 
            key={idx} 
            className={`nc-stat-card ${isActive ? 'active-filter' : ''}`}
            onClick={() => onSelectStatusFilter(item.filter)}
          >
            <div className="nc-stat-header">
              <span className="nc-stat-label">{item.label}</span>
              <div className="nc-stat-icon" style={{ color: item.color, backgroundColor: item.bg }}>
                <i className={`bx ${item.icon}`}></i>
              </div>
            </div>
            <div className="nc-stat-value">{item.value}</div>
            <div className="nc-stat-footer">
              <span>{item.footer}</span>
            </div>
          </div>
        );
      })}
    </div>
  );
};

export default WithdrawalStats;