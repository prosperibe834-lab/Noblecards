import React from 'react';

const WithdrawalDetails = ({ withdrawal, onClose, onViewUser }) => {
  if (!withdrawal) return null;

  return (
    <div className="nc-drawer-overlay" onClick={onClose}>
      <div className="nc-drawer-content" onClick={(e) => e.stopPropagation()}>
        {/* Drawer Header */}
        <div className="nc-drawer-header">
          <div>
            <h2 className="nc-drawer-title">Withdrawal Request Details</h2>
            <span style={{ fontSize: '12px', color: 'var(--secondary-text)' }}>ID: {withdrawal.id}</span>
          </div>
          <button className="nc-btn nc-btn-sm" onClick={onClose}>
            <i className='bx bx-x' style={{ fontSize: '20px' }}></i>
          </button>
        </div>

        {/* User Card */}
        <div className="nc-detail-card">
          <div className="nc-detail-card-title">
            <i className='bx bx-user'></i> User Information
          </div>
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
              <img src={withdrawal.avatar} alt="" className="nc-user-avatar" style={{ width: '44px', height: '44px' }} />
              <div>
                <div style={{ fontWeight: 700, color: 'var(--primary-text)' }}>{withdrawal.userName}</div>
                <div style={{ fontSize: '12px', color: 'var(--secondary-text)' }}>{withdrawal.userEmail} • {withdrawal.userPhone}</div>
              </div>
            </div>
            <button className="nc-btn nc-btn-sm" onClick={() => onViewUser(withdrawal.userId)}>
              View Profile
            </button>
          </div>
        </div>

        {/* Financial Breakdown */}
        <div className="nc-detail-card">
          <div className="nc-detail-card-title">
            <i className='bx bx-calculator'></i> Transaction Ledger Breakdown
          </div>
          <div className="nc-detail-row">
            <span className="nc-detail-label">Original Request Amount</span>
            <span className="nc-detail-val">{withdrawal.currency} {withdrawal.originalAmount.toLocaleString()}</span>
          </div>
          <div className="nc-detail-row">
            <span className="nc-detail-label">Snapshot Rate Applied</span>
            <span className="nc-detail-val">1 USD = {withdrawal.nobleCardsRate} {withdrawal.currency} ({withdrawal.rateMarkup} markup)</span>
          </div>
          <div className="nc-detail-row">
            <span className="nc-detail-label">USD Equivalent</span>
            <span className="nc-detail-val">${withdrawal.grossAmountUsd.toFixed(2)}</span>
          </div>
          <div className="nc-detail-row">
            <span className="nc-detail-label">NobleCards Platform Fee</span>
            <span className="nc-detail-val" style={{ color: 'var(--success)' }}>-${withdrawal.nobleCardsFee.toFixed(2)}</span>
          </div>
          <div className="nc-detail-row">
            <span className="nc-detail-label">Provider Execution Fee</span>
            <span className="nc-detail-val" style={{ color: 'var(--warning)' }}>-${withdrawal.providerFee.toFixed(2)}</span>
          </div>
          <div style={{ borderTop: '1px dashed var(--border)', paddingTop: '8px', marginTop: '8px' }} className="nc-detail-row">
            <span className="nc-detail-label" style={{ fontWeight: 700 }}>Net Payout Amount</span>
            <span className="nc-detail-val" style={{ fontSize: '16px', color: 'var(--primary-green)' }}>
              ${withdrawal.netAmountUsd.toFixed(2)} USD
            </span>
          </div>
        </div>

        {/* Wallet Ledger History */}
        <div className="nc-detail-card">
          <div className="nc-detail-card-title">
            <i className='bx bx-wallet-alt'></i> User Wallet Ledger State
          </div>
          <div className="nc-detail-row">
            <span className="nc-detail-label">Wallet Balance Before</span>
            <span className="nc-detail-val">${withdrawal.walletBefore.toFixed(2)}</span>
          </div>
          <div className="nc-detail-row">
            <span className="nc-detail-label">Deduction</span>
            <span className="nc-detail-val" style={{ color: 'var(--error)' }}>-${withdrawal.grossAmountUsd.toFixed(2)}</span>
          </div>
          <div className="nc-detail-row">
            <span className="nc-detail-label">Wallet Balance After</span>
            <span className="nc-detail-val">${withdrawal.walletAfter.toFixed(2)}</span>
          </div>
        </div>

        {/* Provider Reconciliation */}
        <div className="nc-detail-card">
          <div className="nc-detail-card-title">
            <i className='bx bx-check-shield'></i> Provider & Reconciliation
          </div>
          <div className="nc-detail-row">
            <span className="nc-detail-label">Payment Gateway</span>
            <span className="nc-detail-val">{withdrawal.provider}</span>
          </div>
          <div className="nc-detail-row">
            <span className="nc-detail-label">Provider Reference</span>
            <span className="nc-detail-val">{withdrawal.providerReference}</span>
          </div>
          <div className="nc-detail-row">
            <span className="nc-detail-label">Reconciliation Status</span>
            <span className={`nc-badge badge-${withdrawal.reconciliation.status === 'Reconciled' ? 'completed' : 'failed'}`}>
              {withdrawal.reconciliation.status}
            </span>
          </div>
        </div>

        {/* Timeline */}
        <div className="nc-detail-card">
          <div className="nc-detail-card-title">
            <i className='bx bx-time'></i> Transaction Lifecycle Timeline
          </div>
          <div className="nc-timeline">
            {withdrawal.timeline.map((item, idx) => (
              <div key={idx} className="nc-timeline-item">
                <div className="nc-timeline-title">{item.status}</div>
                <div className="nc-timeline-time">{item.date} at {item.time} • via {item.source}</div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};

export default WithdrawalDetails;