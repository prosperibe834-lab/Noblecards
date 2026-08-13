// src/components/reports/ReportControls.jsx
import React from 'react';

const ReportControls = ({ dateRange, setDateRange, reportType, setReportType, customDates, setCustomDates }) => {
  return (
    <div className="reports-controls">
      <div className="control-group">
        <label>Report Type</label>
        <select 
          className="control-select"
          value={reportType}
          onChange={(e) => setReportType(e.target.value)}
        >
          <optgroup label="Financial">
            <option value="revenue">Revenue & Fees</option>
            <option value="volume">Transaction Volume</option>
            <option value="deposits">Deposits & Withdrawals</option>
          </optgroup>
          <optgroup label="Business">
            <option value="giftcards">Gift Card Performance</option>
            <option value="users">User Analytics</option>
            <option value="referrals">Referrals</option>
            <option value="support">Support Tickets</option>
          </optgroup>
        </select>
      </div>

      <div className="control-group">
        <label>Date Range</label>
        <select 
          className="control-select"
          value={dateRange}
          onChange={(e) => setDateRange(e.target.value)}
        >
          <option value="today">Today</option>
          <option value="yesterday">Yesterday</option>
          <option value="7days">Last 7 Days</option>
          <option value="30days">Last 30 Days</option>
          <option value="thismonth">This Month</option>
          <option value="3months">Last 3 Months</option>
          <option value="6months">Last 6 Months</option>
          <option value="thisyear">This Year</option>
          <option value="custom">Custom Range</option>
        </select>
      </div>

      {dateRange === 'custom' && (
        <>
          <div className="control-group">
            <label>Start Date</label>
            <input 
              type="date" 
              className="control-input"
              value={customDates.start}
              onChange={(e) => setCustomDates({...customDates, start: e.target.value})}
            />
          </div>
          <div className="control-group">
            <label>End Date</label>
            <input 
              type="date" 
              className="control-input"
              value={customDates.end}
              onChange={(e) => setCustomDates({...customDates, end: e.target.value})}
            />
          </div>
        </>
      )}
    </div>
  );
};

export default ReportControls;