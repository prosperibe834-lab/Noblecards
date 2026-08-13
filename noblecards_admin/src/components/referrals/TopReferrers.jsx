import React from 'react';

const TopReferrers = ({ referrers }) => {
  return (
    <div className="ref-chart-card">
      <div className="ref-chart-header">
        <h3><i className='bx bx-crown' style={{ color: '#f59e0b' }}></i> Top Referrers Leaderboard</h3>
      </div>
      <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
        {referrers.map((item) => (
          <div 
            key={item.rank} 
            style={{ 
              display: 'flex', 
              alignItems: 'center', 
              justifyContent: 'space-between',
              padding: '10px 12px',
              borderRadius: '8px',
              background: 'var(--bg-primary)',
              border: '1px solid var(--border-color)'
            }}
          >
            <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
              <span style={{ fontWeight: '700', fontSize: '14px', width: '18px', color: 'var(--text-secondary)' }}>
                #{item.rank}
              </span>
              <div className="user-avatar-circle">{item.avatar}</div>
              <div>
                <strong style={{ fontSize: '13px' }}>{item.name}</strong>
                <div style={{ fontSize: '11px', color: 'var(--text-secondary)' }}>{item.id} • {item.country}</div>
              </div>
            </div>
            <div style={{ textAlign: 'right' }}>
              <strong style={{ fontSize: '13px', display: 'block' }}>{item.successfulReferrals} Invitees</strong>
              <span style={{ fontSize: '11px', color: '#22c55e', fontWeight: '600' }}>{item.totalEarned}</span>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default TopReferrers;