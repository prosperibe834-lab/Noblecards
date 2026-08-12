import React from 'react';

export const WithdrawalShimmer = () => (
  <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
    <div className="nc-stats-grid">
      {[1, 2, 3, 4, 5, 6, 7].map((i) => (
        <div key={i} className="nc-stat-card">
          <div className="nc-shimmer" style={{ height: '16px', width: '60%', marginBottom: '12px' }}></div>
          <div className="nc-shimmer" style={{ height: '28px', width: '80%' }}></div>
        </div>
      ))}
    </div>
    <div className="nc-table-card" style={{ padding: '24px' }}>
      {[1, 2, 3, 4, 5].map((i) => (
        <div key={i} className="nc-shimmer" style={{ height: '40px', width: '100%', marginBottom: '12px' }}></div>
      ))}
    </div>
  </div>
);

export const WithdrawalEmptyState = ({ onReset }) => (
  <div style={{ textAlign: 'center', padding: '48px 24px' }}>
    <div style={{ fontSize: '48px', color: 'var(--secondary-text)', marginBottom: '12px' }}>
      <i className='bx bx-search-alt'></i>
    </div>
    <h3 style={{ fontSize: '18px', margin: '0 0 8px 0', color: 'var(--primary-text)' }}>No Withdrawals Found</h3>
    <p style={{ color: 'var(--secondary-text)', fontSize: '14px', margin: '0 0 20px 0' }}>
      No withdrawal transactions match your current filter parameters or search term.
    </p>
    <button className="nc-btn nc-btn-primary" onClick={onReset}>
      <i className='bx bx-reset'></i> Clear All Filters
    </button>
  </div>
);

export const WithdrawalErrorState = ({ onRetry }) => (
  <div style={{ textAlign: 'center', padding: '48px 24px', backgroundColor: 'var(--card)', borderRadius: '12px', border: '1px solid var(--border)' }}>
    <div style={{ fontSize: '48px', color: 'var(--error)', marginBottom: '12px' }}>
      <i className='bx bx-error-circle'></i>
    </div>
    <h3 style={{ fontSize: '18px', margin: '0 0 8px 0', color: 'var(--primary-text)' }}>Unable to Load Withdrawals</h3>
    <p style={{ color: 'var(--secondary-text)', fontSize: '14px', margin: '0 0 20px 0' }}>
      A network error occurred while connecting to the server. Please check connection and try again.
    </p>
    <button className="nc-btn nc-btn-primary" onClick={onRetry}>
      <i className='bx bx-refresh'></i> Retry Request
    </button>
  </div>
);