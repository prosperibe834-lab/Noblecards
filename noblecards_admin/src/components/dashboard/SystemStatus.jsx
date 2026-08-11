import React from 'react';

const SystemStatus = ({ statusData }) => {
  return (
    <div className="dashboard-card">
      <div className="dashboard-card-header">
        <h3 className="dashboard-card-title">System Status</h3>
        <div className="system-status-indicator-badge">
          <span className="status-pulse-dot"></span>
          <span>{statusData.overall}</span>
        </div>
      </div>

      <div className="status-progress-list">
        {statusData.metrics.map((metric, idx) => (
          <div key={idx} className="status-metric-item">
            <div className="status-metric-label-row">
              <span style={{ color: 'var(--secondary-text)' }}>{metric.name}</span>
              <span>{metric.percentage}%</span>
            </div>
            <div className="status-progress-track">
              <div
                className="status-progress-fill"
                style={{
                  width: `${metric.percentage}%`,
                  backgroundColor: metric.color,
                }}
              ></div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default SystemStatus;