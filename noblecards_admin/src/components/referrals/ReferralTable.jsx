import React from 'react';

const ReferralTable = ({ data, onSelectRow }) => {
  const getStatusBadge = (status) => {
    switch(status) {
      case 'Qualified': return <span className="ref-badge ref-badge-success"><i className='bx bx-check-circle'></i> Qualified</span>;
      case 'Suspicious': return <span className="ref-badge ref-badge-danger"><i className='bx bx-error'></i> Suspicious</span>;
      default: return <span className="ref-badge ref-badge-pending"><i className='bx bx-time-five'></i> {status}</span>;
    }
  };

  const getRewardBadge = (rStatus) => {
    switch(rStatus) {
      case 'Paid': return <span className="ref-badge ref-badge-success">Paid</span>;
      case 'Held': return <span className="ref-badge ref-badge-danger">Held</span>;
      default: return <span className="ref-badge ref-badge-pending">Pending</span>;
    }
  };

  return (
    <div className="ref-table-responsive">
      <table className="ref-table">
        <thead>
          <tr>
            <th>Referrer</th>
            <th>Referred User</th>
            <th>Deposit</th>
            <th>Gift Card Spend</th>
            <th>Qualification Progress</th>
            <th>Status</th>
            <th>Reward ($)</th>
            <th>Risk</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          {data.length === 0 ? (
            <tr>
              <td colSpan="9" style={{ textAlign: 'center', padding: '32px', color: 'var(--text-secondary)' }}>
                <i className='bx bx-folder-open' style={{ fontSize: '36px', marginBottom: '8px' }}></i>
                <p>No referral records match the selected filters.</p>
              </td>
            </tr>
          ) : (
            data.map((row) => (
              <tr key={row.id}>
                <td>
                  <div className="user-cell-flex">
                    <div className="user-avatar-circle">{row.referrer.avatar}</div>
                    <div>
                      <strong>{row.referrer.name}</strong>
                      <div style={{ fontSize: '11px', color: 'var(--text-secondary)' }}>{row.referrer.id}</div>
                    </div>
                  </div>
                </td>
                <td>
                  <div className="user-cell-flex">
                    <div className="user-avatar-circle" style={{ background: '#3b82f6' }}>{row.referredUser.avatar}</div>
                    <div>
                      <strong>{row.referredUser.name}</strong>
                      <div style={{ fontSize: '11px', color: 'var(--text-secondary)' }}>{row.referredUser.id}</div>
                    </div>
                  </div>
                </td>
                <td>${row.depositAmount.toFixed(2)}</td>
                <td>
                  ${row.actualPurchase.toFixed(2)}
                  <span style={{ fontSize: '10px', color: 'var(--text-secondary)', display: 'block' }}>
                    Req: ${row.requiredPurchase.toFixed(2)}
                  </span>
                </td>
                <td>
                  <div className="progress-container">
                    <div className="progress-bar-bg">
                      <div 
                        className="progress-bar-fill" 
                        style={{ 
                          width: `${Math.min(row.progressPercentage, 100)}%`, 
                          background: row.progressPercentage >= 100 ? '#22c55e' : '#f59e0b' 
                        }}
                      />
                    </div>
                    <span style={{ fontSize: '11px', fontWeight: '600' }}>{row.progressPercentage}%</span>
                  </div>
                </td>
                <td>{getStatusBadge(row.status)}</td>
                <td>
                  <strong>${row.rewardAmount.toFixed(2)}</strong>
                  <div style={{ marginTop: '2px' }}>{getRewardBadge(row.rewardStatus)}</div>
                </td>
                <td>
                  {row.riskLevel === 'High Risk' ? (
                    <span className="ref-badge ref-badge-danger"><i className='bx bx-shield-x'></i> High</span>
                  ) : (
                    <span className="ref-badge ref-badge-success"><i className='bx bx-shield-check'></i> Normal</span>
                  )}
                </td>
                <td>
                  <button className="ref-btn ref-btn-outline" style={{ padding: '6px 12px', fontSize: '12px' }} onClick={() => onSelectRow(row)}>
                    Details <i className='bx bx-chevron-right'></i>
                  </button>
                </td>
              </tr>
            ))
          )}
        </tbody>
      </table>
    </div>
  );
};

export default ReferralTable;