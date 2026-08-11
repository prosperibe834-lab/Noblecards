import React from 'react';

const UserStats = ({ stats }) => {
  const statItems = [
    {
      id: "total",
      title: "Total Users",
      value: stats.totalUsers.count.toLocaleString(),
      change: stats.totalUsers.change,
      isPositive: stats.totalUsers.isPositive,
      period: stats.totalUsers.period,
      icon: "bx-group",
      bg: "rgba(16, 185, 129, 0.12)",
      color: "#10B981",
    },
    {
      id: "active",
      title: "Active Users",
      value: stats.activeUsers.count.toLocaleString(),
      change: stats.activeUsers.change,
      isPositive: stats.activeUsers.isPositive,
      period: stats.activeUsers.period,
      icon: "bx-user-check",
      bg: "rgba(37, 99, 235, 0.12)",
      color: "#2563EB",
    },
    {
      id: "new",
      title: "New Users Today",
      value: stats.newUsersToday.count.toLocaleString(),
      change: stats.newUsersToday.change,
      isPositive: stats.newUsersToday.isPositive,
      period: stats.newUsersToday.period,
      icon: "bx-user-plus",
      bg: "rgba(245, 158, 11, 0.12)",
      color: "#F59E0B",
    },
    {
      id: "pending",
      title: "Pending Verification",
      value: stats.pendingVerification.count.toLocaleString(),
      change: stats.pendingVerification.change,
      isPositive: stats.pendingVerification.isPositive,
      period: stats.pendingVerification.period,
      icon: "bx-time-five",
      bg: "rgba(124, 58, 237, 0.12)",
      color: "#7C3AED",
    },
    {
      id: "suspended",
      title: "Suspended Users",
      value: stats.suspendedUsers.count.toLocaleString(),
      change: stats.suspendedUsers.change,
      isPositive: stats.suspendedUsers.isPositive,
      period: stats.suspendedUsers.period,
      icon: "bx-user-x",
      bg: "rgba(239, 68, 68, 0.12)",
      color: "#EF4444",
    },
  ];

  return (
    <div className="users-stats-grid">
      {statItems.map((item) => (
        <div key={item.id} className="user-stat-card">
          <div className="user-stat-header">
            <div
              className="user-stat-icon-box"
              style={{ backgroundColor: item.bg, color: item.color }}
            >
              <i className={`bx ${item.icon}`}></i>
            </div>
          </div>

          <div>
            <span className="user-stat-title">{item.title}</span>
            <h2 className="user-stat-value">{item.value}</h2>
          </div>

          <div className="user-stat-footer">
            <span
              style={{
                color: item.isPositive ? 'var(--success)' : 'var(--error)',
                fontWeight: 700,
                display: 'flex',
                alignItems: 'center',
              }}
            >
              <i className={`bx ${item.isPositive ? 'bx-up-arrow-alt' : 'bx-down-arrow-alt'}`}></i>
              {item.change}
            </span>
            <span style={{ color: 'var(--secondary-text)' }}>vs {item.period}</span>
          </div>
        </div>
      ))}
    </div>
  );
};

export default UserStats;