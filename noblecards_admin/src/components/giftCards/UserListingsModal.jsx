import React, { useState } from 'react';

const UserListingsModal = ({ isOpen, onClose, card }) => {
  const [showCodeId, setShowCodeId] = useState(null);
  const [rejectionModal, setRejectionModal] = useState({ isOpen: false, tradeId: null, reason: '' });

  // Sample pending user trades submitted on NobleCards
  const [userTrades, setUserTrades] = useState([
    {
      id: 'TRD-88219',
      user: 'Prosper E.',
      email: 'prosper@example.com',
      cardName: card?.name || 'Amazon Gift Card',
      amount: 100,
      code: 'AMZN-9821-4410-0912',
      pin: '4829',
      payoutAmount: 85.00,
      submittedAt: '2026-08-12 11:30 AM',
      status: 'Pending'
    },
    {
      id: 'TRD-88220',
      user: 'Monica K.',
      email: 'monica@example.com',
      cardName: card?.name || 'Amazon Gift Card',
      amount: 50,
      code: 'AMZN-1102-9984-3321',
      pin: '1029',
      payoutAmount: 42.50,
      submittedAt: '2026-08-12 12:15 PM',
      status: 'Pending'
    }
  ]);

  if (!isOpen || !card) return null;

  const toggleCodeVisibility = (tradeId) => {
    setShowCodeId(showCodeId === tradeId ? null : tradeId);
  };

  const handleApprove = (tradeId) => {
    setUserTrades(prev => prev.map(t => t.id === tradeId ? { ...t, status: 'Approved' } : t));
  };

  const handleOpenReject = (tradeId) => {
    setRejectionModal({ isOpen: true, tradeId, reason: '' });
  };

  const handleConfirmReject = () => {
    if (!rejectionModal.reason.trim()) return;
    setUserTrades(prev => prev.map(t => t.id === rejectionModal.tradeId ? { ...t, status: 'Rejected', rejectionReason: rejectionModal.reason } : t));
    setRejectionModal({ isOpen: false, tradeId: null, reason: '' });
  };

  return (
    <div className="gc-modal-overlay">
      <div className="gc-modal-content gc-modal-large">
        <div className="gc-modal-header">
          <div>
            <h2 className="gc-modal-title" style={{ margin: 0 }}>Pending Trade Verification</h2>
            <span style={{ color: 'var(--secondary-text)', fontSize: '13px' }}>Product: {card.name}</span>
          </div>
          <button className="gc-close-btn" onClick={onClose}>&times;</button>
        </div>

        <div className="gc-table-container" style={{ marginTop: '16px' }}>
          <table className="gc-table">
            <thead>
              <tr>
                <th>Trade ID</th>
                <th>User</th>
                <th>Value</th>
                <th>Card Code / PIN</th>
                <th>Payout</th>
                <th>Status</th>
                <th style={{ textAlign: 'right' }}>Actions</th>
              </tr>
            </thead>
            <tbody>
              {userTrades.map(trade => (
                <tr key={trade.id}>
                  <td style={{ fontWeight: 600 }}>{trade.id}</td>
                  <td>
                    <div>{trade.user}</div>
                    <div style={{ fontSize: '11px', color: 'var(--secondary-text)' }}>{trade.email}</div>
                  </td>
                  <td>${trade.amount}</td>
                  <td>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                      <span style={{ fontFamily: 'monospace' }}>
                        {showCodeId === trade.id ? `${trade.code} (PIN: ${trade.pin})` : '•••• •••• •••• ' + trade.code.slice(-4)}
                      </span>
                      <button 
                        onClick={() => toggleCodeVisibility(trade.id)} 
                        style={{ background: 'none', border: 'none', cursor: 'pointer', color: 'var(--primary-text)' }}
                      >
                        <i className={`bx ${showCodeId === trade.id ? 'bx-hide' : 'bx-show'}`}></i>
                      </button>
                    </div>
                  </td>
                  <td style={{ color: 'var(--primary-green)', fontWeight: 600 }}>${trade.payoutAmount.toFixed(2)}</td>
                  <td>
                    <span className={`gc-badge gc-badge-${trade.status.toLowerCase()}`}>
                      {trade.status}
                    </span>
                  </td>
                  <td style={{ textAlign: 'right' }}>
                    {trade.status === 'Pending' ? (
                      <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '6px' }}>
                        <button className="gc-btn gc-btn-secondary" style={{ padding: '4px 8px' }} onClick={() => handleApprove(trade.id)}>
                          <i className="bx bx-check" style={{ color: 'var(--primary-green)' }}></i>
                        </button>
                        <button className="gc-btn gc-btn-secondary" style={{ padding: '4px 8px' }} onClick={() => handleOpenReject(trade.id)}>
                          <i className="bx bx-x" style={{ color: 'var(--error)' }}></i>
                        </button>
                      </div>
                    ) : (
                      <span style={{ fontSize: '12px', color: 'var(--secondary-text)' }}>Completed</span>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        {rejectionModal.isOpen && (
          <div style={{ marginTop: '20px', padding: '16px', background: 'var(--background)', borderRadius: '8px', border: '1px solid var(--error)' }}>
            <h4 style={{ margin: '0 0 8px 0', color: 'var(--error)' }}>Reason for Rejection</h4>
            <textarea 
              rows="3" 
              placeholder="Provide a reason (e.g., Code already redeemed, Invalid card balance)..." 
              value={rejectionModal.reason} 
              onChange={(e) => setRejectionModal({ ...rejectionModal, reason: e.target.value })}
              style={{ width: '100%', padding: '8px', borderRadius: '6px', border: '1px solid var(--border)', marginBottom: '12px' }}
            />
            <div style={{ display: 'flex', gap: '8px', justifyContent: 'flex-end' }}>
              <button className="gc-btn gc-btn-secondary" onClick={() => setRejectionModal({ isOpen: false, tradeId: null, reason: '' })}>Cancel</button>
              <button className="gc-btn gc-btn-primary" style={{ background: 'var(--error)' }} onClick={handleConfirmReject}>Confirm Rejection</button>
            </div>
          </div>
        )}

        <div className="gc-modal-footer" style={{ marginTop: '20px' }}>
          <button className="gc-btn gc-btn-secondary" onClick={onClose}>Close Window</button>
        </div>
      </div>
    </div>
  );
};

export default UserListingsModal;