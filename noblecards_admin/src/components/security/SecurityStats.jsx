// ==========================================
// NEW FILE
// File: src/components/security/SecurityStats.jsx
// Purpose: Displays the 8 summary stats cards using theme variables
// ==========================================

import React from "react";

export const SecurityStats = ({ stats, loading }) => {
  const statItems = [
    {
      title: "Total Security Events",
      value: stats?.totalEvents ?? 0,
      icon: "bx-shield-quarter",
      color: "var(--primary-color)",
      badge: "100%",
      badgeBg: "rgba(37, 99, 235, 0.1)"
    },
    {
      title: "Successful Events",
      value: stats?.successfulEvents ?? 0,
      icon: "bx-check-circle",
      color: "var(--success-color)",
      badge: "Normal",
      badgeBg: "rgba(34, 197, 94, 0.1)"
    },
    {
      title: "Failed Events",
      value: stats?.failedEvents ?? 0,
      icon: "bx-error-circle",
      color: "var(--warning-color)",
      badge: "Attention",
      badgeBg: "rgba(245, 158, 11, 0.1)"
    },
    {
      title: "Suspicious Events",
      value: stats?.suspiciousEvents ?? 0,
      icon: "bx-alarm-exclamation",
      color: "var(--danger-color)",
      badge: "High Risk",
      badgeBg: "rgba(239, 68, 68, 0.1)"
    },
    {
      title: "Admin Actions",
      value: stats?.adminActions ?? 0,
      icon: "bx-user-voice",
      color: "var(--primary-green)",
      badge: "Audit Trail",
      badgeBg: "rgba(16, 185, 129, 0.1)"
    },
    {
      title: "User Security Events",
      value: stats?.userEvents ?? 0,
      icon: "bx-user-check",
      color: "var(--info-color)",
      badge: "Activity",
      badgeBg: "rgba(59, 130, 246, 0.1)"
    },
    {
      title: "Login Attempts",
      value: stats?.loginAttempts ?? 0,
      icon: "bx-log-in-circle",
      color: "var(--accent-gold)",
      badge: "Auth",
      badgeBg: "rgba(245, 158, 11, 0.1)"
    },
    {
      title: "Blocked Attempts",
      value: stats?.blockedAttempts ?? 0,
      icon: "bx-block",
      color: "var(--danger-color)",
      badge: "Protected",
      badgeBg: "rgba(239, 68, 68, 0.1)"
    }
  ];

  return (
    <div className="security-stats-grid">
      {statItems.map((item, index) => (
        <div key={index} className="security-stat-card">
          <div className="security-stat-header">
            <div className="security-stat-icon" style={{ backgroundColor: item.badgeBg, color: item.color }}>
              <i className={`bx ${item.icon}`}></i>
            </div>
            <span className="security-stat-badge" style={{ backgroundColor: item.badgeBg, color: item.color }}>
              {item.badge}
            </span>
          </div>
          <div className="security-stat-body">
            <span className="security-stat-title">{item.title}</span>
            <h3 className="security-stat-value">{loading ? "..." : item.value.toLocaleString()}</h3>
          </div>
        </div>
      ))}
      <style>{`
        .security-stats-grid {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
          gap: 1rem;
          margin-bottom: 1.5rem;
        }

        .security-stat-card {
          background-color: var(--bg-card);
          border: 1px solid var(--border-color);
          border-radius: 12px;
          padding: 1.25rem;
          transition: transform 0.2s ease, box-shadow 0.2s ease;
          display: flex;
          flex-direction: column;
          justify-content: space-between;
        }

        .security-stat-card:hover {
          transform: translateY(-2px);
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }

        .security-stat-header {
          display: flex;
          align-items: center;
          justify-content: space-between;
          margin-bottom: 1rem;
        }

        .security-stat-icon {
          width: 42px;
          height: 42px;
          border-radius: 10px;
          display: flex;
          align-items: center;
          justify-content: center;
          font-size: 1.4rem;
        }

        .security-stat-badge {
          font-size: 0.75rem;
          font-weight: 600;
          padding: 0.2rem 0.5rem;
          border-radius: 20px;
        }

        .security-stat-title {
          font-size: 0.85rem;
          color: var(--text-secondary);
          display: block;
          margin-bottom: 0.25rem;
          font-weight: 500;
        }

        .security-stat-value {
          font-size: 1.6rem;
          font-weight: 700;
          color: var(--text-primary);
          margin: 0;
        }
      `}</style>
    </div>
  );
};