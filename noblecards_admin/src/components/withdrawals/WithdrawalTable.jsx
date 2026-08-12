import React from 'react';

const WithdrawalTable = ({
  data,
  onSort,
  sortField,
  sortDirection,
  onSelectWithdrawal,
  onOpenActionModal,
  currentPage,
  pageSize,
  onPageChange,
  onPageSizeChange
}) => {
  const totalItems = data.length;
  const totalPages = Math.ceil(totalItems / pageSize) || 1;
  const paginatedData = data.slice((currentPage - 1) * pageSize, currentPage * pageSize);

  const getSortIcon = (field) => {
    if (sortField !== field) return <i className='bx bx-hash' style={{ opacity: 0.3 }}></i>;
    return sortDirection === 'asc' ? <i className='bx bx-chevron-up'></i> : <i className='bx bx-chevron-down'></i>;
  };

  const renderDestination = (w) => {
    if (w.method === 'Bank Transfer') return `${w.destination.bankName} (${w.destination.accountNumber})`;
    if (w.method === 'Card') return `${w.destination.cardBrand} (${w.destination.cardNumber})`;
    if (w.method === 'USDT') return `${w.destination.network} (${w.destination.walletAddress})`;
    if (w.method === 'PayPal') return w.destination.paypalEmail;
    if (w.method === 'Wise') return `Wise (${w.destination.sortCode})`;
    return 'Electronic Transfer';
  };

  return (
    <div className="nc-table-card">
      <div className="nc-table-responsive">
        <table className="nc-table">
          <thead>
            <tr>
              <th onClick={() => onSort('id')}>Withdrawal ID {getSortIcon('id')}</th>
              <th onClick={() => onSort('userName')}>User {getSortIcon('userName')}</th>
              <th onClick={() => onSort('originalAmount')}>Original Amount {getSortIcon('originalAmount')}</th>
              <th onClick={() => onSort('usdValue')}>USD Value {getSortIcon('usdValue')}</th>
              <th>Method & Destination</th>
              <th>Fees (USD)</th>
              <th onClick={() => onSort('status')}>Status {getSortIcon('status')}</th>
              <th>Risk</th>
              <th onClick={() => onSort('date')}>Date {getSortIcon('date')}</th>
              <th style={{ textAlign: 'right' }}>Action</th>
            </tr>
          </thead>
          <tbody>
            {paginatedData.map((w) => (
              <tr key={w.id}>
                <td>
                  <div style={{ fontWeight: 600 }}>{w.id}</div>
                  <div style={{ fontSize: '11px', color: 'var(--secondary-text)' }}>Ref: {w.providerReference}</div>
                </td>
                <td>
                  <div className="nc-user-info">
                    <img src={w.avatar} alt={w.userName} className="nc-user-avatar" />
                    <div>
                      <div className="nc-user-name">{w.userName}</div>
                      <div className="nc-user-id">{w.userId}</div>
                    </div>
                  </div>
                </td>
                <td>
                  <span style={{ fontWeight: 600 }}>
                    {w.currency === 'NGN' ? '₦' : w.currency === 'EUR' ? '€' : w.currency === 'GBP' ? '£' : ''}
                    {w.originalAmount.toLocaleString()} {w.currency}
                  </span>
                </td>
                <td>
                  <span style={{ fontWeight: 700, color: 'var(--primary-text)' }}>
                    ${w.usdValue.toFixed(2)}
                  </span>
                </td>
                <td>
                  <div style={{ fontSize: '13px', fontWeight: 500 }}>{w.method}</div>
                  <div style={{ fontSize: '11px', color: 'var(--secondary-text)' }}>{renderDestination(w)}</div>
                </td>
                <td>
                  <div style={{ fontSize: '12px' }}>
                    NC: <span style={{ color: 'var(--success)', fontWeight: 600 }}>${w.nobleCardsFee.toFixed(2)}</span>
                  </div>
                </td>
                <td>
                  <span className={`nc-badge badge-${w.status.toLowerCase()}`}>
                    {w.status}
                  </span>
                </td>
                <td>
                  <span className={`nc-badge badge-risk-${w.risk.toLowerCase().replace(' ', '-')}`}>
                    {w.risk}
                  </span>
                </td>
                <td>
                  <div style={{ fontSize: '12.5px' }}>{new Date(w.date).toLocaleDateString()}</div>
                  <div style={{ fontSize: '11px', color: 'var(--secondary-text)' }}>
                    {new Date(w.date).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                  </div>
                </td>
                <td style={{ textAlign: 'right' }}>
                  <div style={{ display: 'inline-flex', gap: '6px' }}>
                    <button className="nc-btn nc-btn-sm" onClick={() => onSelectWithdrawal(w)}>
                      <i className='bx bx-show'></i>
                    </button>
                    {w.status === 'Pending' && (
                      <button className="nc-btn nc-btn-sm nc-btn-danger" onClick={() => onOpenActionModal(w, 'Reject')}>
                        <i className='bx bx-x-circle'></i>
                      </button>
                    )}
                    {w.status === 'Failed' && (
                      <button className="nc-btn nc-btn-sm" onClick={() => onOpenActionModal(w, 'Retry')}>
                        <i className='bx bx-refresh'></i>
                      </button>
                    )}
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Pagination Footer */}
      <div className="nc-pagination">
        <div className="nc-pagination-info">
          Showing {totalItems === 0 ? 0 : (currentPage - 1) * pageSize + 1} to {Math.min(currentPage * pageSize, totalItems)} of {totalItems} entries
        </div>
        <div className="nc-pagination-controls">
          <select 
            className="nc-filter-select" 
            style={{ padding: '4px 8px', fontSize: '12px' }}
            value={pageSize}
            onChange={(e) => onPageSizeChange(Number(e.target.value))}
          >
            <option value={10}>10 per page</option>
            <option value={25}>25 per page</option>
            <option value={50}>50 per page</option>
          </select>

          <button 
            className="nc-btn nc-btn-sm" 
            disabled={currentPage === 1}
            onClick={() => onPageChange(currentPage - 1)}
          >
            <i className='bx bx-chevron-left'></i>
          </button>
          <span style={{ fontSize: '13px', margin: '0 8px', color: 'var(--primary-text)', fontWeight: 600 }}>
            Page {currentPage} of {totalPages}
          </span>
          <button 
            className="nc-btn nc-btn-sm" 
            disabled={currentPage === totalPages || totalPages === 0}
            onClick={() => onPageChange(currentPage + 1)}
          >
            <i className='bx bx-chevron-right'></i>
          </button>
        </div>
      </div>
    </div>
  );
};

export default WithdrawalTable;