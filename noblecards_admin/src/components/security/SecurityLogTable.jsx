// ==========================================
// NEW FILE
// File: src/components/security/SecurityLogTable.jsx
// Purpose: Responsive Security Audit Log Table & Mobile Card View
// ==========================================

import React from "react";

export const SecurityLogTable = ({ logs = [], onViewDetails }) => {
  const getRiskBadge = (risk) => {
    switch ((risk || "low").toUpperCase()) {
      case "CRITICAL":
        return <span className="risk-badge critical">CRITICAL</span>;
      case "HIGH":
        return <span className="risk-badge high">HIGH</span>;
      case "MEDIUM":
        return <span className="risk-badge medium">MEDIUM</span>;
      default:
        return <span className="risk-badge low">LOW</span>;
    }
  };

  const getStatusBadge = (status) => {
    switch ((status || "default").toLowerCase()) {
      case "success":
        return <span className="status-badge success"><i className="bx bx-check"></i> Success</span>;
      case "failed":
        return <span className="status-badge failed"><i className="bx bx-x"></i> Failed</span>;
      case "blocked":
        return <span className="status-badge blocked"><i className="bx bx-block"></i> Blocked</span>;
      case "suspicious":
        return <span className="status-badge suspicious"><i className="bx bx-error-alt"></i> Suspicious</span>;
      default:
        return <span className="status-badge default">{status || "Unknown"}</span>;
    }
  };

  const getActorTag = (actor) => {
    switch ((actor || "user").toLowerCase()) {
      case "admin":
        return <span className="actor-tag admin"><i className="bx bx-shield-alt-2"></i> Admin</span>;
      case "system":
        return <span className="actor-tag system"><i className="bx bx-cog"></i> System</span>;
      case "api":
        return <span className="actor-tag api"><i className="bx bx-code-alt"></i> API</span>;
      default:
        return <span className="actor-tag user"><i className="bx bx-user"></i> User</span>;
    }
  };

  return (
    <div className="security-table-wrapper">
      {/* Desktop Table View */}
      <div className="desktop-table-container">
        <table className="security-audit-table">
          <thead>
            <tr>
              <th>Time</th>
              <th>Event</th>
              <th>User / Admin</th>
              <th>User ID</th>
              <th>IP Address</th>
              <th>Device</th>
              <th>Location</th>
              <th>Actor</th>
              <th>Status</th>
              <th>Risk</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            {logs.map((log) => {
              const timeParts = (log.timestamp || "").split(" ");
              const date = timeParts[0] || "N/A";
              const time = timeParts[1] || "";

              return (
                <tr key={log.id}>
                  <td className="time-cell">
                    <span className="main-text">{time}</span>
                    <span className="sub-text">{date}</span>
                  </td>

                  <td className="event-cell">
                    <strong className="main-text">{log.event || "Unknown Event"}</strong>
                    <span className="sub-text">{log.eventType || "N/A"}</span>
                  </td>

                  <td className="user-cell">
                    <span className="main-text">{log.userName || log.adminName || "System / Automated"}</span>
                    <span className="sub-text">{log.userEmail || log.adminId || "Internal"}</span>
                  </td>

                  <td className="id-cell">{log.userId || log.adminId || "N/A"}</td>

                  <td className="ip-cell">
                    <code>{log.ipAddress || "Unknown"}</code>
                    {log.isVpn && <span className="ip-flag vpn">VPN</span>}
                    {log.isTor && <span className="ip-flag tor">TOR</span>}
                  </td>

                  <td className="device-cell">
                    <span className="main-text">{log.deviceType || "Unknown"}</span>
                    <span className="sub-text">{log.os || "Unknown OS"}</span>
                  </td>

                  <td className="location-cell">
                    {log.city || "Unknown"}, {log.country || "Unknown"}
                  </td>

                  <td>{getActorTag(log.actor)}</td>

                  <td>{getStatusBadge(log.status)}</td>

                  <td>{getRiskBadge(log.risk)}</td>

                  <td>
                    <button className="view-log-btn" onClick={() => onViewDetails(log)}>
                      View
                    </button>
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>

      {/* Mobile Card List View */}
      <div className="mobile-card-container">
        {logs.map((log) => (
          <div key={log.id} className="security-mobile-card">
            <div className="mobile-card-header">
              <div>
                <strong>{log.event || "Unknown Event"}</strong>
                <span className="mobile-timestamp">{log.timestamp || "N/A"}</span>
              </div>
              {getRiskBadge(log.risk)}
            </div>

            <div className="mobile-card-body">
              <div className="mobile-meta-item">
                <span className="label">Actor / Target:</span>
                <span className="val">{log.userName || log.adminName || "System"} ({log.userId || log.adminId || "N/A"})</span>
              </div>

              <div className="mobile-meta-item">
                <span className="label">IP & Location:</span>
                <span className="val"><code>{log.ipAddress || "Unknown"}</code> - {log.city || "Unknown"}, {log.country || "Unknown"}</span>
              </div>

              <div className="mobile-meta-item">
                <span className="label">Device:</span>
                <span className="val">{log.deviceType || "Unknown"} · {log.browser || "Unknown"}</span>
              </div>

              <div className="mobile-meta-row">
                <div>{getActorTag(log.actor)}</div>
                <div>{getStatusBadge(log.status)}</div>
              </div>
            </div>

            <div className="mobile-card-footer">
              <button className="mobile-view-btn" onClick={() => onViewDetails(log)}>
                <i className="bx bx-show"></i> Inspect Full Event Details
              </button>
            </div>
          </div>
        ))}
      </div>

      <style>{`
        .security-table-wrapper {
          background-color: var(--bg-card, #ffffff);
          border: 1px solid var(--border-color, #e2e8f0);
          border-radius: 12px;
          overflow: hidden;
        }

        .desktop-table-container {
          overflow-x: auto;
          -webkit-overflow-scrolling: touch;
        }

        .security-audit-table {
          width: 100%;
          min-width: 1000px; /* Prevents columns from squishing on medium screens */
          border-collapse: collapse;
          text-align: left;
          font-size: 0.85rem;
        }

        .security-audit-table th {
          background-color: var(--bg-primary, #f8fafc);
          color: var(--text-secondary, #64748b);
          font-weight: 600;
          padding: 0.85rem 1rem;
          border-bottom: 1px solid var(--border-color, #e2e8f0);
          white-space: nowrap;
          font-size: 0.75rem;
          text-transform: uppercase;
          letter-spacing: 0.5px;
        }

        .security-audit-table td {
          padding: 0.85rem 1rem;
          border-bottom: 1px solid var(--border-color, #e2e8f0);
          color: var(--text-primary, #0f172a);
          vertical-align: top;
          white-space: nowrap;
        }

        .security-audit-table tbody tr:hover {
          background-color: var(--bg-hover, #f1f5f9);
        }

        /* Replaced flexbox with block displays to preserve table layout */
        .main-text {
          display: block;
          margin-bottom: 0.2rem;
        }

        .sub-text {
          display: block;
          font-size: 0.75rem;
          color: var(--text-secondary, #64748b);
        }

        .id-cell {
          font-weight: 600;
          font-family: monospace;
        }

        .ip-cell code {
          background: var(--bg-primary, #f8fafc);
          padding: 0.2rem 0.4rem;
          border-radius: 4px;
          border: 1px solid var(--border-color, #e2e8f0);
          font-size: 0.8rem;
          display: inline-block;
          margin-bottom: 0.2rem;
        }

        .ip-flag {
          font-size: 0.65rem;
          font-weight: 700;
          padding: 0.1rem 0.35rem;
          border-radius: 4px;
          margin-left: 0.3rem;
          display: inline-block;
        }

        .ip-flag.vpn { background: rgba(245, 158, 11, 0.2); color: var(--warning-color, #d97706); }
        .ip-flag.tor { background: rgba(239, 68, 68, 0.2); color: var(--danger-color, #dc2626); }

        /* Risk Badges */
        .risk-badge {
          font-size: 0.7rem;
          font-weight: 700;
          padding: 0.25rem 0.6rem;
          border-radius: 20px;
          display: inline-block;
          text-align: center;
          min-width: 60px;
        }

        .risk-badge.low { background: rgba(34, 197, 94, 0.15); color: var(--success-color, #16a34a); }
        .risk-badge.medium { background: rgba(59, 130, 246, 0.15); color: var(--info-color, #2563eb); }
        .risk-badge.high { background: rgba(245, 158, 11, 0.15); color: var(--warning-color, #d97706); }
        .risk-badge.critical { background: rgba(239, 68, 68, 0.2); color: var(--danger-color, #dc2626); }

        /* Status Badges */
        .status-badge {
          font-size: 0.75rem;
          font-weight: 600;
          display: inline-flex;
          align-items: center;
          gap: 0.25rem;
          padding: 0.2rem 0.5rem;
          border-radius: 6px;
        }

        .status-badge.success { background: rgba(34, 197, 94, 0.1); color: var(--success-color, #16a34a); }
        .status-badge.failed { background: rgba(239, 68, 68, 0.1); color: var(--danger-color, #dc2626); }
        .status-badge.blocked { background: rgba(100, 116, 139, 0.15); color: var(--text-secondary, #64748b); }
        .status-badge.suspicious { background: rgba(245, 158, 11, 0.15); color: var(--warning-color, #d97706); }

        /* Actor Badges */
        .actor-tag {
          font-size: 0.75rem;
          font-weight: 600;
          display: inline-flex;
          align-items: center;
          gap: 0.25rem;
          padding: 0.2rem 0.5rem;
          border-radius: 6px;
          border: 1px solid var(--border-color, #e2e8f0);
        }

        .actor-tag.admin { background: rgba(16, 185, 129, 0.1); color: var(--primary-green, #059669); }
        .actor-tag.user { background: rgba(37, 99, 235, 0.1); color: var(--primary-color, #2563eb); }
        .actor-tag.system { background: rgba(100, 116, 139, 0.1); color: var(--text-secondary, #64748b); }
        .actor-tag.api { background: rgba(245, 158, 11, 0.1); color: var(--accent-gold, #d97706); }

        .view-log-btn {
          background-color: var(--bg-primary, #f8fafc);
          border: 1px solid var(--border-color, #e2e8f0);
          color: var(--primary-color, #2563eb);
          padding: 0.35rem 0.75rem;
          border-radius: 6px;
          font-weight: 600;
          font-size: 0.8rem;
          cursor: pointer;
          transition: all 0.2s ease;
        }

        .view-log-btn:hover {
          background-color: var(--primary-color, #2563eb);
          color: #fff;
        }

        /* Mobile Layout */
        .mobile-card-container {
          display: none;
          padding: 0.75rem;
          flex-direction: column;
          gap: 0.75rem;
        }

        .security-mobile-card {
          background-color: var(--bg-primary, #ffffff);
          border: 1px solid var(--border-color, #e2e8f0);
          border-radius: 10px;
          padding: 0.85rem;
        }

        .mobile-card-header {
          display: flex;
          justify-content: space-between;
          align-items: flex-start;
          margin-bottom: 0.6rem;
        }

        .mobile-timestamp {
          font-size: 0.75rem;
          color: var(--text-secondary, #64748b);
          display: block;
          margin-top: 0.2rem;
        }

        .mobile-card-body {
          display: flex;
          flex-direction: column;
          gap: 0.5rem;
          font-size: 0.8rem;
          margin-bottom: 0.75rem;
        }

        .mobile-meta-item {
          display: flex;
          justify-content: space-between;
          border-bottom: 1px dashed var(--border-color, #e2e8f0);
          padding-bottom: 0.4rem;
        }

        .mobile-meta-item:last-child {
          border-bottom: none;
        }

        .mobile-meta-item .label {
          color: var(--text-secondary, #64748b);
        }

        .mobile-meta-row {
          display: flex;
          justify-content: space-between;
          margin-top: 0.5rem;
        }

        .mobile-card-footer {
          border-top: 1px solid var(--border-color, #e2e8f0);
          padding-top: 0.75rem;
        }

        .mobile-view-btn {
          width: 100%;
          background-color: var(--bg-card, #f8fafc);
          border: 1px solid var(--border-color, #e2e8f0);
          color: var(--primary-color, #2563eb);
          padding: 0.5rem;
          border-radius: 6px;
          font-weight: 600;
          font-size: 0.85rem;
          cursor: pointer;
          display: flex;
          align-items: center;
          justify-content: center;
          gap: 0.3rem;
        }

        @media (max-width: 992px) {
          .desktop-table-container { display: none; }
          .mobile-card-container { display: flex; }
        }
      `}</style>
    </div>
  );
};