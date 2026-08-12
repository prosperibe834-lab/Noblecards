import React from 'react';

const WithdrawalFilters = ({ filters, onFilterChange, onResetFilters }) => {
  return (
    <div className="nc-filters-wrapper">
      <div className="nc-filters-row">
        {/* Search */}
        <div className="nc-search-box">
          <i className='bx bx-search'></i>
          <input
            type="text"
            className="nc-search-input"
            placeholder="Search by Withdrawal ID, User ID, Name, Email or Provider Ref..."
            value={filters.search}
            onChange={(e) => onFilterChange('search', e.target.value)}
          />
        </div>

        {/* Status */}
        <select 
          className="nc-filter-select"
          value={filters.status}
          onChange={(e) => onFilterChange('status', e.target.value)}
        >
          <option value="All">All Statuses</option>
          <option value="Pending">Pending</option>
          <option value="Processing">Processing</option>
          <option value="Completed">Completed</option>
          <option value="Failed">Failed</option>
          <option value="Cancelled">Cancelled</option>
          <option value="Rejected">Rejected</option>
          <option value="Reversed">Reversed</option>
        </select>

        {/* Method */}
        <select 
          className="nc-filter-select"
          value={filters.method}
          onChange={(e) => onFilterChange('method', e.target.value)}
        >
          <option value="All">All Methods</option>
          <option value="Bank Transfer">Bank Transfer</option>
          <option value="Card">Card</option>
          <option value="USDT">USDT</option>
          <option value="PayPal">PayPal</option>
          <option value="Wise">Wise</option>
        </select>

        {/* Currency */}
        <select 
          className="nc-filter-select"
          value={filters.currency}
          onChange={(e) => onFilterChange('currency', e.target.value)}
        >
          <option value="All">All Currencies</option>
          <option value="NGN">NGN (₦)</option>
          <option value="USD">USD ($)</option>
          <option value="EUR">EUR (€)</option>
          <option value="GBP">GBP (£)</option>
          <option value="USDT">USDT</option>
        </select>

        {/* Risk Level */}
        <select 
          className="nc-filter-select"
          value={filters.risk}
          onChange={(e) => onFilterChange('risk', e.target.value)}
        >
          <option value="All">All Risk Levels</option>
          <option value="Normal">Normal</option>
          <option value="Review">Review Required</option>
          <option value="High Risk">High Risk</option>
        </select>
      </div>

      <div className="nc-filters-row">
        {/* Date Presets */}
        <select 
          className="nc-filter-select"
          value={filters.dateRange}
          onChange={(e) => onFilterChange('dateRange', e.target.value)}
        >
          <option value="All">All Time</option>
          <option value="Today">Today</option>
          <option value="Last 7 Days">Last 7 Days</option>
          <option value="Last 30 Days">Last 30 Days</option>
          <option value="Custom">Custom Range</option>
        </select>

        {filters.dateRange === 'Custom' && (
          <>
            <input 
              type="date" 
              className="nc-filter-input" 
              value={filters.startDate}
              onChange={(e) => onFilterChange('startDate', e.target.value)}
            />
            <span style={{ color: 'var(--secondary-text)', fontSize: '12px' }}>to</span>
            <input 
              type="date" 
              className="nc-filter-input" 
              value={filters.endDate}
              onChange={(e) => onFilterChange('endDate', e.target.value)}
            />
          </>
        )}

        {/* Amount Bounds */}
        <input 
          type="number" 
          className="nc-filter-input" 
          placeholder="Min USD"
          style={{ width: '100px' }}
          value={filters.minAmount}
          onChange={(e) => onFilterChange('minAmount', e.target.value)}
        />
        <input 
          type="number" 
          className="nc-filter-input" 
          placeholder="Max USD"
          style={{ width: '100px' }}
          value={filters.maxAmount}
          onChange={(e) => onFilterChange('maxAmount', e.target.value)}
        />

        {/* Reset */}
        <button className="nc-btn" onClick={onResetFilters}>
          <i className='bx bx-filter-off'></i> Reset Filters
        </button>
      </div>
    </div>
  );
};

export default WithdrawalFilters;