import React from 'react';

const getStatusBadge = (status) => {
  switch (status) {
    case 'Completed':
      return <span className="status-badge success"><i className="bx bx-check-circle"></i> Completed</span>;
    case 'Pending':
      return <span className="status-badge warning"><i className="bx bx-time-five"></i> Pending</span>;
    case 'Processing':
      return <span className="status-badge info"><i className="bx bx-loader-circle bx-spin"></i> Processing</span>;
    case 'Failed':
      return <span className="status-badge danger"><i className="bx bx-x-circle"></i> Failed</span>;
    case 'Cancelled':
      return <span className="status-badge neutral"><i className="bx bx-block"></i> Cancelled</span>;
    case 'Reversed':
      return <span className="status-badge purple"><i className="bx bx-undo"></i> Reversed</span>;
    default:
      return <span className="status-badge neutral">{status}</span>;
  }
};

const getMethodIcon = (method) => {
  switch (method) {
    case 'Bank Transfer': return 'bx-building-house';
    case 'Card': return 'bx-credit-card';
    case 'Crypto': return 'bx-bitcoin';
    case 'Payment Providers': return 'bx-transfer-alt';
    default: return 'bx-wallet';
  }
};

export const DepositTable = ({
  deposits,
  sortConfig,
  onSort,
  onViewDetails,
  onViewUser,
  currentPage,
  pageSize,
  totalItems,
  onPageChange,
  onPageSizeChange
}) => {
  const totalPages = Math.ceil(totalItems / pageSize) || 1;
  const startItem = totalItems === 0 ? 0 : (currentPage - 1) * pageSize + 1;
  const endItem = Math.min(currentPage * pageSize, totalItems);

  const getSortIcon = (columnKey) => {
    if (sortConfig.key !== columnKey) return <i className="bx bx-hash sort-inactive"></i>;
    return sortConfig.direction === 'asc' ? <i className="bx bx-sort-up sort-active"></i> : <i className="bx bx-sort-down sort-active"></i>;
  };

  return (
    <div className="deposit-table-wrapper">
      <div className="table-responsive">
        <table className="deposit-table">
          <thead>
            <tr>
              <th onClick={() => onSort('id')} className="sortable-th">
                Deposit ID {getSortIcon('id')}
              </th>
              <th onClick={() => onSort('userName')} className="sortable-th">
                User {getSortIcon('userName')}
              </th>
              <th onClick={() => onSort('originalAmount')} className="sortable-th text-right">
                Original Amt {getSortIcon('originalAmount')}
              </th>
              <th onClick={() => onSort('usdValue')} className="sortable-th text-right">
                USD Value {getSortIcon('usdValue')}
              </th>
              <th>Method & Provider</th>
              <th className="text-right">Fee</th>
              <th onClick={() => onSort('netAmount')} className="sortable-th text-right">
                Net Amt {getSortIcon('netAmount')}
              </th>
              <th onClick={() => onSort('status')} className="sortable-th">
                Status {getSortIcon('status')}
              </th>
              <th onClick={() => onSort('createdAt')} className="sortable-th">
                Date {getSortIcon('createdAt')}
              </th>
              <th className="text-center">Actions</th>
            </tr>
          </thead>
          <tbody>
            {deposits.map((item) => (
              <tr key={item.id} className="deposit-row">
                <td className="deposit-id-cell">
                  <span className="id-code">{item.id}</span>
                  {item.reconciliation?.status === 'Mismatch' && (
                    <span className="mismatch-pill" title="Reconciliation Mismatch!">
                      <i className="bx bx-error"></i> Mismatch
                    </span>
                  )}
                </td>
                <td className="user-cell">
                  <div className="user-flex" onClick={() => onViewUser(item.userId)}>
                    <img src={item.avatar} alt={item.userName} className="user-avatar" />
                    <div className="user-info">
                      <span className="user-name">{item.userName}</span>
                      <span className="user-meta">{item.userTag} • {item.userId}</span>
                    </div>
                  </div>
                </td>
                <td className="text-right original-amt-cell">
                  <strong>{item.originalAmount.toLocaleString()}</strong> <span className="currency-tag">{item.currency}</span>
                </td>
                <td className="text-right usd-cell">
                  <strong>${item.usdValue.toFixed(2)}</strong>
                </td>
                <td className="method-cell">
                  <div className="method-pill">
                    <i className={`bx ${getMethodIcon(item.method)}`}></i>
                    <span>{item.method}</span>
                  </div>
                  <span className="provider-subtext">{item.provider}</span>
                </td>
                <td className="text-right fee-cell">
                  <span>${item.fee.toFixed(2)}</span>
                </td>
                <td className="text-right net-amt-cell">
                  <strong>${item.netAmount.toFixed(2)}</strong>
                </td>
                <td>{getStatusBadge(item.status)}</td>
                <td className="date-cell">
                  <span className="date-text">{new Date(item.createdAt).toLocaleDateString()}</span>
                  <span className="time-text">{new Date(item.createdAt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</span>
                </td>
                <td className="actions-cell text-center">
                  <button 
                    className="action-icon-btn" 
                    onClick={() => onViewDetails(item)} 
                    title="View Full Deposit Details"
                  >
                    <i className="bx bx-show"></i>
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Pagination Footer */}
      <div className="deposit-pagination-bar">
        <div className="pagination-info">
          Showing <strong>{startItem}</strong>–<strong>{endItem}</strong> of <strong>{totalItems}</strong> deposits
        </div>
        <div className="pagination-controls">
          <div className="rows-per-page">
            <label>Per page:</label>
            <select value={pageSize} onChange={(e) => onPageSizeChange(Number(e.target.value))}>
              <option value={10}>10</option>
              <option value={25}>25</option>
              <option value={50}>50</option>
              <option value={100}>100</option>
            </select>
          </div>
          <div className="page-buttons">
            <button 
              disabled={currentPage === 1} 
              onClick={() => onPageChange(currentPage - 1)}
              className="page-nav-btn"
            >
              <i className="bx bx-chevron-left"></i> Previous
            </button>
            <span className="current-page-indicator">
              Page {currentPage} of {totalPages}
            </span>
            <button 
              disabled={currentPage === totalPages} 
              onClick={() => onPageChange(currentPage + 1)}
              className="page-nav-btn"
            >
              Next <i className="bx bx-chevron-right"></i>
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};