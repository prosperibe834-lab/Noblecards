// ==========================================
// NEW FILE
// File: src/components/security/SecurityFilters.jsx
// Purpose: Multi-filter control bar for searching, filtering, and resetting audit logs
// ==========================================

import React from "react";

export const SecurityFilters = ({ filters, onFilterChange, onRefresh, onReset, isRefreshing, isLive }) => {
  return (
    <div className="security-filters-wrapper">
      <div className="security-filters-top">
        {/* Search Field */}
        <div className="security-search-box">
          <i className="bx bx-search search-icon"></i>
          <input
            type="text"
            placeholder="Search name, IP, User ID, event, admin..."
            value={filters.search}
            onChange={(e) => onFilterChange("search", e.target.value)}
          />
          {filters.search && (
            <button className="clear-search-btn" onClick={() => onFilterChange("search", "")}>
              <i className="bx bx-x"></i>
            </button>
          )}
        </div>

        {/* Action Controls */}
        <div className="security-actions-group">
          <div className={`live-monitor-pill ${isLive ? "active" : ""}`}>
            <span className="live-dot"></span>
            <span className="live-text">Live Audit Stream</span>
          </div>

          <button className="security-btn secondary" onClick={onRefresh} disabled={isRefreshing}>
            <i className={`bx bx-refresh ${isRefreshing ? "bx-spin" : ""}`}></i>
            <span>Refresh</span>
          </button>

          <button className="security-btn outline" onClick={onReset} title="Reset Filters">
            <i className="bx bx-reset"></i>
            <span>Reset</span>
          </button>
        </div>
      </div>

      {/* Dropdown Filters Row */}
      <div className="security-filters-grid">
        {/* Date Range Selector */}
        <div className="filter-item">
          <label>Date Range</label>
          <select value={filters.dateRange} onChange={(e) => onFilterChange("dateRange", e.target.value)}>
            <option value="ALL">All Time</option>
            <option value="TODAY">Today</option>
            <option value="YESTERDAY">Yesterday</option>
            <option value="LAST_7_DAYS">Last 7 Days</option>
            <option value="LAST_30_DAYS">Last 30 Days</option>
            <option value="THIS_MONTH">This Month</option>
            <option value="LAST_MONTH">Last Month</option>
            <option value="CUSTOM">Custom Range</option>
          </select>
        </div>

        {/* Event Type */}
        <div className="filter-item">
          <label>Event Type</label>
          <select value={filters.eventType} onChange={(e) => onFilterChange("eventType", e.target.value)}>
            <option value="ALL">All Types</option>
            <option value="Login">Login / Auth</option>
            <option value="Logout">Logout</option>
            <option value="Password">Password</option>
            <option value="PIN">Transaction PIN</option>
            <option value="Account">Account Security</option>
            <option value="Withdrawal">Withdrawal</option>
            <option value="Gift Card">Gift Cards</option>
            <option value="KYC">KYC</option>
            <option value="Admin">Admin Actions</option>
            <option value="Notification">Notifications</option>
            <option value="API">API Events</option>
            <option value="System">System Events</option>
          </select>
        </div>

        {/* Status */}
        <div className="filter-item">
          <label>Status</label>
          <select value={filters.status} onChange={(e) => onFilterChange("status", e.target.value)}>
            <option value="ALL">All Statuses</option>
            <option value="Success">Success</option>
            <option value="Failed">Failed</option>
            <option value="Blocked">Blocked</option>
            <option value="Suspicious">Suspicious</option>
          </select>
        </div>

        {/* Risk Level */}
        <div className="filter-item">
          <label>Risk Level</label>
          <select value={filters.risk} onChange={(e) => onFilterChange("risk", e.target.value)}>
            <option value="ALL">All Risks</option>
            <option value="Low">Low</option>
            <option value="Medium">Medium</option>
            <option value="High">High</option>
            <option value="Critical">Critical</option>
          </select>
        </div>

        {/* Actor */}
        <div className="filter-item">
          <label>Actor</label>
          <select value={filters.actor} onChange={(e) => onFilterChange("actor", e.target.value)}>
            <option value="ALL">All Actors</option>
            <option value="User">User</option>
            <option value="Admin">Admin</option>
            <option value="System">System</option>
            <option value="API">API</option>
          </select>
        </div>

        {/* Country */}
        <div className="filter-item">
          <label>Country</label>
          <select value={filters.country} onChange={(e) => onFilterChange("country", e.target.value)}>
            <option value="ALL">All Countries</option>
            <option value="Nigeria">Nigeria</option>
            <option value="Germany">Germany</option>
            <option value="United States">United States</option>
            <option value="Internal">Internal Server</option>
          </select>
        </div>

        {/* Device */}
        <div className="filter-item">
          <label>Device</label>
          <select value={filters.device} onChange={(e) => onFilterChange("device", e.target.value)}>
            <option value="ALL">All Devices</option>
            <option value="Mobile">Mobile</option>
            <option value="Desktop">Desktop</option>
            <option value="Server">Server</option>
            <option value="API Client">API Client</option>
          </select>
        </div>
      </div>

      {/* Custom Date Input Bar if Selected */}
      {filters.dateRange === "CUSTOM" && (
        <div className="custom-date-row">
          <div className="custom-date-input">
            <label>Start Date</label>
            <input
              type="date"
              value={filters.startDate}
              onChange={(e) => onFilterChange("startDate", e.target.value)}
            />
          </div>
          <div className="custom-date-input">
            <label>End Date</label>
            <input type="date" value={filters.endDate} onChange={(e) => onFilterChange("endDate", e.target.value)} />
          </div>
        </div>
      )}

      <style>{`
        .security-filters-wrapper {
          background-color: var(--bg-card);
          border: 1px solid var(--border-color);
          border-radius: 12px;
          padding: 1.25rem;
          margin-bottom: 1.5rem;
        }

        .security-filters-top {
          display: flex;
          gap: 1rem;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 1rem;
          flex-wrap: wrap;
        }

        .security-search-box {
          position: relative;
          flex: 1;
          min-width: 280px;
        }

        .security-search-box .search-icon {
          position: absolute;
          left: 12px;
          top: 50%;
          transform: translateY(-50%);
          color: var(--text-secondary);
          font-size: 1.1rem;
        }

        .security-search-box input {
          width: 100%;
          padding: 0.65rem 2.2rem 0.65rem 2.4rem;
          background-color: var(--bg-primary);
          border: 1px solid var(--border-color);
          border-radius: 8px;
          color: var(--text-primary);
          font-size: 0.875rem;
          outline: none;
          transition: border-color 0.2s ease;
        }

        .security-search-box input:focus {
          border-color: var(--primary-color);
        }

        .clear-search-btn {
          position: absolute;
          right: 10px;
          top: 50%;
          transform: translateY(-50%);
          background: transparent;
          border: none;
          color: var(--text-secondary);
          cursor: pointer;
          font-size: 1.1rem;
        }

        .security-actions-group {
          display: flex;
          align-items: center;
          gap: 0.75rem;
        }

        .live-monitor-pill {
          display: flex;
          align-items: center;
          gap: 0.4rem;
          padding: 0.4rem 0.75rem;
          border-radius: 20px;
          background-color: rgba(16, 185, 129, 0.1);
          border: 1px solid rgba(16, 185, 129, 0.2);
        }

        .live-dot {
          width: 8px;
          height: 8px;
          border-radius: 50%;
          background-color: var(--primary-green);
          box-shadow: 0 0 8px var(--primary-green);
        }

        .live-text {
          font-size: 0.75rem;
          font-weight: 600;
          color: var(--primary-green);
        }

        .security-btn {
          display: flex;
          align-items: center;
          gap: 0.4rem;
          padding: 0.6rem 1rem;
          border-radius: 8px;
          font-size: 0.85rem;
          font-weight: 600;
          cursor: pointer;
          transition: background 0.2s ease, transform 0.1s ease;
          border: 1px solid transparent;
        }

        .security-btn.secondary {
          background-color: var(--bg-primary);
          border-color: var(--border-color);
          color: var(--text-primary);
        }

        .security-btn.secondary:hover {
          background-color: var(--bg-hover);
        }

        .security-btn.outline {
          background-color: transparent;
          border-color: var(--border-color);
          color: var(--text-secondary);
        }

        .security-btn.outline:hover {
          color: var(--text-primary);
        }

        .security-filters-grid {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(130px, 1fr));
          gap: 0.75rem;
        }

        .filter-item {
          display: flex;
          flex-direction: column;
          gap: 0.3rem;
        }

        .filter-item label {
          font-size: 0.75rem;
          font-weight: 600;
          color: var(--text-secondary);
        }

        .filter-item select {
          padding: 0.5rem;
          background-color: var(--bg-primary);
          border: 1px solid var(--border-color);
          border-radius: 6px;
          color: var(--text-primary);
          font-size: 0.825rem;
          outline: none;
          cursor: pointer;
        }

        .custom-date-row {
          display: flex;
          gap: 1rem;
          margin-top: 1rem;
          padding-top: 0.75rem;
          border-top: 1px dashed var(--border-color);
        }

        .custom-date-input {
          display: flex;
          flex-direction: column;
          gap: 0.25rem;
        }

        .custom-date-input label {
          font-size: 0.75rem;
          font-weight: 600;
          color: var(--text-secondary);
        }

        .custom-date-input input {
          padding: 0.45rem;
          background-color: var(--bg-primary);
          border: 1px solid var(--border-color);
          border-radius: 6px;
          color: var(--text-primary);
          font-size: 0.825rem;
        }
      `}</style>
    </div>
  );
};