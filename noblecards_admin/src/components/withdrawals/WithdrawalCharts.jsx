import React from 'react';

const WithdrawalCharts = ({ data }) => {
  const methodCounts = data.reduce((acc, curr) => {
    acc[curr.method] = (acc[curr.method] || 0) + 1;
    return acc;
  }, {});

  const maxCount = Math.max(...Object.values(methodCounts), 1);

  return (
    <div className="nc-charts-grid">
      {/* Chart 1: Volume Trend */}
      <div className="nc-chart-card">
        <div className="nc-chart-title">
          <span>Withdrawal Volume Overview (USD)</span>
          <i className='bx bx-line-chart' style={{ color: 'var(--primary-green)' }}></i>
        </div>
        <div className="nc-custom-chart-placeholder">
          {[
            { day: "Aug 06", val: 420 },
            { day: "Aug 07", val: 680 },
            { day: "Aug 08", val: 400 },
            { day: "Aug 09", val: 1628 },
            { day: "Aug 10", val: 1088 },
            { day: "Aug 11", val: 2750 },
            { day: "Aug 12", val: 1903 },
          ].map((item, idx) => (
            <div key={idx} className="nc-chart-bar-group">
              <div 
                className="nc-chart-bar" 
                style={{ height: `${(item.val / 3000) * 100}%` }}
                title={`$${item.val}`}
              ></div>
              <span className="nc-chart-bar-label">{item.day}</span>
            </div>
          ))}
        </div>
      </div>

      {/* Chart 2: Method Breakdown */}
      <div className="nc-chart-card">
        <div className="nc-chart-title">
          <span>By Method</span>
          <i className='bx bx-pie-chart-alt-2' style={{ color: 'var(--blue)' }}></i>
        </div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: '10px', paddingTop: '10px' }}>
          {Object.entries(methodCounts).map(([method, count], idx) => (
            <div key={idx} style={{ fontSize: '12px' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '4px' }}>
                <span style={{ color: 'var(--primary-text)' }}>{method}</span>
                <span style={{ color: 'var(--secondary-text)', fontWeight: 600 }}>{count}</span>
              </div>
              <div style={{ height: '6px', backgroundColor: 'var(--background)', borderRadius: '3px', overflow: 'hidden' }}>
                <div 
                  style={{ 
                    height: '100%', 
                    width: `${(count / maxCount) * 100}%`, 
                    backgroundColor: idx % 2 === 0 ? 'var(--primary-green)' : 'var(--blue)' 
                  }}
                ></div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Chart 3: Health & Security Summary */}
      <div className="nc-chart-card">
        <div className="nc-chart-title">
          <span>Reconciliation Status</span>
          <i className='bx bx-shield-quarter' style={{ color: 'var(--warning)' }}></i>
        </div>
        <div style={{ textAlign: 'center', padding: '16px 0' }}>
          <div style={{ fontSize: '32px', fontWeight: '700', color: 'var(--success)' }}>
            100%
          </div>
          <div style={{ fontSize: '13px', color: 'var(--secondary-text)', marginTop: '4px' }}>
            Ledger & Provider Matched
          </div>
          <div style={{ marginTop: '16px', fontSize: '12px', padding: '8px', backgroundColor: 'var(--background)', borderRadius: '6px', border: '1px solid var(--border)' }}>
            <i className='bx bx-check-double' style={{ color: 'var(--success)' }}></i> 0 Unresolved Ledger Discrepancies
          </div>
        </div>
      </div>
    </div>
  );
};

export default WithdrawalCharts;