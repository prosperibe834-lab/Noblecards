import React from 'react';

export const DashboardSkeleton = () => {
  return (
    <div className="dashboard-container">
      <div className="skeleton-box" style={{ height: '60px', width: '100%' }}></div>
      <div className="stats-grid-row">
        {[1, 2, 3, 4].map((i) => (
          <div key={i} className="skeleton-box" style={{ height: '140px' }}></div>
        ))}
      </div>
      <div className="charts-grid-row">
        <div className="skeleton-box" style={{ height: '280px' }}></div>
        <div className="skeleton-box" style={{ height: '280px' }}></div>
      </div>
    </div>
  );
};

export const ErrorState = ({ onRetry }) => {
  return (
    <div className="dashboard-card" style={{ textAlign: 'center', padding: '40px' }}>
      <i className="bx bx-error-circle" style={{ fontSize: '3rem', color: 'var(--error)' }}></i>
      <h3 style={{ marginTop: '12px' }}>Failed to load dashboard data</h3>
      <p style={{ color: 'var(--secondary-text)', fontSize: '0.9rem', marginBottom: '16px' }}>
        Please check your network connection or try again.
      </p>
      <button className="view-all-btn" onClick={onRetry}>
        Retry
      </button>
    </div>
  );
};

export const EmptyState = ({ message = "No data available" }) => {
  return (
    <div className="dashboard-card" style={{ textAlign: 'center', padding: '30px' }}>
      <i className="bx bx-folder-open" style={{ fontSize: '2.5rem', color: 'var(--secondary-text)' }}></i>
      <p style={{ color: 'var(--secondary-text)', marginTop: '8px' }}>{message}</p>
    </div>
  );
};