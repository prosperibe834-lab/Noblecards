import React, { useState } from 'react';

export const DepositFilters = ({
  filters,
  onFilterChange,
  onResetFilters,
  providersList
}) => {
  const [showCustomDate, setShowCustomDate] = useState(filters.datePreset === 'custom');

  const handleDatePresetChange = (e) => {
    const val = e.target.value;
    onFilterChange('datePreset', val);
    setShowCustomDate(val === 'custom');
  };

  return (
    <div className="deposit-filters-container">
      <div className="filters-primary-row">
        {/* Search Bar */}
        <div className="search-input-wrapper">
          <i className="bx bx-search search-icon"></i>
          <input
            type="text"
            placeholder="Search Deposit ID, User, Reference, Email..."
            value={filters.search}
            onChange={(e) => onFilterChange('search', e.target.value)}
            className="deposit-search-input"
          />
          {filters.search && (
            <button 
              className="clear-search-btn" 
              onClick={() => onFilterChange('search', '')}
              title="Clear Search"
            >
              <i className="bx bx-x"></i>
            </button>
          )}
        </div>

        {/* Status Dropdown */}
        <div className="filter-select-group">
          <label>Status</label>
          <select 
            value={filters.status} 
            onChange={(e) => onFilterChange('status', e.target.value)}
          >
            <option value="All">All Statuses</option>
            <option value="Pending">Pending</option>
            <option value="Processing">Processing</option>
            <option value="Completed">Completed</option>
            <option value="Failed">Failed</option>
            <option value="Cancelled">Cancelled</option>
            <option value="Reversed">Reversed</option>
          </select>
        </div>

        {/* Method Dropdown */}
        <div className="filter-select-group">
          <label>Method</label>
          <select 
            value={filters.method} 
            onChange={(e) => onFilterChange('method', e.target.value)}
          >
            <option value="All">All Methods</option>
            <option value="Bank Transfer">Bank Transfer</option>
            <option value="Card">Card</option>
            <option value="Crypto">Crypto / USDT</option>
            <option value="Payment Providers">Payment Providers</option>
          </select>
        </div>

        {/* Currency Dropdown */}
        <div className="filter-select-group">
          <label>Currency</label>
          <select 
            value={filters.currency} 
            onChange={(e) => onFilterChange('currency', e.target.value)}
          >
            <option value="All">All Currencies</option>
            <option value="USD">USD ($)</option>
            <option value="NGN">NGN (₦)</option>
            <option value="EUR">EUR (€)</option>
            <option value="GBP">GBP (£)</option>
            <option value="USDT">USDT</option>
          </select>
        </div>

        {/* Provider Filter */}
        <div className="filter-select-group">
          <label>Provider</label>
          <select 
            value={filters.provider} 
            onChange={(e) => onFilterChange('provider', e.target.value)}
          >
            <option value="All">All Providers</option>
            {providersList.map((p) => (
              <option key={p} value={p}>{p}</option>
            ))}
          </select>
        </div>
      </div>

      <div className="filters-secondary-row">
        {/* Date Preset */}
        <div className="filter-select-group">
          <label>Date Range</label>
          <select value={filters.datePreset} onChange={handleDatePresetChange}>
            <option value="all">All Time</option>
            <option value="today">Today</option>
            <option value="yesterday">Yesterday</option>
            <option value="last7">Last 7 Days</option>
            <option value="last30">Last 30 Days</option>
            <option value="custom">Custom Range</option>
          </select>
        </div>

        {/* Custom Date Inputs */}
        {showCustomDate && (
          <div className="custom-date-inputs">
            <div className="date-input-field">
              <label>From</label>
              <input
                type="date"
                value={filters.fromDate}
                onChange={(e) => onFilterChange('fromDate', e.target.value)}
              />
            </div>
            <div className="date-input-field">
              <label>To</label>
              <input
                type="date"
                value={filters.toDate}
                onChange={(e) => onFilterChange('toDate', e.target.value)}
              />
            </div>
          </div>
        )}

        {/* Amount Range */}
        <div className="amount-range-group">
          <div className="amount-input-field">
            <label>Min USD</label>
            <input
              type="number"
              placeholder="0"
              value={filters.minAmount}
              onChange={(e) => onFilterChange('minAmount', e.target.value)}
            />
          </div>
          <div className="amount-input-field">
            <label>Max USD</label>
            <input
              type="number"
              placeholder="Max"
              value={filters.maxAmount}
              onChange={(e) => onFilterChange('maxAmount', e.target.value)}
            />
          </div>
        </div>

        {/* Reset Button */}
        <button className="reset-filters-btn" onClick={onResetFilters}>
          <i className="bx bx-refresh"></i> Reset Filters
        </button>
      </div>
    </div>
  );
};