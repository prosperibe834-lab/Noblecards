import React, { useState } from 'react';

const RefundModal = ({ isOpen, onClose, transaction, onConfirmRefund }) => {
  const [reason, setReason] = useState('Duplicate Charge');
  const [customNotes, setCustomNotes] = useState('');

  if (!isOpen || !transaction) return null;

  const handleConfirm = () => {
    onConfirmRefund(transaction.id, { reason, customNotes });
    onClose();
  };

  return (
    <div className="gc-modal-overlay">
      <div className="gc-modal-content" style={{ maxWidth: '480px' }}>
        <div className="gc-modal-header">
          <h2 className="gc-modal-title" style={{ color: 'var(--error)' }}>
            <i className="bx bx-error-circle"></i> Confirm Transaction Refund
          </h2>
          <button className="gc-close-btn" onClick={onClose}>&times;</button>
        </div>

        <div style={{ margin: '16px 0', fontSize: '14px', color: 'var(--primary-text)' }}>
          Are you sure you want to refund transaction <strong>{transaction.id}</strong>?
          <div className="tx-refund-summary-box">
            <div>User: <strong>{transaction.userName}</strong></div>
            <div>Refund Amount: <strong style={{ color: 'var(--primary-green)' }}>${transaction.usdValue.toFixed(2)} USD</strong></div>
            <div>Payment Method: <strong>{transaction.paymentMethod}</strong></div>
          </div>
        </div>

        <div className="gc-form-group" style={{ marginBottom: '12px' }}>
          <label>Reason for Refund</label>
          <select value={reason} onChange={(e) => setReason(e.target.value)}>
            <option value="Duplicate Charge">Duplicate Charge</option>
            <option value="User Requested">User Requested Cancellation</option>
            <option value="Unfulfilled Order">Unfulfilled Gift Card Order</option>
            <option value="System Error">System / Gateway Error</option>
          </select>
        </div>

        <div className="gc-form-group" style={{ marginBottom: '16px' }}>
          <label>Additional Audit Notes</label>
          <textarea 
            rows="2" 
            placeholder="Reason details for compliance audit logs..." 
            value={customNotes} 
            onChange={(e) => setCustomNotes(e.target.value)} 
          />
        </div>

        <div className="gc-modal-footer">
          <button className="gc-btn gc-btn-secondary" onClick={onClose}>Cancel</button>
          <button className="gc-btn gc-btn-primary" style={{ background: 'var(--error)' }} onClick={handleConfirm}>
            Confirm & Issue Refund
          </button>
        </div>
      </div>
    </div>
  );
};

export default RefundModal;