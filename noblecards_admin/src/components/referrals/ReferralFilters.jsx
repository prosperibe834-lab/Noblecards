import React from 'react';

const ReferralFilters = ({ 
  search, setSearch, 
  status, setStatus, 
  country, setCountry, 
  rewardStatus, setRewardStatus,
  dateRange, setDateRange,
  customStart, setCustomStart,
  customEnd, setCustomEnd,
  onClear
}) => {
  return (
    <div className="ref-filters-wrapper">
      {/* Search Input */}
      <div className="ref-search-box">
        <i className='bx bx-search'></i>
        <input 
          type="text" 
          placeholder="Search Referrer, Referred User, Code, ID..." 
          value={search}
          onChange={(e) => setSearch(e.target.value)}
        />
      </div>

      {/* Date Range Selector */}
      <select className="ref-select-input" value={dateRange} onChange={(e) => setDateRange(e.target.value)}>
        <option value="All Time">All Time</option>
        <option value="Today">Today</option>
        <option value="Yesterday">Yesterday</option>
        <option value="Last 7 Days">Last 7 Days</option>
        <option value="Last 30 Days">Last 30 Days</option>
        <option value="Custom">Custom Range</option>
      </select>

      {/* Custom Date Pickers */}
      {dateRange === 'Custom' && (
        <div style={{ display: 'flex', gap: '8px', alignItems: 'center' }}>
          <input 
            type="date" 
            className="ref-select-input" 
            value={customStart} 
            onChange={(e) => setCustomStart(e.target.value)} 
          />
          <span style={{ fontSize: '12px', color: 'var(--text-secondary)' }}>to</span>
          <input 
            type="date" 
            className="ref-select-input" 
            value={customEnd} 
            onChange={(e) => setCustomEnd(e.target.value)} 
          />
        </div>
      )}

      {/* Status Dropdown */}
      <select className="ref-select-input" value={status} onChange={(e) => setStatus(e.target.value)}>
        <option value="All">All Referral Statuses</option>
        <option value="Qualified">Qualified</option>
        <option value="Qualification Pending">Qualification Pending</option>
        <option value="Deposit Pending">Deposit Pending</option>
        <option value="Suspicious">Suspicious</option>
      </select>

      {/* Country Dropdown */}
      <select className="ref-select-input" value={country} onChange={(e) => setCountry(e.target.value)}>
        <option value="All">All Countries</option>
        <option value="Nigeria">Nigeria</option>
        <option value="Ghana">Ghana</option>
        <option value="United States">United States</option>
      </select>

      {/* Reward Status Dropdown */}
      <select className="ref-select-input" value={rewardStatus} onChange={(e) => setRewardStatus(e.target.value)}>
        <option value="All">All Reward Statuses</option>
        <option value="Paid">Paid</option>
        <option value="Pending">Pending</option>
        <option value="Held">Held</option>
      </select>

      {/* Clear Button */}
      <button className="ref-btn ref-btn-outline" onClick={onClear}>
        <i className='bx bx-x'></i> Clear
      </button>
    </div>
  );
};

export default ReferralFilters;