import React from 'react';

const ReferralDetailsDrawer = ({ referral, onClose }) => {
  if (!referral) return null;

  return (
    <div className="ref-modal-overlay" onClick={onClose}>
      <div className="ref-drawer-content" onClick={(e) => e.stopPropagation()}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '20px' }}>
          <div>
            <h2 style={{ fontSize: '18px', fontWeight: '700' }}>Referral Details</h2>
            <span style={{ fontSize: '12px', color: 'var(--text-secondary)' }}>ID: {referral.id}</span>
          </div>
          <button className="ref-btn ref-btn-outline" style={{ padding: '6px' }} onClick={onClose}>
            <i className='bx bx-x' style={{ fontSize: '20px' }}></i>
          </button>
        </div>

        {/* Restricted Reward Visual Banner */}
        <div className="restricted-reward-banner">
          <h5><i className='bx bx-lock-alt'></i> Restricted Referral Reward</h5>
          <p style={{ fontSize: '12px', margin: '0 0 8px 0', color: 'var(--text-primary)' }}>
            This reward is credited directly to the user's Restricted Reward Balance.
          </p>
          <ul>
            <li style={{ color: '#22c55e' }}><i className='bx bx-check'></i> Allowed: Gift Card Purchases</li>
            <li style={{ color: '#ef4444' }}><i className='bx bx-x'></i> Not Allowed: Cash Withdrawals or Transfers</li>
          </ul>
        </div>

        {/* Fraud & Risk Panel */}
        {referral.riskLevel === 'High Risk' ? (
          <div className="risk-panel">
            <h5 style={{ color: '#ef4444', margin: '0 0 6px 0', display: 'flex', alignItems: 'center', gap: '6px' }}>
              <i className='bx bx-error-circle'></i> High Risk Flags Detected
            </h5>
            <ul style={{ margin: 0, paddingLeft: '18px', fontSize: '12px', color: 'var(--text-primary)' }}>
              {referral.riskReasons.map((reason, i) => <li key={i}>{reason}</li>)}
            </ul>
          </div>
        ) : (
          <div className="risk-panel normal">
            <h5 style={{ color: '#22c55e', margin: 0, display: 'flex', alignItems: 'center', gap: '6px' }}>
              <i className='bx bx-shield-check'></i> Security Check Passed (Normal Risk)
            </h5>
          </div>
        )}

        {/* Referrer & Referred User Cards */}
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px', marginBottom: '20px' }}>
          <div style={{ background: 'var(--bg-primary)', padding: '12px', borderRadius: '8px', border: '1px solid var(--border-color)' }}>
            <span style={{ fontSize: '11px', color: 'var(--text-secondary)', textTransform: 'uppercase' }}>Referrer</span>
            <div style={{ fontWeight: '700', fontSize: '14px', marginTop: '4px' }}>{referral.referrer.name}</div>
            <div style={{ fontSize: '12px', color: 'var(--text-secondary)' }}>{referral.referrer.id}</div>
            <div style={{ fontSize: '12px', marginTop: '4px' }}>Code: <strong>{referral.codeUsed}</strong></div>
          </div>
          <div style={{ background: 'var(--bg-primary)', padding: '12px', borderRadius: '8px', border: '1px solid var(--border-color)' }}>
            <span style={{ fontSize: '11px', color: 'var(--text-secondary)', textTransform: 'uppercase' }}>Referred User</span>
            <div style={{ fontWeight: '700', fontSize: '14px', marginTop: '4px' }}>{referral.referredUser.name}</div>
            <div style={{ fontSize: '12px', color: 'var(--text-secondary)' }}>{referral.referredUser.id}</div>
            <div style={{ fontSize: '12px', marginTop: '4px' }}>Country: <strong>{referral.referredUser.country}</strong></div>
          </div>
        </div>

        {/* Qualification Metrics */}
        <h4 style={{ fontSize: '14px', fontWeight: '700', marginBottom: '12px' }}>Qualification & Activity</h4>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px', marginBottom: '20px', fontSize: '13px' }}>
          <div>
            <span style={{ color: 'var(--text-secondary)' }}>Deposit Amount:</span>
            <div style={{ fontWeight: '600' }}>${referral.depositAmount.toFixed(2)}</div>
          </div>
          <div>
            <span style={{ color: 'var(--text-secondary)' }}>Required Purchase (10%):</span>
            <div style={{ fontWeight: '600' }}>${referral.requiredPurchase.toFixed(2)}</div>
          </div>
          <div>
            <span style={{ color: 'var(--text-secondary)' }}>Actual Gift Card Spend:</span>
            <div style={{ fontWeight: '600' }}>${referral.actualPurchase.toFixed(2)}</div>
          </div>
          <div>
            <span style={{ color: 'var(--text-secondary)' }}>Calculated Reward (1.5%):</span>
            <div style={{ fontWeight: '600', color: 'var(--primary-color)' }}>${referral.rewardAmount.toFixed(2)}</div>
          </div>
        </div>

        {/* Referral Audit Timeline */}
        <h4 style={{ fontSize: '14px', fontWeight: '700', marginBottom: '12px' }}>Audit Timeline</h4>
        <div className="ref-timeline">
          {referral.timeline.map((step, idx) => (
            <div key={idx} className={`ref-timeline-item ${step.status}`}>
              <strong style={{ fontSize: '13px', display: 'block' }}>{step.step}</strong>
              <span style={{ fontSize: '11px', color: 'var(--text-secondary)' }}>
                {step.date ? new Date(step.date).toLocaleString() : 'Pending'}
              </span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default ReferralDetailsDrawer;