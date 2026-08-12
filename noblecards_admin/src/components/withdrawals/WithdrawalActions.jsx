import React from 'react';

const WithdrawalActions = ({ actionData, onClose, onConfirm }) => {
  if (!actionData) return null;
  const { withdrawal, type } = actionData;

  return (
    <div className="nc-modal-centered" onClick={onClose}>
      <div className="nc-modal-box" onClick={(e) => e.stopPropagation()}>
        <div style={{ fontSize: '36px', color: 'var(--error)', marginBottom: '12px', textAlign: 'center' }}>
          <i className='bx bx-error-circle'></i>
        </div>
        <h3 style={{ fontSize: '18px', textAlign: 'center', margin: '0 0 8px 0', color: 'var(--primary-text)' }}>
          Confirm {type} Action
        </h3>
        <p style={{ fontSize: '13.5px', color: 'var(--secondary-text)', textAlign: 'center', margin: '0 0 20px 0' }}>
          Are you sure you want to <strong>{type.toLowerCase()}</strong> withdrawal request <strong>{withdrawal.id}</strong> for user <strong>{withdrawal.userName}</strong>?
        </p>

        <div className="nc-detail-card" style={{ marginBottom: '20px' }}>
          <div className="nc-detail-row">
            <span className="nc-detail-label">Amount</span>
            <span className="nc-detail-val">{withdrawal.currency} {withdrawal.originalAmount.toLocaleString()} (${withdrawal.usdValue.toFixed(2)} USD)</span>
          </div>
          <div className="nc-detail-row">
            <span className="nc-detail-label">Method</span>
            <span className="nc-detail-val">{withdrawal.method}</span>
          </div>
        </div>

        <div style={{ display: 'flex', gap: '12px' }}>
          <button className="nc-btn" style={{ flex: 1 }} onClick={onClose}>
            Cancel
          </button>
          <button className="nc-btn nc-btn-danger" style={{ flex: 1 }} onClick={() => onConfirm(withdrawal.id, type)}>
            Confirm {type}
          </button>
        </div>
      </div>
    </div>
  );
};

export default WithdrawalActions;