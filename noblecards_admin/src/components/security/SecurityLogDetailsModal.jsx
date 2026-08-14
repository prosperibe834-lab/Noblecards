// ==========================================
// NEW FILE
// File: src/components/security/SecurityLogDetailsModal.jsx
// Purpose: Modal displaying complete event, user, IP, device, and audit trail metadata
// ==========================================

import React from "react";

export const SecurityLogDetailsModal = ({ log, onClose }) => {
  if (!log) return null;

  return (
    <div className="security-modal-backdrop" onClick={onClose}>
      <div className="security-modal-content" onClick={(e) => e.stopPropagation()}>
        {/* Modal Header */}
        <div className="security-modal-header">
          <div className="modal-title-group">
            <i className="bx bx-shield-quarter modal-icon"></i>
            <div>
              <h3>Security Event Details</h3>
              <span className="modal-subtitle">Log Reference ID: {log.id}</span>
            </div>
          </div>
          <button className="modal-close-btn" onClick={onClose}>
            <i className="bx bx-x"></i>
          </button>
        </div>

        {/* Modal Body */}
        <div className="security-modal-body">
          {/* Top Banner Overview */}
          <div className="event-overview-banner">
            <div className="banner-item">
              <span className="banner-label">Event Action</span>
              <span className="banner-val">{log.event}</span>
            </div>
            <div className="banner-item">
              <span className="banner-label">Status</span>
              <span className={`banner-val status-${log.status.toLowerCase()}`}>{log.status}</span>
            </div>
            <div className="banner-item">
              <span className="banner-label">Risk Level</span>
              <span className={`banner-val risk-${log.risk.toLowerCase()}`}>{log.risk}</span>
            </div>
            <div className="banner-item">
              <span className="banner-label">Actor</span>
              <span className="banner-val">{log.actor}</span>
            </div>
          </div>

          {/* Detailed Specifications Grid */}
          <div className="details-sections-grid">
            {/* 1. Identity Information */}
            <div className="details-box">
              <h4><i className="bx bx-user"></i> Identity Profile</h4>
              <div className="details-list">
                <div className="row"><span className="key">Full Name:</span><span className="val">{log.userName || log.adminName || "System Process"}</span></div>
                <div className="row"><span className="key">User ID:</span><span className="val font-mono">{log.userId || log.adminId || "N/A"}</span></div>
                <div className="row"><span className="key">Username:</span><span className="val">{log.username || "N/A"}</span></div>
                <div className="row"><span className="key">Email:</span><span className="val">{log.userEmail || "N/A"}</span></div>
                <div className="row"><span className="key">Phone:</span><span className="val">{log.userPhone || "N/A"}</span></div>
              </div>
            </div>

            {/* 2. Device & Client Environment */}
            <div className="details-box">
              <h4><i className="bx bx-devices"></i> Device & Browser Environment</h4>
              <div className="details-list">
                <div className="row"><span className="key">Device Type:</span><span className="val">{log.deviceType}</span></div>
                <div className="row"><span className="key">Operating System:</span><span className="val">{log.os}</span></div>
                <div className="row"><span className="key">Browser:</span><span className="val">{log.browser}</span></div>
                <div className="row"><span className="key">Timestamp:</span><span className="val">{log.timestamp}</span></div>
              </div>
            </div>

            {/* 3. IP Intelligence & Network Location */}
            <div className="details-box">
              <h4><i className="bx bx-globe"></i> IP Intelligence</h4>
              <div className="details-list">
                <div className="row"><span className="key">IP Address:</span><span className="val font-mono">{log.ipAddress}</span></div>
                <div className="row"><span className="key">Location:</span><span className="val">{log.city}, {log.country}</span></div>
                <div className="row"><span className="key">ISP / Provider:</span><span className="val">{log.isp}</span></div>
                <div className="row"><span className="key">VPN Detected:</span><span className="val">{log.isVpn ? "YES (Proxy Active)" : "No"}</span></div>
                <div className="row"><span className="key">TOR Exit Node:</span><span className="val">{log.isTor ? "YES (Tor Traffic)" : "No"}</span></div>
              </div>
            </div>

            {/* 4. Description & Payload Metadata */}
            <div className="details-box full-width">
              <h4><i className="bx bx-detail"></i> Description & Raw Metadata</h4>
              <p className="log-description-text">{log.description}</p>
              {log.metadata && (
                <pre className="metadata-json-box">
                  {JSON.stringify(log.metadata, null, 2)}
                </pre>
              )}
            </div>
          </div>
        </div>

        {/* Modal Footer */}
        <div className="security-modal-footer">
          <span className="immutable-notice"><i className="bx bx-lock-alt"></i> Immutable Security Record</span>
          <button className="security-btn secondary" onClick={onClose}>Close</button>
        </div>
      </div>

      <style>{`
        .security-modal-backdrop {
          position: fixed;
          top: 0; left: 0; right: 0; bottom: 0;
          background-color: rgba(0, 0, 0, 0.65);
          backdrop-filter: blur(4px);
          display: flex;
          align-items: center;
          justify-content: center;
          z-index: 9999;
          padding: 1rem;
        }

        .security-modal-content {
          background-color: var(--bg-card);
          border: 1px solid var(--border-color);
          border-radius: 14px;
          width: 100%;
          max-width: 760px;
          max-height: 90vh;
          display: flex;
          flex-direction: column;
          box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.3);
          overflow: hidden;
          animation: modalFadeIn 0.2s ease;
        }

        @keyframes modalFadeIn {
          from { opacity: 0; transform: scale(0.96); }
          to { opacity: 1; transform: scale(1); }
        }

        .security-modal-header {
          padding: 1.25rem 1.5rem;
          border-bottom: 1px solid var(--border-color);
          display: flex;
          justify-content: space-between;
          align-items: center;
          background-color: var(--bg-primary);
        }

        .modal-title-group {
          display: flex;
          align-items: center;
          gap: 0.75rem;
        }

        .modal-icon {
          font-size: 1.8rem;
          color: var(--primary-color);
        }

        .modal-title-group h3 {
          margin: 0;
          font-size: 1.15rem;
          color: var(--text-primary);
          font-weight: 700;
        }

        .modal-subtitle {
          font-size: 0.75rem;
          color: var(--text-secondary);
          font-family: monospace;
        }

        .modal-close-btn {
          background: transparent;
          border: none;
          color: var(--text-secondary);
          font-size: 1.6rem;
          cursor: pointer;
        }

        .security-modal-body {
          padding: 1.5rem;
          overflow-y: auto;
          display: flex;
          flex-direction: column;
          gap: 1.25rem;
        }

        .event-overview-banner {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(130px, 1fr));
          gap: 1rem;
          background-color: var(--bg-primary);
          padding: 1rem;
          border-radius: 10px;
          border: 1px solid var(--border-color);
        }

        .banner-item {
          display: flex;
          flex-direction: column;
        }

        .banner-label {
          font-size: 0.75rem;
          color: var(--text-secondary);
          margin-bottom: 0.2rem;
        }

        .banner-val {
          font-size: 0.95rem;
          font-weight: 700;
          color: var(--text-primary);
        }

        .banner-val.status-success { color: var(--success-color); }
        .banner-val.status-failed { color: var(--danger-color); }
        .banner-val.status-suspicious { color: var(--warning-color); }

        .banner-val.risk-critical { color: var(--danger-color); }
        .banner-val.risk-high { color: var(--warning-color); }
        .banner-val.risk-medium { color: var(--info-color); }
        .banner-val.risk-low { color: var(--success-color); }

        .details-sections-grid {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
          gap: 1rem;
        }

        .details-box {
          background-color: var(--bg-primary);
          border: 1px solid var(--border-color);
          border-radius: 10px;
          padding: 1rem;
        }

        .details-box.full-width {
          grid-column: 1 / -1;
        }

        .details-box h4 {
          margin: 0 0 0.75rem 0;
          font-size: 0.875rem;
          color: var(--primary-color);
          display: flex;
          align-items: center;
          gap: 0.4rem;
        }

        .details-list {
          display: flex;
          flex-direction: column;
          gap: 0.4rem;
          font-size: 0.825rem;
        }

        .details-list .row {
          display: flex;
          justify-content: space-between;
        }

        .details-list .key {
          color: var(--text-secondary);
        }

        .details-list .val {
          color: var(--text-primary);
          font-weight: 600;
        }

        .font-mono { font-family: monospace; }

        .log-description-text {
          font-size: 0.875rem;
          color: var(--text-primary);
          margin: 0 0 0.75rem 0;
          line-height: 1.5;
        }

        .metadata-json-box {
          background-color: var(--bg-card);
          border: 1px solid var(--border-color);
          padding: 0.75rem;
          border-radius: 6px;
          font-size: 0.75rem;
          color: var(--text-primary);
          overflow-x: auto;
          margin: 0;
        }

        .security-modal-footer {
          padding: 1rem 1.5rem;
          border-top: 1px solid var(--border-color);
          display: flex;
          justify-content: space-between;
          align-items: center;
          background-color: var(--bg-primary);
        }

        .immutable-notice {
          font-size: 0.75rem;
          color: var(--text-secondary);
          display: flex;
          align-items: center;
          gap: 0.3rem;
        }
      `}</style>
    </div>
  );
};