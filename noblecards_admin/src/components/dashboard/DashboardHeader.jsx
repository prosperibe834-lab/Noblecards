import React, { useState } from 'react';

const DashboardHeader = ({ headerData, onDateRangeChange }) => {
  const [selectedRange, setSelectedRange] = useState(headerData.defaultDateRange);

  const handleDateChange = (e) => {
    if (e.target.value) {
      const formatted = `Custom Range (${e.target.value})`;
      setSelectedRange(formatted);
      if (onDateRangeChange) onDateRangeChange(e.target.value);
    }
  };

  return (
    <div className="dashboard-header-container">
      <div className="dashboard-title-group">
        <h1>Dashboard</h1>
        <p>Welcome back, Admin! Here's what's happening today.</p>
      </div>

      <div className="dashboard-header-actions">
        {/* Interactive Date Range Picker */}
        <div className="date-range-picker" title="Click to filter date range">
          <i className="bx bx-calendar"></i>
          <span>{selectedRange}</span>
          <i className="bx bx-chevron-down"></i>
          <input
            type="date"
            className="hidden-date-input"
            onChange={handleDateChange}
            aria-label="Select Date Range"
          />
        </div>

        {/* Notifications Icon Button */}
        <div className="header-icon-btn" title="View Notifications">
          <i className="bx bx-bell"></i>
          {headerData.unreadNotifications > 0 && (
            <span className="notification-badge-count">
              {headerData.unreadNotifications}
            </span>
          )}
        </div>

        {/* Admin Avatar Pill */}
        <div className="admin-profile-pill">
          <div className="admin-avatar">A</div>
          <div className="admin-info">
            <span className="admin-name">{headerData.adminName}</span>
            <span className="admin-role">{headerData.adminRole}</span>
          </div>
        </div>
      </div>
    </div>
  );
};

export default DashboardHeader;