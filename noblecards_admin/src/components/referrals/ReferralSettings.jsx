import React from 'react';

const ReferralSettings = ({ settings, auditLogs, onOpenRateModal, onTogglePause }) => {
  return (
    <div className="ref-chart-card">
      <div className="ref-chart-header">
        <h3><i className='bx bx-slider-alt'></i> Referral Program Configuration</h3>
        <button 
          className={`ref-btn ${settings.programActive ? 'ref-btn-danger' : 'ref-btn-primary'}`} 
          style={{ padding: '6px 12px', fontSize: '12px' }}
          onClick={() => onTogglePause(!settings.programActive)}
        >
          {settings.programActive ? 'Pause Program' : 'Activate Program'}
        </button>
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px', marginBottom: '20px', fontSize: '13px' }}>
        <div style={{ background: 'var(--bg-primary)', padding: '12px', borderRadius: '8px' }}>
          <span style={{ color: 'var(--text-secondary)', display: 'block', fontSize: '11px' }}>Current Commission Rate</span>
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginTop: '4px' }}>
            <strong style={{ fontSize: '18px', color: 'var(--primary-color)' }}>{settings.commissionRate}%</strong>
            <button className="ref-btn ref-btn-outline" style={{ padding: '4px 8px', fontSize: '11px' }} onClick={onOpenRateModal}>
              <i className='bx bx-edit'></i> Change Rate
            </button>
          </div>
        </div>

        <div style={{ background: 'var(--bg-primary)', padding: '12px', borderRadius: '8px' }}>
          <span style={{ color: 'var(--text-secondary)', display: 'block', fontSize: '11px' }}>Min Qualifying Purchase</span>
          <strong style={{ fontSize: '16px', marginTop: '4px', display: 'block' }}>
            {settings.qualifyingPurchasePercentage}% of Deposit
          </strong>
        </div>
      </div>

      <h4 style={{ fontSize: '14px', fontWeight: '700', marginBottom: '10px' }}>Financial Configuration Audit Trail</h4>
      <div style={{ display: 'flex', flexDirection: 'column', gap: '8px', maxHeight: '180px', overflowY: 'auto' }}>
        {auditLogs.map((log) => (
          <div key={log.id} style={{ fontSize: '12px', padding: '8px 10px', background: 'var(--bg-primary)', borderRadius: '6px', borderLeft: '3px solid var(--primary-color)' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', fontWeight: '600' }}>
              <span>{log.action} ({log.previousValue} → {log.newValue})</span>
              <span style={{ color: 'var(--text-secondary)', fontSize: '10px' }}>{new Date(log.timestamp).toLocaleDateString()}</span>
            </div>
            <div style={{ color: 'var(--text-secondary)', fontSize: '11px', marginTop: '2px' }}>
              By: {log.admin} • Reason: "{log.reason}"
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default ReferralSettings;