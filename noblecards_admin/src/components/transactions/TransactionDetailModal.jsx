import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';

const TransactionDetailModal = ({ isOpen, onClose, transaction, onUpdateNotes }) => {
  const navigate = useNavigate();
  const [notes, setNotes] = useState(transaction?.internalNotes || '');
  const [isSaved, setIsSaved] = useState(false);

  if (!isOpen || !transaction) return null;

  const handleSaveNotes = () => {
    onUpdateNotes(transaction.id, notes);
    setIsSaved(true);
    setTimeout(() => setIsSaved(false), 2000);
  };

  return (
    <div className="gc-modal-overlay">
      <div className="gc-modal-content tx-modal-drawer">
        <div className="gc-modal-header">
          <div>
            <h2 className="gc-modal-title" style={{ margin: 0 }}>Transaction Details</h2>
            <span style={{ color: 'var(--secondary-text)', fontSize: '13px' }}>ID: {transaction.id}</span>
          </div>
          <button className="gc-close-btn" onClick={onClose}>&times;</button>
        </div>

        <div className="tx-drawer-body">
          {/* User Information */}
          <div className="tx-section-card">
            <h4 className="tx-section-title"><i className="bx bx-user"></i> User Information</h4>
            <div className="tx-user-profile-header">
              <img src={transaction.userAvatar} alt={transaction.userName} className="tx-avatar-large" />
              <div>
                <div style={{ fontWeight: 700, fontSize: '16px' }}>{transaction.userName}</div>
                <div style={{ fontSize: '12px', color: 'var(--secondary-text)' }}>{transaction.userEmail} • {transaction.userPhone}</div>
                <div style={{ fontSize: '12px', color: 'var(--secondary-text)' }}>User ID: {transaction.userId}</div>
              </div>
              <button className="gc-btn gc-btn-secondary" style={{ marginLeft: 'auto' }} onClick={() => navigate(`/users/${transaction.userId}`)}>
                View User
              </button>
            </div>
          </div>

          {/* Financial Breakdown & FX Snapshot */}
          <div className="tx-section-card">
            <h4 className="tx-section-title"><i className="bx bx-dollar-circle"></i> Financial Breakdown & FX Snapshot</h4>
            <div className="tx-grid-two">
              <div>
                <span className="tx-label">Original Amount</span>
                <div className="tx-value">{transaction.originalAmount.toLocaleString()} {transaction.currency}</div>
              </div>
              <div>
                <span className="tx-label">USD Equivalent Value</span>
                <div className="tx-value tx-usd-highlight">${transaction.usdValue.toFixed(2)} USD</div>
              </div>
              <div>
                <span className="tx-label">Reference Exchange Rate</span>
                <div className="tx-value">1 USD = {transaction.referenceRate} {transaction.currency}</div>
              </div>
              <div>
                <span className="tx-label">NobleCards Applied Rate</span>
                <div className="tx-value">1 USD = {transaction.appliedRate} {transaction.currency} (Markup: {transaction.markup})</div>
              </div>
            </div>

            <hr className="tx-divider" />

            <div className="tx-fee-summary">
              <div className="tx-fee-row"><span>Gross Amount:</span> <strong>${transaction.grossAmount.toFixed(2)}</strong></div>
              <div className="tx-fee-row"><span>Platform Fee:</span> <strong>-${transaction.platformFee.toFixed(2)}</strong></div>
              <div className="tx-fee-row"><span>Provider Fee:</span> <strong>-${transaction.providerFee.toFixed(2)}</strong></div>
              <div className="tx-fee-row tx-fee-net"><span>Net Settled Amount:</span> <strong>${transaction.netAmount.toFixed(2)}</strong></div>
            </div>
          </div>

          {/* Source & Operational Details */}
          <div className="tx-section-card">
            <h4 className="tx-section-title"><i className="bx bx-cog"></i> Operational Details</h4>
            <div className="tx-grid-two">
              <div><span className="tx-label">Origin Source</span><div className="tx-value">{transaction.source}</div></div>
              <div><span className="tx-label">Processing Mode</span><div className="tx-value">{transaction.processingType}</div></div>
              <div><span className="tx-label">Risk Level Indicator</span><div className="tx-value">{transaction.riskFlag}</div></div>
              <div><span className="tx-label">Reconciliation Status</span><div className="tx-value">{transaction.reconciliationStatus}</div></div>
            </div>
          </div>

          {/* Wallet Impact */}
          <div className="tx-section-card">
            <h4 className="tx-section-title"><i className="bx bx-wallet"></i> Wallet Ledger Snapshot</h4>
            <div className="tx-wallet-row">
              <div><span>Balance Before:</span> <strong>${transaction.walletBefore.toFixed(2)}</strong></div>
              <div><i className="bx bx-right-arrow-alt"></i></div>
              <div><span>Balance After:</span> <strong>${transaction.walletAfter.toFixed(2)}</strong></div>
            </div>
          </div>

          {/* Timeline */}
          <div className="tx-section-card">
            <h4 className="tx-section-title"><i className="bx bx-time"></i> Transaction Timeline</h4>
            <div className="tx-timeline">
              {transaction.timeline.map((item, idx) => (
                <div key={idx} className={`tx-timeline-item ${item.status}`}>
                  <div className="tx-timeline-node"></div>
                  <div className="tx-timeline-content">
                    <div style={{ fontWeight: 600 }}>{item.step}</div>
                    <div style={{ fontSize: '11px', color: 'var(--secondary-text)' }}>{item.time}</div>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Internal Notes */}
          <div className="tx-section-card">
            <h4 className="tx-section-title"><i className="bx bx-note"></i> Admin Internal Notes</h4>
            <textarea 
              rows="3" 
              value={notes} 
              onChange={(e) => setNotes(e.target.value)} 
              placeholder="Add internal notes visible only to admins..."
              className="tx-notes-textarea"
            />
            <div style={{ display: 'flex', justifyContent: 'flex-end', marginTop: '8px' }}>
              <button className="gc-btn gc-btn-primary" onClick={handleSaveNotes}>
                {isSaved ? 'Notes Saved!' : 'Save Notes'}
              </button>
            </div>
          </div>
        </div>

        <div className="gc-modal-footer">
          <button className="gc-btn gc-btn-secondary" onClick={onClose}>Close Window</button>
        </div>
      </div>
    </div>
  );
};

export default TransactionDetailModal;