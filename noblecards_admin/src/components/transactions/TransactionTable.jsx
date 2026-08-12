import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';

const TransactionTable = ({ 
  transactions, 
  onViewDetails, 
  onInitiateRefund, 
  sortField, 
  sortOrder, 
  onSort 
}) => {
  const navigate = useNavigate();
  const [openDropdownId, setOpenDropdownId] = useState(null);

  const getStatusBadgeClass = (status) => {
    switch (status) {
      case 'Successful': return 'gc-badge-active';
      case 'Pending':
      case 'Processing': return 'gc-badge-warning';
      case 'Failed':
      case 'Cancelled': return 'gc-badge-inactive';
      case 'Refunded':
      case 'Reversed': return 'gc-badge-blue';
      case 'Disputed':
      case 'Chargeback': return 'gc-badge-red';
      default: return 'gc-badge-neutral';
    }
  };

  const renderSortIcon = (field) => {
    if (sortField !== field) return <i className="bx bx-hash tx-sort-icon"></i>;
    return sortOrder === 'asc' 
      ? <i className="bx bx-chevron-up tx-sort-icon-active"></i> 
      : <i className="bx bx-chevron-down tx-sort-icon-active"></i>;
  };

  const formatOriginalAmount = (amount, currency) => {
    if (currency === 'NGN') return `₦${amount.toLocaleString()}`;
    if (currency === 'EUR') return `€${amount.toLocaleString()}`;
    if (currency === 'GBP') return `£${amount.toLocaleString()}`;
    if (currency === 'USDT') return `${amount.toLocaleString()} USDT`;
    return `$${amount.toLocaleString()}`;
  };

  return (
    <div className="gc-table-container">
      <table className="gc-table">
        <thead>
          <tr>
            <th onClick={() => onSort('id')} className="tx-sortable">
              Tx ID {renderSortIcon('id')}
            </th>
            <th onClick={() => onSort('userName')} className="tx-sortable">
              User {renderSortIcon('userName')}
            </th>
            <th>Category & Type</th>
            <th onClick={() => onSort('originalAmount')} className="tx-sortable">
              Original Amount {renderSortIcon('originalAmount')}
            </th>
            <th onClick={() => onSort('usdValue')} className="tx-sortable">
              USD Value {renderSortIcon('usdValue')}
            </th>
            <th>Payment Method</th>
            <th onClick={() => onSort('status')} className="tx-sortable">
              Status {renderSortIcon('status')}
            </th>
            <th onClick={() => onSort('date')} className="tx-sortable">
              Date {renderSortIcon('date')}
            </th>
            <th style={{ textAlign: 'right' }}>Actions</th>
          </tr>
        </thead>
        <tbody>
          {transactions.map(tx => (
            <tr key={tx.id}>
              <td className="tx-font-mono">{tx.id}</td>
              <td>
                <div className="tx-user-cell">
                  <img src={tx.userAvatar} alt={tx.userName} className="tx-avatar" />
                  <div>
                    <div className="tx-user-name">{tx.userName}</div>
                    <div className="tx-user-id">{tx.userId}</div>
                  </div>
                </div>
              </td>
              <td>
                <div style={{ fontWeight: 600, fontSize: '13px' }}>{tx.type}</div>
                <div style={{ fontSize: '11px', color: 'var(--secondary-text)' }}>{tx.category}</div>
              </td>
              <td style={{ fontWeight: 600 }}>
                {formatOriginalAmount(tx.originalAmount, tx.currency)}
              </td>
              <td className="tx-usd-highlight">
                ${tx.usdValue.toLocaleString(undefined, { minimumFractionDigits: 2 })}
              </td>
              <td>
                <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                  <i className="bx bx-credit-card-front" style={{ color: 'var(--secondary-text)' }}></i>
                  <span>{tx.paymentMethod}</span>
                </div>
              </td>
              <td>
                <span className={`gc-badge ${getStatusBadgeClass(tx.status)}`}>
                  {tx.status}
                </span>
              </td>
              <td style={{ fontSize: '12px', color: 'var(--secondary-text)' }}>
                {new Date(tx.date).toLocaleDateString()} {new Date(tx.date).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
              </td>
              <td style={{ textAlign: 'right' }}>
                <div className="gc-action-dropdown">
                  <button 
                    className="gc-action-btn"
                    onClick={() => setOpenDropdownId(openDropdownId === tx.id ? null : tx.id)}
                  >
                    <i className="bx bx-dots-vertical-rounded"></i>
                  </button>

                  {openDropdownId === tx.id && (
                    <div className="gc-dropdown-menu">
                      <button className="gc-dropdown-item" onClick={() => { onViewDetails(tx); setOpenDropdownId(null); }}>
                        <i className="bx bx-show"></i> View Details
                      </button>
                      <button className="gc-dropdown-item" onClick={() => { navigate(`/users/${tx.userId}`); setOpenDropdownId(null); }}>
                        <i className="bx bx-user"></i> View User
                      </button>
                      {tx.giftCardDetails && (
                        <button className="gc-dropdown-item" onClick={() => { navigate('/gift-cards'); setOpenDropdownId(null); }}>
                          <i className="bx bx-gift"></i> View Gift Card
                        </button>
                      )}
                      {tx.status === 'Successful' && (
                        <button className="gc-dropdown-item gc-text-danger" onClick={() => { onInitiateRefund(tx); setOpenDropdownId(null); }}>
                          <i className="bx bx-undo"></i> Issue Refund
                        </button>
                      )}
                    </div>
                  )}
                </div>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default TransactionTable;