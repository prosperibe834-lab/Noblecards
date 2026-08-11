import React from 'react';
import { countryOptions } from '../../data/usersData';

const UserFilters = ({
  searchTerm,
  setSearchTerm,
  filters,
  setFilters,
  onResetFilters,
}) => {
  return (
    <div className="users-filter-card">
      {/* Search Bar */}
      <div className="users-search-box">
        <i className="bx bx-search"></i>
        <input
          type="text"
          className="users-search-input"
          placeholder="Search users by name, username, email, phone or User ID..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
        />
      </div>

      {/* Dropdown Filters Group */}
      <div className="filter-select-group">
        {/* Status */}
        <select
          className="filter-select-control"
          value={filters.status}
          onChange={(e) => setFilters({ ...filters, status: e.target.value })}
        >
          <option value="All">All Status</option>
          <option value="Active">Active</option>
          <option value="Suspended">Suspended</option>
          <option value="Banned">Banned</option>
          <option value="Pending">Pending</option>
        </select>

        {/* KYC */}
        <select
          className="filter-select-control"
          value={filters.kycStatus}
          onChange={(e) => setFilters({ ...filters, kycStatus: e.target.value })}
        >
          <option value="All">All KYC Status</option>
          <option value="Verified">Verified</option>
          <option value="Pending">Pending</option>
          <option value="Rejected">Rejected</option>
          <option value="Not Submitted">Not Verified</option>
        </select>

        {/* Country */}
        <select
          className="filter-select-control"
          value={filters.country}
          onChange={(e) => setFilters({ ...filters, country: e.target.value })}
        >
          {countryOptions.map((c) => (
            <option key={c} value={c}>
              {c}
            </option>
          ))}
        </select>

        {/* Date Joined */}
        <select
          className="filter-select-control"
          value={filters.joinedDate}
          onChange={(e) => setFilters({ ...filters, joinedDate: e.target.value })}
        >
          <option value="All Time">All Time</option>
          <option value="Today">Today</option>
          <option value="This Week">This Week</option>
          <option value="This Month">This Month</option>
        </select>

        {/* Reset Button */}
        <button className="btn-reset-filters" onClick={onResetFilters}>
          <i className="bx bx-refresh"></i>
          <span>Reset Filters</span>
        </button>
      </div>
    </div>
  );
};

export default UserFilters;