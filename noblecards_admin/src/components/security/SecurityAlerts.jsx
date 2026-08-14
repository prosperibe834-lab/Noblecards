// ==========================================
// NEW FILE
// File: src/components/security/SecurityAlerts.jsx
// Purpose: Displays active security alerts with inspection triggers
// ==========================================

import React from "react";

export const SecurityAlerts = ({ alerts, onViewDetails }) => {
  if (!alerts || alerts.length === 0) return null;

  const getRiskBadge = (risk) => {
    switch (risk.toUpperCase()) {
      case "CRITICAL":
        return { label: "CRITICAL", bg: "rgba(239, 68, 68, 0.15)", color: "var(--danger-color)" };
      case "HIGH":
        return { label: "HIGH", bg: "rgba(245, 158, 11, 0.15)", color: "var(--warning-color)" };
      case "MEDIUM":
        return { label: "MEDIUM", bg: "rgba(59, 130, 246, 0.15)", color: "var(--info-color)" };
      default:
        return { label: "LOW", bg: "rgba(34, 197, 94, 0.15)", color: "var(--success-color)" };
    }
  };

  return (
    <div className="security-alerts-container">
      <div className="security-alerts-header">
        <div className="security-alerts-title-group">
          <i className="bx bx-bell-plus text-warning"></i>
          <h3>Active Security Alerts</h3>
          <span className="alerts-count-badge">{alerts.length}</span>
        </div>
        <span className="security-alerts-subtext">Real-time threat monitoring</span>
      </div>

      <div className="security-alerts-grid">
        {alerts.map((alert) => {
          const riskStyle = getRiskBadge(alert.risk);
          return (
            <div key={alert.id} className="security-alert-card">
              <div className="security-alert-top">
                <span className="alert-type">{alert.type}</span>
                <span className="alert-risk-tag" style={{ backgroundColor: riskStyle.bg, color: riskStyle.color }}>
                  {riskStyle.label}
                </span>
              </div>
              <p className="alert-description">{alert.description}</p>
              <div className="alert-meta">
                <span>
                  <i className="bx bx-time-five"></i> {alert.time}
                </span>
                <span>
                  <i className="bx bx-map-pin"></i> {alert.location}
                </span>
              </div>
              <div className="alert-action-row">
                <span className="alert-user-id">
                  <i className="bx bx-user"></i> {alert.userName} ({alert.userId})
                </span>
                <button className="alert-details-btn" onClick={() => onViewDetails(alert.logId)}>
                  View Details <i className="bx bx-chevron-right"></i>
                </button>
              </div>
            </div>
          );
        })}
      </div>

      <style>{`
        .security-alerts-container {
          background-color: var(--bg-card);
          border: 1px solid var(--border-color);
          border-left: 4px solid var(--warning-color);
          border-radius: 12px;
          padding: 1.25rem;
          margin-bottom: 1.5rem;
        }

        .security-alerts-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 1rem;
        }

        .security-alerts-title-group {
          display: flex;
          align-items: center;
          gap: 0.5rem;
        }

        .security-alerts-title-group i {
          font-size: 1.3rem;
          color: var(--warning-color);
        }

        .security-alerts-title-group h3 {
          font-size: 1.1rem;
          font-weight: 700;
          color: var(--text-primary);
          margin: 0;
        }

        .alerts-count-badge {
          background-color: var(--danger-color);
          color: #fff;
          font-size: 0.75rem;
          font-weight: 700;
          padding: 0.15rem 0.55rem;
          border-radius: 20px;
        }

        .security-alerts-subtext {
          font-size: 0.8rem;
          color: var(--text-secondary);
        }

        .security-alerts-grid {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
          gap: 1rem;
        }

        .security-alert-card {
          background-color: var(--bg-primary);
          border: 1px solid var(--border-color);
          border-radius: 10px;
          padding: 1rem;
          display: flex;
          flex-direction: column;
          justify-content: space-between;
        }

        .security-alert-top {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 0.5rem;
        }

        .alert-type {
          font-weight: 600;
          font-size: 0.9rem;
          color: var(--text-primary);
        }

        .alert-risk-tag {
          font-size: 0.7rem;
          font-weight: 700;
          padding: 0.15rem 0.5rem;
          border-radius: 6px;
        }

        .alert-description {
          font-size: 0.825rem;
          color: var(--text-secondary);
          margin: 0 0 0.75rem 0;
          line-height: 1.4;
        }

        .alert-meta {
          display: flex;
          gap: 1rem;
          font-size: 0.75rem;
          color: var(--text-secondary);
          margin-bottom: 0.75rem;
        }

        .alert-meta span {
          display: flex;
          align-items: center;
          gap: 0.25rem;
        }

        .alert-action-row {
          display: flex;
          justify-content: space-between;
          align-items: center;
          border-top: 1px dashed var(--border-color);
          padding-top: 0.6rem;
        }

        .alert-user-id {
          font-size: 0.75rem;
          font-weight: 600;
          color: var(--text-primary);
          display: flex;
          align-items: center;
          gap: 0.25rem;
        }

        .alert-details-btn {
          background: transparent;
          border: none;
          color: var(--primary-color);
          font-size: 0.8rem;
          font-weight: 600;
          cursor: pointer;
          display: flex;
          align-items: center;
          gap: 0.1rem;
          padding: 0;
        }

        .alert-details-btn:hover {
          text-decoration: underline;
        }
      `}</style>
    </div>
  );
};