import React from 'react';

const KYCStats = ({ data, onFilterStatus }) => {
  const stats = [
    { title: 'Total Submissions', count: data.length, icon: 'bx-folder', color: 'var(--primary-color)', bg: 'rgba(37, 99, 235, 0.1)', filter: 'All' },
    { title: 'Pending Review', count: data.filter(d => d.status === 'Pending').length, icon: 'bx-time-five', color: 'var(--warning-color)', bg: 'rgba(245, 158, 11, 0.1)', filter: 'Pending' },
    { title: 'Approved', count: data.filter(d => d.status === 'Approved').length, icon: 'bx-check-shield', color: 'var(--success-color)', bg: 'rgba(34, 197, 94, 0.1)', filter: 'Approved' },
    { title: 'High Risk / Flagged', count: data.filter(d => d.risk === 'High Risk').length, icon: 'bx-error-circle', color: 'var(--danger-color)', bg: 'rgba(239, 68, 68, 0.1)', filter: 'High Risk' },
  ];

  return (
    <div className="kyc-stats-grid">
      {stats.map((stat, index) => (
        <div key={index} className="stat-card" onClick={() => onFilterStatus(stat.filter)}>
          <div className="stat-icon" style={{ background: stat.bg, color: stat.color }}>
            <i className={`bx ${stat.icon}`}></i>
          </div>
          <div className="stat-details">
            <h3>{stat.title}</h3>
            <h2>{stat.count}</h2>
          </div>
        </div>
      ))}
    </div>
  );
};

export default KYCStats;