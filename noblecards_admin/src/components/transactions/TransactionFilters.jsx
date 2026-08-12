import React, { useState } from 'react';

const TransactionFilters = ({ 
  filters, 
  onFilterChange, 
  onResetFilters, 
  searchQuery, 
  onSearchChange 
}) => {
  const [showCustomDate, setShowCustomDate] = useState(false);

  const handleDateSelect = (e) => {
    const val = e.target.value;
    setShowCustomDate(val === 'Custom Range');
    onFilterChange('dateRange', val);
  };

  return (
    <div className="tx-filter-container">
      <div className="tx-search-bar">
        <i className="bx bx-search tx-search-icon"></i>
        <input 
          type="text" 
          placeholder="Search Tx ID, User ID, Name, Email, Reference..." 
          value={searchQuery}
          onChange={(e) => onSearchChange(e.target.value)}
        />
        {searchQuery && (
          <button className="tx-clear-search" onClick={() => onSearchChange('')}>
            <i className="bx bx-x"></i>
          </button>
        )}
      </div>

      <div className="tx-filter-row">
        <div className="tx-filter-group">
          <label>Status</label>
          <select value={filters.status} onChange={(e) => onFilterChange('status', e.target.value)}>
            <option value="All">All Statuses</option>
            <option value="Successful">Successful</option>
            <option value="Pending">Pending</option>
            <option value="Processing">Processing</option>
            <option value="Failed">Failed</option>
            <option value="Cancelled">Cancelled</option>
            <option value="Refunded">Refunded</option>
            <option value="Reversed">Reversed</option>
            <option value="Disputed">Disputed</option>
            <option value="Chargeback">Chargeback</option>
          </select>
        </div>

        <div className="tx-filter-group">
          <label>Type</label>
          <select value={filters.type} onChange={(e) => onFilterChange('type', e.target.value)}>
            <option value="All">All Types</option>
            <option value="Gift Card Sale">Gift Card Sale</option>
            <option value="Gift Card Purchase">Gift Card Purchase</option>
            <option value="Deposit">Deposit</option>
            <option value="Withdrawal">Withdrawal</option>
            <option value="Refund">Refund</option>
            <option value="Fee">Fee</option>
          </select>
        </div>

        <div className="tx-filter-group">
          <label>Category</label>
          <select value={filters.category} onChange={(e) => onFilterChange('category', e.target.value)}>
            <option value="All">All Categories</option>
            <option value="Gift Cards">Gift Cards</option>
            <option value="Deposits">Deposits</option>
            <option value="Withdrawals">Withdrawals</option>
            <option value="Fees">Fees</option>
            <option value="Refunds">Refunds</option>
          </select>
        </div>

        <div className="tx-filter-group">
          <label>Currency</label>
          <select value={filters.currency} onChange={(e) => onFilterChange('currency', e.target.value)}>
            <option value="All">All Currencies</option>
            <option value="USD">USD</option>
            <option value="NGN">NGN</option>
            <option value="EUR">EUR</option>
            <option value="GBP">GBP</option>
            <option value="USDT">USDT</option>
          </select>
        </div>

        <div className="tx-filter-group">
          <label>Payment Method</label>
          <select value={filters.paymentMethod} onChange={(e) => onFilterChange('paymentMethod', e.target.value)}>
            <option value="All">All Methods</option>
            <option value="Bank Transfer">Bank Transfer</option>
            <option value="Card">Card</option>
            <option value="USDT">USDT / Crypto</option>
            <option value="Gift Card">Gift Card</option>
            <option value="PayPal">PayPal</option>
            <option value="Wise">Wise</option>
          </select>
        </div>

        <div className="tx-filter-group">
          <label>Date Range</label>
          <select value={filters.dateRange} onChange={handleDateSelect}>
            <option value="All">All Time</option>
            <option value="Today">Today</option>
            <option value="Yesterday">Yesterday</option>
            <option value="Last 7 Days">Last 7 Days</option>
            <option value="Last 30 Days">Last 30 Days</option>
            <option value="This Month">This Month</option>
            <option value="Custom Range">Custom Range</option>
          </select>
        </div>

        <div className="tx-filter-group tx-amount-group">
          <label>Min / Max ($)</label>
          <div className="tx-amount-inputs">
            <input 
              type="number" 
              placeholder="Min" 
              value={filters.minAmount} 
              onChange={(e) => onFilterChange('minAmount', e.target.value)} 
            />
            <span>-</span>
            <input 
              type="number" 
              placeholder="Max" 
              value={filters.maxAmount} 
              onChange={(e) => onFilterChange('maxAmount', e.target.value)} 
            />
          </div>
        </div>

        <div className="tx-filter-group tx-reset-group">
          <button className="gc-btn gc-btn-secondary" onClick={onResetFilters}>
            <i className="bx bx-reset"></i> Reset
          </button>
        </div>
      </div>

      {showCustomDate && (
        <div className="tx-custom-date-picker">
          <div className="tx-filter-group">
            <label>From Date</label>
            <input 
              type="date" 
              value={filters.customFrom} 
              onChange={(e) => onFilterChange('customFrom', e.target.value)} 
            />
          </div>
          <div className="tx-filter-group">
            <label>To Date</label>
            <input 
              type="date" 
              value={filters.customTo} 
              onChange={(e) => onFilterChange('customTo', e.target.value)} 
            />
          </div>
        </div>
      )}
    </div>
  );
};

export default TransactionFilters;