import React, { useState } from 'react';

export const DepositDetailsModal = ({
  deposit,
  onClose,
  onViewUser,
  onActionSuccess
}) => {
  const [confirmCancelModal, setConfirmCancelModal] = useState(false);
  const [confirmRetryModal, setConfirmRetryModal] = useState(false);
  const [actionLoading, setActionLoading] = useState(false);

  if (!deposit) return null;

  const handleConfirmCancel = () => {
    setActionLoading(true);
    setTimeout(() => {
      setActionLoading(false);
      setConfirmCancelModal(false);
      onActionSuccess(deposit.id, 'Cancelled');
    }, 1000);
  };

  const handleConfirmRetry = () => {
    setActionLoading(true);
    setTimeout(() => {
      setActionLoading(false);
      setConfirmRetryModal(false);
      onActionSuccess(deposit.id, 'Processing');
    }, 1000);
  };

  return (
    <div className="deposit-modal-backdrop" onClick={onClose}>
      <div className="deposit-drawer" onClick={(e) => e.stopPropagation()}>
        {/* Drawer Header */}
        <div className="drawer-header">
          <div className="drawer-title-group">
            <h3>Deposit Details</h3>
            <span className="drawer-id-tag">{deposit.id}</span>
          </div>
          <button className="drawer-close-btn" onClick={onClose}>
            <i className="bx bx-x"></i>
          </button>
        </div>

        {/* Drawer Content Body */}
        <div className="drawer-body">
          {/* Status Banner */}
          <div className={`status-summary-banner status-${deposit.status.toLowerCase()}`}>
            <div className="banner-left">
              <span className="status-label-text">Current Status</span>
              <span className="status-title">{deposit.status}</span>
            </div>
            <div className="banner-right text-right">
              <span className="banner-sub">Created On</span>
              <span>{new Date(deposit.createdAt).toLocaleString()}</span>
            </div>
          </div>

          {/* User Profile Card */}
          <div className="detail-section-card">
            <div className="section-title">
              <i className="bx bx-user-circle"></i> User Information
            </div>
            <div className="user-drawer-card">
              <img src={deposit.avatar} alt={deposit.userName} className="user-drawer-avatar" />
              <div className="user-drawer-details">
                <h4>{deposit.userName}</h4>
                <p>{deposit.userTag} • ID: <code>{deposit.userId}</code></p>
                <p className="sub-contact"><i className="bx bx-envelope"></i> {deposit.email} | <i className="bx bx-phone"></i> {deposit.phone}</p>
              </div>
              <button 
                className="view-user-btn"
                onClick={() => onViewUser(deposit.userId)}
              >
                <i className="bx bx-user"></i> View Profile
              </button>
            </div>
          </div>

          {/* Financial Breakdown */}
          <div className="detail-section-card">
            <div className="section-title">
              <i className="bx bx-calculator"></i> Financial & Exchange Breakdown
            </div>
            <div className="financial-grid">
              <div className="fin-box">
                <span className="fin-label">Original Amount</span>
                <span className="fin-val">{deposit.originalAmount.toLocaleString()} {deposit.currency}</span>
              </div>
              <div className="fin-box">
                <span className="fin-label">USD Equivalent</span>
                <span className="fin-val highlight">${deposit.usdValue.toFixed(2)}</span>
              </div>
              <div className="fin-box">
                <span className="fin-label">Reference Exchange Rate</span>
                <span className="fin-val">{deposit.exchangeRate} {deposit.currency}/USD</span>
              </div>
              <div className="fin-box">
                <span className="fin-label">NobleCards Rate Used</span>
                <span className="fin-val">{deposit.nobleRate} {deposit.currency}/USD</span>
              </div>
              <div className="fin-box">
                <span className="fin-label">NobleCards Fee</span>
                <span className="fin-val">${deposit.fee.toFixed(2)}</span>
              </div>
              <div className="fin-box">
                <span className="fin-label">Provider Fee</span>
                <span className="fin-val">${deposit.providerFee.toFixed(2)}</span>
              </div>
              <div className="fin-box full-width highlight-box">
                <span className="fin-label">Net Credited Amount</span>
                <span className="fin-val text-success">${deposit.netAmount.toFixed(2)} USD</span>
              </div>
            </div>
          </div>

          {/* Method Details */}
          <div className="detail-section-card">
            <div className="section-title">
              <i className="bx bx-credit-card"></i> Deposit Method & Provider Details
            </div>
            <div className="method-details-list">
              <p><strong>Method:</strong> {deposit.method}</p>
              <p><strong>Provider:</strong> {deposit.provider}</p>
              <p><strong>Provider Reference:</strong> <code>{deposit.providerRef}</code></p>
              <p><strong>Payment Reference:</strong> <code>{deposit.paymentRef}</code></p>

              {deposit.bankDetails && (
                <div className="sub-detail-box">
                  <p><strong>Bank Name:</strong> {deposit.bankDetails.bankName}</p>
                  <p><strong>Account Name:</strong> {deposit.bankDetails.accountName}</p>
                  <p><strong>Masked Account:</strong> {deposit.bankDetails.maskedAccount}</p>
                </div>
              )}

              {deposit.cardDetails && (
                <div className="sub-detail-box">
                  <p><strong>Card Brand:</strong> {deposit.cardDetails.brand}</p>
                  <p><strong>Masked Card:</strong> {deposit.cardDetails.maskedCard}</p>
                  <p><strong>Expires:</strong> {deposit.cardDetails.expDate}</p>
                </div>
              )}

              {deposit.cryptoDetails && (
                <div className="sub-detail-box">
                  <p><strong>Asset & Network:</strong> {deposit.cryptoDetails.asset} ({deposit.cryptoDetails.network})</p>
                  <p><strong>Deposit Wallet Address:</strong> <code>{deposit.cryptoDetails.walletAddress}</code></p>
                  <p><strong>TX Hash:</strong> <code>{deposit.cryptoDetails.txHash}</code></p>
                </div>
              )}
            </div>
          </div>

          {/* Wallet Balance Snapshot */}
          <div className="detail-section-card">
            <div className="section-title">
              <i className="bx bx-wallet"></i> Wallet Balance Snapshot
            </div>
            <div className="wallet-snapshot-flex">
              <div className="snap-item">
                <span>Before</span>
                <strong>${deposit.walletSnapshot.balanceBefore.toFixed(2)}</strong>
              </div>
              <div className="snap-arrow"><i className="bx bx-right-arrow-alt"></i></div>
              <div className="snap-item highlight">
                <span>Deposit Net</span>
                <strong>+${deposit.walletSnapshot.depositAmount.toFixed(2)}</strong>
              </div>
              <div className="snap-arrow"><i className="bx bx-right-arrow-alt"></i></div>
              <div className="snap-item">
                <span>After</span>
                <strong>${deposit.walletSnapshot.balanceAfter.toFixed(2)}</strong>
              </div>
            </div>
          </div>

          {/* Reconciliation Section */}
          <div className="detail-section-card">
            <div className="section-title">
              <i className="bx bx-git-compare"></i> Financial Reconciliation
            </div>
            <div className="reconcile-box">
              <div className="rec-row">
                <span>Provider Amount:</span>
                <strong>${deposit.reconciliation.providerAmount.toFixed(2)}</strong>
              </div>
              <div className="rec-row">
                <span>Ledger Amount:</span>
                <strong>${deposit.reconciliation.ledgerAmount.toFixed(2)}</strong>
              </div>
              <div className="rec-row">
                <span>Variance Difference:</span>
                <strong className={deposit.reconciliation.difference !== 0 ? 'text-danger' : ''}>
                  ${deposit.reconciliation.difference.toFixed(2)}
                </strong>
              </div>
              <div className="rec-status-row">
                <span>Status:</span>
                <span className={`rec-tag ${deposit.reconciliation.status.toLowerCase()}`}>
                  {deposit.reconciliation.status}
                </span>
              </div>
            </div>
          </div>

          {/* Timeline */}
          <div className="detail-section-card">
            <div className="section-title">
              <i className="bx bx-time"></i> Transaction Timeline
            </div>
            <ul className="timeline-list">
              {deposit.timeline.map((step, idx) => (
                <li key={idx} className={`timeline-item ${step.completed ? 'completed' : ''} ${step.failed ? 'failed' : ''}`}>
                  <div className="timeline-icon">
                    {step.failed ? <i className="bx bx-x"></i> : <i className="bx bx-check"></i>}
                  </div>
                  <div className="timeline-content">
                    <span className="step-title">{step.step}</span>
                    <span className="step-time">{step.time}</span>
                  </div>
                </li>
              ))}
            </ul>
          </div>

          {/* Audit Trail */}
          <div className="detail-section-card">
            <div className="section-title">
              <i className="bx bx-shield-quarter"></i> System Audit Trail
            </div>
            <div className="audit-trail-list">
              {deposit.auditTrail.map((log, idx) => (
                <div key={idx} className="audit-item">
                  <div className="audit-header">
                    <strong>{log.event}</strong>
                    <span className="audit-time">{log.time}</span>
                  </div>
                  <p className="audit-desc">{log.description}</p>
                  <span className="audit-actor">Actor: {log.actor}</span>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Drawer Actions Footer */}
        <div className="drawer-footer">
          {deposit.status === 'Pending' && (
            <button 
              className="btn-modal-danger" 
              onClick={() => setConfirmCancelModal(true)}
            >
              <i className="bx bx-block"></i> Cancel Deposit
            </button>
          )}

          {deposit.status === 'Failed' && (
            <button 
              className="btn-modal-warning" 
              onClick={() => setConfirmRetryModal(true)}
            >
              <i className="bx bx-refresh"></i> Re-trigger Webhook / Retry
            </button>
          )}

          <button className="btn-modal-secondary" onClick={onClose}>
            Close
          </button>
        </div>
      </div>

      {/* Confirmation Modal for Cancellation */}
      {confirmCancelModal && (
        <div className="confirm-modal-overlay">
          <div className="confirm-modal-box">
            <h4><i className="bx bx-error-circle text-danger"></i> Cancel Deposit Request?</h4>
            <p>Are you sure you want to cancel deposit <strong>{deposit.id}</strong> for {deposit.userName} ({deposit.originalAmount} {deposit.currency})?</p>
            <div className="confirm-modal-actions">
              <button className="btn-modal-secondary" onClick={() => setConfirmCancelModal(false)}>Back</button>
              <button className="btn-modal-danger" onClick={handleConfirmCancel} disabled={actionLoading}>
                {actionLoading ? <i className="bx bx-loader-circle bx-spin"></i> : 'Confirm Cancellation'}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Confirmation Modal for Retry */}
      {confirmRetryModal && (
        <div className="confirm-modal-overlay">
          <div className="confirm-modal-box">
            <h4><i className="bx bx-refresh text-warning"></i> Re-trigger Webhook Processing?</h4>
            <p>This will attempt to re-verify payment reference <strong>{deposit.paymentRef}</strong> with {deposit.provider}.</p>
            <div className="confirm-modal-actions">
              <button className="btn-modal-secondary" onClick={() => setConfirmRetryModal(false)}>Back</button>
              <button className="btn-modal-primary" onClick={handleConfirmRetry} disabled={actionLoading}>
                {actionLoading ? <i className="bx bx-loader-circle bx-spin"></i> : 'Confirm Retry'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};